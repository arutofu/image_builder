#!/bin/bash

set -e

# Проверка наличия необходимых утилит
command -v wget >/dev/null 2>&1 || { echo >&2 "wget is required but it's not installed. Aborting."; exit 1; }
command -v unzip >/dev/null 2>&1 || { echo >&2 "unzip is required but it's not installed. Aborting."; exit 1; }
command -v losetup >/dev/null 2>&1 || { echo >&2 "losetup is required but it's not installed. Aborting."; exit 1; }
command -v mkfs.vfat >/dev/null 2>&1 || { echo >&2 "mkfs.vfat is required but it's not installed. Aborting."; exit 1; }
command -v mkfs.ext4 >/dev/null 2>&1 || { echo >&2 "mkfs.ext4 is required but it's not installed. Aborting."; exit 1; }

# Загрузка и распаковка образа Raspbian
IMAGE_NAME="drone_raspberry_pi_image.img"
BOOT_SIZE="100M"
ROOT_SIZE="3G"
RASPBIAN_IMAGE="2021-05-07-raspios-buster-armhf-lite.zip"
RASPBIAN_IMG="2021-05-07-raspios-buster-armhf-lite.img"

if [ ! -f ${RASPBIAN_IMAGE} ]; then
    echo "Downloading Raspbian image..."
    wget https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-05-28/${RASPBIAN_IMAGE}
fi

if [ ! -f ${RASPBIAN_IMG} ]; then
    echo "Unzipping Raspbian image..."
    unzip ${RASPBIAN_IMAGE}
fi

# Создание файла образа
dd if=/dev/zero of=${IMAGE_NAME} bs=1M count=4096

# Создание разделов
parted ${IMAGE_NAME} mklabel msdos
parted ${IMAGE_NAME} mkpart primary fat32 1MiB ${BOOT_SIZE}
parted ${IMAGE_NAME} mkpart primary ext4 ${BOOT_SIZE} 100%

# Настройка устройства loop
LOOPDEVICE=$(losetup --show -fP ${IMAGE_NAME})

# Создание файловых систем
mkfs.vfat -n BOOT ${LOOPDEVICE}p1
mkfs.ext4 -L rootfs ${LOOPDEVICE}p2

# Монтирование файловых систем
mkdir -p mnt/boot mnt/rootfs
mount ${LOOPDEVICE}p1 mnt/boot
mount ${LOOPDEVICE}p2 mnt/rootfs

# Монтирование образа Raspbian для извлечения загрузочных файлов
mkdir -p raspbian_boot
offset=$(fdisk -l ${RASPBIAN_IMG} | grep FAT32 | awk '{print $2}')
offset=$((offset * 512))
mount -o loop,offset=${offset} ${RASPBIAN_IMG} raspbian_boot

# Копирование загрузочных файлов
cp -r raspbian_boot/* mnt/boot/

# Отмонтирование раздела загрузки образа Raspbian
umount raspbian_boot
rmdir raspbian_boot

# Загрузка базовой системы
debootstrap --arch=armhf buster mnt/rootfs http://raspbian.raspberrypi.org/raspbian/

# Запуск конфигурационного скрипта внутри chroot
# Необходимо создать скрипт config.sh и копировать его в контейнер
cp /workspace/config/config.sh mnt/rootfs/
chmod +x mnt/rootfs/config.sh
chroot mnt/rootfs /config.sh

# Очистка
umount mnt/boot
umount mnt/rootfs
losetup -d ${LOOPDEVICE}
