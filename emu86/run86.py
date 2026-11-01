#!/usr/bin/env python3
"""run86.py - run the DOS tools on a Trio64-family card in 86Box, with our ROM or the card's own (#122).

    python3 emu86/run86.py --chip 775|765|764 [--rom OUR.BIN] [--vram 1|2|4] [--cmd RUNALL]
                           [--box 86Box] [--roms ROMDIR] [--freedos x86BOOT.img] [--tools build]
                           [--out emu86/logs/775] [--timeout 3600] [-v]

86Box (https://86box.net) emulates a PC with the S3 Trio64, Trio64V+ or Trio64V2/DX on its PCI bus and
boots the card's video BIOS image, with all of its video memory, banking, the linear frame buffer and the
graphics engine. emu/ models registers and one 64 KB window; 86Box adds the memory paths and whole
programs. Neither models bus timing, the display FIFO or the RAMDAC beyond the data books, so the cards
still decide.

What it does
  1. A VM folder in a temporary directory with 86box.cfg: the ASUS P/I-P55T2P4 (430HX, Socket 7, PCI),
     a Pentium 133, 16 MB, the card (86Box device, its BIOS choice and --vram), a 1.44 MB floppy and a
     64 MB IDE disk.
  2. The ROM: 86Box reads the card's image from its ROM set (--roms, a clone of github.com/86Box/roms).
     With --rom, the VM gets a ROM folder of links to that set in which the card's file is ours; without,
     the card runs the image 86Box ships (the stock BIOS of that 86Box device).
  3. The floppy: FreeDOS 1.4's boot disk (FD14-FloppyEdition.zip, 144m/x86BOOT.img) with its
     FDCONFIG.SYS and FDAUTO.BAT replaced: no menu, PATH to its BIN folder, then C:\\T64 and --cmd
     (RUNALL.BAT by default), then a marker line.
  4. The disk: one FAT16 partition with the tools of --tools (make tools: the .COM files, S3REGS32.EXE,
     RUNALL.BAT, CLEAN.BAT, ZIP.EXE) in C:\\T64.
  5. 86Box with --automation (doc/specifications/automation.md in 86Box): held at start, then run fast
     forward until the marker is on the screen or --timeout seconds of emulated time pass; a screenshot;
     power off.
  6. The files of C:\\T64 that the run wrote (logs, .DBG, S3REGS.TXT, VGALOG.BIN, RUNALL.ZIP) are copied
     to --out, with SCREEN.PNG, 86box.cfg and run86.log (the automation exchange).

Needs: an 86Box built with AUTOMATION=ON (cmake -DAUTOMATION=ON; the SDL front end, QT=OFF, runs
headless here with SDL_VIDEODRIVER=dummy), mtools and mkfs.fat (dosfstools). Exit code 0 when the
marker appeared, 1 otherwise.
"""
import argparse, json, os, shutil, socket, struct, subprocess, sys, tempfile, time

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)

# chip code: (86Box device internal name, its config section (device name), BIOS choice, ROM file in the set)
CARDS = {
    '775': ('s3_trio64v2dx_pci', 'S3 Trio64V2/DX PCI', 'trio64v2dx_pci', 'video/s3/86c775_2.bin'),
    '765': ('s3_trio64vplus_pci', 'S3 Trio64V+ PCI', 'px_trio64vplus_pci', 'video/s3/64V1506.ROM'),
    '764': ('s3_trio64_pci', 'S3 Trio64 PCI', 'px_trio64_pci', 'video/s3/86c764x1.bin'),
}
DONE = 'T64RUN-DONE'
HDD = (63, 16, 130)                     # sectors per track, heads, cylinders: 64 MB
PART_LBA = 63                           # the partition starts at cylinder 0, head 1


def log(f, s):
    f.write(s + '\n')
    f.flush()


def rom_overlay(roms, rel, ours, dest):
    """A ROM folder like `roms` (links) in which `rel` is `ours`."""
    os.makedirs(dest)
    parts = rel.split('/')
    src, dst = roms, dest
    for depth, name in enumerate(parts):
        for e in os.listdir(src):
            if e != name:
                os.symlink(os.path.join(src, e), os.path.join(dst, e))
        src, dst = os.path.join(src, name), os.path.join(dst, name)
        if depth < len(parts) - 1:
            os.makedirs(dst)
    shutil.copyfile(ours, dst)


