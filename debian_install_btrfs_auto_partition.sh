#!/bin/sh
echo "This script to create btrfs partition - just a guy linux style"
dev_target=$(df /target | awk 'NR==2 {print $1}')
dev_efi=$(df /target/boot/efi | awk 'NR==2 {print $1}')
echo "Unmount target "
umount -v /target/boot/efi/
umount -v /target/

echo "mount disk and create btrfs subvolumes"
mount -v $dev_target /mnt
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
mount -v -o defaults,subvol=@ $dev_target /target
echo "Make directories"
mkdir -v -p /target/boot/efi
mkdir -v -p /target/home
mkdir -v -p /target/root
mkdir -v -p /target/var/log
mkdir -v -p /target/tmp
mkdir -v -p /target/opt

echo "mount subvolumes into /target"
mount -v -o defaults,subvol=@home $dev_target /target/home
mount -v -o defaults,subvol=@root $dev_target /target/root
mount -v -o defaults,subvol=@log $dev_target /target/var/log
mount -v -o defaults,subvol=@tmp $dev_target /target/tmp
mount -v -o defaults,subvol=@opt $dev_target /target/opt

mount -v $dev_efi /target/boot/efi

echo " Now change /target/etc/fstab"
sed -i.bak '/rootfs/s/^/# /' /target/etc/fstab
echo "Find the UUID of disk"
disk_uuid=$(blkid -o value $dev_target | head -1)
echo "append mount points into fstab"
echo "UUID=$disk_uuid / btrfs defaults,subvol=@ 0 0" >> /target/etc/fstab
echo "UUID=$disk_uuid /home btrfs defaults,subvol=@home 0 0" >> /target/etc/fstab
echo "UUID=$disk_uuid /root btrfs defaults,subvol=@root 0 0" >> /target/etc/fstab
echo "UUID=$disk_uuid /var/log btrfs defaults,subvol=@log 0 0" >> /target/etc/fstab
echo "UUID=$disk_uuid /tmp btrfs defaults,subvol=@tmp 0 0" >> /target/etc/fstab
echo "UUID=$disk_uuid /opt btrfs defaults,subvol=@opt 0 0" >> /target/etc/fstab




