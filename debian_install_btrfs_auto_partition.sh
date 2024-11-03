#!/bin/sh
echo "This script to create btrfs partition - just a guy linux style"
echo "Unmount target "
umount /target/boot/efi/
umount /target/

echo "mount disk and create btrfs subvolumes"
mount /dev/sda2 /mnt
cd /mnt
mv @rootfs/ @
btrfs su cr @home
btrfs su cr @root
btrfs su cr @log
btrfs su cr @tmp
btrfs su cr @opt

echo "Mount /target"
mount -o noatime,compress=zstd,subvol=@ /dev/sda2 /target
echo "Make directories"
mkdir -p /target/boot/efi
mkdir -p /target/home
mkdir -p /target/root
mkdir -p /target/var/log
mkdir -p /target/tmp
mkdir -p /target/opt

echo "mount subvolumes into /target"
mount -o noatime,compress=zstd,subvol=@home /dev/sda2 /target/home
mount -o noatime,compress=zstd,subvol=@root /dev/sda2 /target/root
mount -o noatime,compress=zstd,subvol=@log /dev/sda2 /target/var/log
mount -o noatime,compress=zstd,subvol=@tmp /dev/sda2 /target/tmp
mount -o noatime,compress=zstd,subvol=@opt /dev/sda2 /target/opt

mount /dev/sda1 /target/boot/efi

echo " Now change /target/etc/fstab"
echo "Find the uuid of disk"
disk_uuid=$(blkid -o value /dev/sda2 | head -1)
echo "append mount points into fstab"
echo "uuid=$disk_uuid / btrfs noatime,compress=zstd,subvol=@ 0 0" >> /target/etc/fstab
echo "uuid=$disk_uuid /home btrfs noatime,compress=zstd,subvol=@home 0 0" >> /target/etc/fstab
echo "uuid=$disk_uuid /root btrfs noatime,compress=zstd,subvol=@root 0 0" >> /target/etc/fstab
echo "uuid=$disk_uuid /var/log btrfs noatime,compress=zstd,subvol=@log 0 0" >> /target/etc/fstab
echo "uuid=$disk_uuid /tmp btrfs noatime,compress=zstd,subvol=@tmp 0 0" >> /target/etc/fstab
echo "uuid=$disk_uuid /opt btrfs noatime,compress=zstd,subvol=@opt 0 0" >> /target/etc/fstab


