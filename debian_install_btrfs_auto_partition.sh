#!/bin/sh
echo "This script to create btrfs partition - just a guy linux style"
echo "Unmount target "
umount -v /target/boot/efi/
umount -v /target/

echo "mount disk and create btrfs subvolumes"
mount -v /dev/sda2 /mnt
cd /mnt
mv @rootfs/ @
btrfs subvolume create @home
btrfs subvolume create @root
btrfs subvolume create @log
btrfs subvolume create @tmp
btrfs subvolume create @opt
btrfs subvolume list
umount -v /mnt/
umount -v /mnt

echo "Mount /target"
mount -v -o defaults,subvol=@ /dev/sda2 /target
echo "Make directories"
mkdir -v -p /target/boot/efi
mkdir -v -p /target/home
mkdir -v -p /target/root
mkdir -v -p /target/var/log
mkdir -v -p /target/tmp
mkdir -v -p /target/opt

echo "mount subvolumes into /target"
mount -v -o defaults,subvol=@home /dev/sda2 /target/home
mount -v -o defaults,subvol=@root /dev/sda2 /target/root
mount -v -o defaults,subvol=@log /dev/sda2 /target/var/log
mount -v -o defaults,subvol=@tmp /dev/sda2 /target/tmp
mount -v -o defaults,subvol=@opt /dev/sda2 /target/opt

mount -v /dev/sda1 /target/boot/efi

echo " Now change /target/etc/fstab"
echo "Find the uuid of disk"
disk_uuid=$(blkid -o value /dev/sda2 | head -1)
echo "append mount points into fstab"
echo "uuid=$disk_uuid / btrfs defaults,subvol=@ 0 0" >> /target/etc/fstab
echo "uuid=$disk_uuid /home btrfs defaults,subvol=@home 0 0" >> /target/etc/fstab
echo "uuid=$disk_uuid /root btrfs defaults,subvol=@root 0 0" >> /target/etc/fstab
echo "uuid=$disk_uuid /var/log btrfs defaults,subvol=@log 0 0" >> /target/etc/fstab
echo "uuid=$disk_uuid /tmp btrfs defaults,subvol=@tmp 0 0" >> /target/etc/fstab
echo "uuid=$disk_uuid /opt btrfs defaults,subvol=@opt 0 0" >> /target/etc/fstab



