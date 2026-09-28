#!/bin/bash
set -euo pipefail

HOST_DIR=$1
BOARD_DIR=$2
BINARIES_DIR=$4
BATOCERA_BINARIES_DIR=$6
UBOOT_BIN=${CB1_UBOOT_BIN:-${BOARD_DIR}/u-boot-sunxi-with-spl.bin}

if [ ! -f "${UBOOT_BIN}" ] || [ "$(stat -c %s "${UBOOT_BIN}" 2>/dev/null || true)" != 740521 ]; then
    echo "CB1 POC: expected the verified 740521-byte Armbian CB1 bootloader at ${UBOOT_BIN}" >&2
    exit 1
fi
if [ "$(sha256sum "${UBOOT_BIN}" | cut -d' ' -f1)" != '376509471ccf407566ecddd11ae935f5ef6fcec662acdf5af6aee0f4285d0352' ]; then
    echo 'CB1 POC: U-Boot SHA256 mismatch; refusing to build image' >&2
    exit 1
fi
if [ "$(od -An -tx1 -j4 -N8 "${UBOOT_BIN}" | tr -d ' \n')" != '65474f4e2e425430' ]; then
    echo 'CB1 POC: invalid eGON.BT0 SPL header; refusing to build image' >&2
    exit 1
fi

mkdir -p "${BINARIES_DIR}/cb1-poc" "${BATOCERA_BINARIES_DIR}/boot/boot" "${BATOCERA_BINARIES_DIR}/boot/extlinux"
cp "${UBOOT_BIN}" "${BINARIES_DIR}/cb1-poc/u-boot-sunxi-with-spl.bin"
cp "${BINARIES_DIR}/Image" "${BATOCERA_BINARIES_DIR}/boot/boot/linux"
cp "${BINARIES_DIR}/initrd.lz4" "${BATOCERA_BINARIES_DIR}/boot/boot/initrd.lz4"
cp "${BINARIES_DIR}/rootfs.squashfs" "${BATOCERA_BINARIES_DIR}/boot/boot/batocera.update"
cp "${BINARIES_DIR}/rufomaculata" "${BATOCERA_BINARIES_DIR}/boot/boot/rufomaculata.update"
cp "${BINARIES_DIR}/sun50i-h616-bigtreetech-cb1-batocera.dtb" "${BATOCERA_BINARIES_DIR}/boot/boot/"
cp "${BOARD_DIR}/boot/extlinux.conf" "${BATOCERA_BINARIES_DIR}/boot/extlinux/"
"${HOST_DIR}/bin/mkimage" -C none -A arm -T script -d "${BOARD_DIR}/boot/boot.cmd" "${BATOCERA_BINARIES_DIR}/boot/boot.scr"