def make_floppy(base, dest, cmd):
    shutil.copyfile(base, dest)
    cfg = 'FILES=40\r\nBUFFERS=20\r\nLASTDRIVE=Z\r\nSHELL=A:\\FREEDOS\\BIN\\COMMAND.COM A:\\ /E:1024 /P=A:\\FDAUTO.BAT\r\n'
    bat = ('@echo off\r\nset PATH=A:\\FREEDOS\\BIN\r\nset DOSDIR=A:\\FREEDOS\r\nC:\r\ncd \\T64\r\n'
           'call %s\r\necho %s\r\n' % (cmd, DONE))
    for name, text in (('FDCONFIG.SYS', cfg), ('FDAUTO.BAT', bat)):
        p = dest + '.' + name
        with open(p, 'w', newline='') as f:
            f.write(text)
        subprocess.run(['mcopy', '-o', '-i', dest, p, '::/' + name], check=True)
        os.remove(p)


def make_disk(dest, tools):
    spt, hpc, cyl = HDD
    total = spt * hpc * cyl
    with open(dest, 'wb') as f:
        f.truncate(total * 512)
    n = total - PART_LBA

    def chs(lba):
        c, r = divmod(lba, spt * hpc)
        h, s = divmod(r, spt)
        return bytes([h, ((c >> 2) & 0xC0) | (s + 1), c & 0xFF])
    entry = b'\x80' + chs(PART_LBA) + b'\x06' + chs(total - 1) + struct.pack('<II', PART_LBA, n)
    with open(dest, 'r+b') as f:
        f.seek(446)
        f.write(entry + bytes(48) + b'\x55\xAA')
    subprocess.run(['mkfs.fat', '-F', '16', '-n', 'T64', '--offset', str(PART_LBA), '-h', str(PART_LBA),
                    '-S', '512', '-g', '%d/%d' % (hpc, spt), dest, str(n // 2)], check=True, stdout=subprocess.DEVNULL)
    img = '%s@@%d' % (dest, PART_LBA * 512)
    subprocess.run(['mmd', '-i', img, '::/T64'], check=True)
    names = ['VSHOW.COM', 'S3TEST.COM', 'S3COMPAT.COM', 'S3ALIAS.COM', 'VGALOG.COM', 'S3REGS.COM',
             'S3REGS32.EXE', 'RUNALL.BAT', 'CLEAN.BAT', 'ZIP.EXE']
    for n_ in names:
        subprocess.run(['mcopy', '-i', img, os.path.join(tools, n_), '::/T64/' + n_], check=True)
    return img, set(names)


def write_cfg(vm, card, vram, floppy, disk):
    dev, section, bios, _ = card
    spt, hpc, cyl = HDD
    with open(os.path.join(vm, '86box.cfg'), 'w') as f:
        f.write('[General]\nconfirm_exit = 0\nconfirm_reset = 0\nconfirm_save = 0\nupdate_check = 0\n'
                '\n'
                '[Machine]\nmachine = p55t2p4\ncpu_family = pentium_p54c\ncpu_speed = 133333333\n'
                'cpu_use_dynarec = 1\nmem_size = 16384\ntime_sync = disabled\n\n'
                '[Video]\ngfxcard = %s\n\n[%s]\nbios = %s\nmemory = %d\n\n'
                
                '[Hard disks]\nhdd_01_parameters = %d, %d, %d, 0, ide\nhdd_01_fn = %s\nhdd_01_ide_channel = 0:0\n\n'
                '[Floppy and CD-ROM drives]\nfdd_01_type = 35_2hd\nfdd_01_fn = %s\nfdd_02_type = none\n\n'
                '[Sound]\nsndcard = none\n\n[Network]\nnet_01_card = none\n'
                % (dev, section, bios, vram, spt, hpc, cyl, disk, floppy))


class Automation:
    def __init__(self, path, logf, wait=60):
        self.logf = logf
        t0 = time.time()
        while True:
            try:
                self.s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
                self.s.connect(path)
                break
            except OSError:
                if time.time() - t0 > wait:
                    raise
                time.sleep(0.5)
        self.f = self.s.makefile('rb')

    def cmd(self, line):
        log(self.logf, '> ' + line)
        self.s.sendall(line.encode() + b'\n')
        r = self.f.readline().decode(errors='replace').strip()
        log(self.logf, '< ' + r[:2000])
        try:
            return json.loads(r)
        except ValueError:
            return {'ok': False, 'error': r}


def main():
    ap = argparse.ArgumentParser(description='run the DOS tools on a Trio64-family card in 86Box')
    ap.add_argument('--chip', choices=sorted(CARDS), required=True, help='775, 765 or 764 (README "Chip codes")')
    ap.add_argument('--rom', help='our ROM image (32 or 64 KB); without it the card runs 86Box\'s image')
    ap.add_argument('--vram', type=int, choices=(1, 2, 4), default=2, help='video memory in MB (default 2)')
    ap.add_argument('--cmd', default='RUNALL.BAT', help='what to run in C:\\T64 (default RUNALL.BAT)')
    ap.add_argument('--box', default=os.environ.get('BOX86', '86Box'), help='86Box executable (or BOX86)')
    ap.add_argument('--roms', default=os.environ.get('BOX86_ROMS', ''), help='86Box ROM set (or BOX86_ROMS)')
    ap.add_argument('--freedos', default=os.environ.get('FREEDOS_BOOT', ''),
                    help='FreeDOS 1.4 boot floppy, 144m/x86BOOT.img of FD14-FloppyEdition.zip (or FREEDOS_BOOT)')
    ap.add_argument('--tools', default=os.path.join(REPO, 'build'), help='folder with the built tools (make tools)')
    ap.add_argument('--out', help='where the logs go (default emu86/logs/<chip>[-stock])')
    ap.add_argument('--timeout', type=int, default=3600, help='seconds of emulated time at most (default 3600)')
    ap.add_argument('--keep', action='store_true', help='keep the VM folder (its path is printed)')
    a = ap.parse_args()
    for what, p in (('--roms', a.roms), ('--freedos', a.freedos)):
        if not p or not os.path.exists(p):
            ap.error('%s: not found (%r)' % (what, p))
    card = CARDS[a.chip]
    out = a.out or os.path.join(HERE, 'logs', a.chip + ('' if a.rom else '-stock'))
    os.makedirs(out, exist_ok=True)
    vm = tempfile.mkdtemp(prefix='t64-86box-')
    logf = open(os.path.join(out, 'run86.log'), 'w')
    try:
        roms = a.roms
        if a.rom:
            roms = os.path.join(vm, 'roms')
            rom_overlay(os.path.abspath(a.roms), card[3], os.path.abspath(a.rom), roms)
        floppy = os.path.join(vm, 'boot.img')
        make_floppy(a.freedos, floppy, a.cmd)
        disk = os.path.join(vm, 'c.img')
        img, before = make_disk(disk, os.path.abspath(a.tools))
        write_cfg(vm, card, a.vram, floppy, disk)
        shutil.copyfile(os.path.join(vm, '86box.cfg'), os.path.join(out, '86box.cfg'))
        sock = os.path.join(vm, 'auto.sock')
        env = dict(os.environ, SDL_VIDEODRIVER=os.environ.get('SDL_VIDEODRIVER', 'dummy'),
                   SDL_AUDIODRIVER=os.environ.get('SDL_AUDIODRIVER', 'dummy'))
        boxlog = open(os.path.join(out, '86box.log'), 'w')
        p = subprocess.Popen([a.box, '-P', vm, '-R', roms, '-N', '--automation', 'unix:' + sock,
                              '--automation-hold'], cwd=vm, env=env, stdout=boxlog, stderr=subprocess.STDOUT)
        try:
            au = Automation(sock, logf)
            au.cmd('info')
            au.cmd('ff on')
            r = au.cmd('wait text %d %s' % (a.timeout * 1000, DONE))
            ok = bool(r.get('matched'))
            au.cmd('status')
            au.cmd('screenshot ' + os.path.join(out, 'SCREEN.PNG'))
            au.cmd('quit')
        finally:
            try:
                p.wait(timeout=60)
            except subprocess.TimeoutExpired:
                p.kill()
        listing = subprocess.run(['mdir', '-b', '-i', img, '::/T64'], capture_output=True, text=True).stdout.split()
        got = []
        for path in listing:
            name = path.rsplit('/', 1)[-1].upper()
            if name in before:
                continue
            subprocess.run(['mcopy', '-n', '-i', img, path, os.path.join(out, name)], check=False)
            got.append(name)
        print('%s %s, %d MB: %s; %d files in %s' % (a.chip, os.path.basename(a.rom) if a.rom else 'stock ROM',
                                                     a.vram, 'done' if ok else 'NOT DONE (timeout or error)',
                                                     len(got), out))
        return 0 if ok else 1
    finally:
        logf.close()
        if a.keep:
            print('VM folder kept: ' + vm)
        else:
            shutil.rmtree(vm, ignore_errors=True)


if __name__ == '__main__':
    sys.exit(main())
