# POC-A: Armbian CB1 bootloader uses boot.scr. Do not import armbianEnv.txt.
# Address variables are supplied by the CB1 U-Boot environment, not guessed here.
if test -z "${kernel_addr_r}" || test -z "${fdt_addr_r}" || test -z "${ramdisk_addr_r}"; then
    echo "CB1 POC: missing U-Boot load address"
    exit
fi
if test -z "${devtype}" || test -z "${devnum}"; then
    echo "CB1 POC: missing boot device"
    exit
fi
if ! load ${devtype} ${devnum} ${fdt_addr_r} /boot/sun50i-h616-bigtreetech-cb1-batocera.dtb; then
    echo "CB1 POC: DTB missing"
    exit
fi
if ! load ${devtype} ${devnum} ${ramdisk_addr_r} /boot/initrd.lz4; then
    echo "CB1 POC: initrd missing"
    exit
fi
setenv cb1_ramdisk_size ${filesize}
if ! load ${devtype} ${devnum} ${kernel_addr_r} /boot/linux; then
    echo "CB1 POC: kernel missing"
    exit
fi
setenv bootargs "initrd=/boot/initrd.lz4 label=BATOCERA rootwait console=ttyS0,115200 loglevel=7 ignore_loglevel"
booti ${kernel_addr_r} ${ramdisk_addr_r}:${cb1_ramdisk_size} ${fdt_addr_r}
