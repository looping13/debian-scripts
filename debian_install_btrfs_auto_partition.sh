#!/bin/sh
echo "A script to create btrfs partition - just a guy linux style"
dev_target=$(df /target | awk 'NR==2 {print $1}')
dev_efi=$(df /target/boot/efi | awk 'NR==2 {print $1}')
echo "Unmount /target"
umount /target/boot/efi/
umount /target/

echo "Mount device to /mnt and create btrfs subvolumes"
mount $dev_target /mnt
cd /mnt
mv @rootfs/ @
btrfs subvolume create @home
btrfs subvolume create @root
btrfs subvolume create @log
btrfs subvolume create @tmp
btrfs subvolume create @opt

# btrfs subvolume list /mnt


echo "Mount /target"
mount -o defaults,subvol=@ $dev_target /target
echo "Make directories"
mkdir -p /target/boot/efi
mkdir -p /target/home
mkdir -p /target/root
mkdir -p /target/var/log
mkdir -p /target/tmp
mkdir -p /target/opt

echo "Mount subvolumes into /target"
mount -o defaults,subvol=@home $dev_target /target/home
mount -o defaults,subvol=@root $dev_target /target/root
mount -o defaults,subvol=@log $dev_target /target/var/log
mount -o defaults,subvol=@tmp $dev_target /target/tmp
mount -o defaults,subvol=@opt $dev_target /target/opt

mount $dev_efi /target/boot/efi

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

echo "*****************************************************"
cat /target/etc/fstab | tail -n 12
echo "*****************************************************"
echo "*****************************************************"
btrfs subvolume list /target
echo "*****************************************************"
echo "BTRFS partitioning DONE ! just unmount /mnt to be safe with umount /mnt/"
echo "then exit and resume installation of base system"
# umount /mnt/


