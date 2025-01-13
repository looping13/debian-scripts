#!/bin/sh
## before installing the base system
## select the step run a shell
## when in shell, cd to /tmp and wget this script then execute
## wget http://192.168.1.8:8787/btrfs.sh
## when done, then exit shell and continue installation

echo "A script to create btrfs partition - just a guy linux style"
## Find devices
dev_target=$(df /target | awk 'NR==2 {print $1}')
dev_efi=$(df /target/boot/efi | awk 'NR==2 {print $1}')

## Define mount options for btrfs filesystem. For VM
## Note: when using a ssd, append these options to the list: ssd,discard
## Read: https://thelinuxcode.com/btrfs-filesystem-mount-options/
## on compression https://thelinuxcode.com/enable-btrfs-filesystem-compression/
mount_options_btrfs="noatime,noacl,compress=zstd:5,autodefrag"

# Umount existing mounts
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
# btrfs subvolume create @snapshots

# btrfs subvolume list /mnt


echo "Mount /target"
mount -o $mount_options_btrfs,subvol=@ $dev_target /target
echo "Make directories"
mkdir -p /target/boot/efi
mkdir -p /target/home
mkdir -p /target/root
mkdir -p /target/var/log
mkdir -p /target/tmp
mkdir -p /target/opt
#mkdir -p /target/.snapshots

echo "Mount subvolumes into /target"
mount -o $mount_options_btrfs,subvol=@home $dev_target /target/home
mount -o $mount_options_btrfs,subvol=@root $dev_target /target/root
mount -o $mount_options_btrfs,subvol=@log $dev_target /target/var/log
mount -o $mount_options_btrfs,subvol=@tmp $dev_target /target/tmp
mount -o $mount_options_btrfs,subvol=@opt $dev_target /target/opt
#mount -o $mount_options_btrfs,subvol=@snapshots $dev_target /target/.snapshots

mount $dev_efi /target/boot/efi

echo " Now change /target/etc/fstab"
## comment the line containing "rootfs" in fstab (do a .bak first)
sed -i.bak '/rootfs/s/^/# /' /target/etc/fstab
echo "Find the UUID of disk"
disk_uuid=$(blkid -o value $dev_target | head -1)
echo "append mount points into fstab"
echo "UUID=$disk_uuid / btrfs $mount_options_btrfs,subvol=@ 0 0" >> /target/etc/fstab
echo "UUID=$disk_uuid /home btrfs $mount_options_btrfs,subvol=@home 0 0" >> /target/etc/fstab
echo "UUID=$disk_uuid /root btrfs $mount_options_btrfs,subvol=@root 0 0" >> /target/etc/fstab
echo "UUID=$disk_uuid /var/log btrfs $mount_options_btrfs,subvol=@log 0 0" >> /target/etc/fstab
echo "UUID=$disk_uuid /tmp btrfs $mount_options_btrfs,subvol=@tmp 0 0" >> /target/etc/fstab
echo "UUID=$disk_uuid /opt btrfs $mount_options_btrfs,subvol=@opt 0 0" >> /target/etc/fstab
#echo "UUID=$disk_uuid /.snapshots btrfs $mount_options_btrfs,subvol=@snapshots 0 0" >> /target/etc/fstab

echo "*****************************************************"
cat /target/etc/fstab | tail -n 12
echo "*****************************************************"
echo "*****************************************************"
btrfs subvolume list /target
echo "*****************************************************"
df -h 
echo "*****************************************************"
echo "*****************************************************"
echo "BTRFS partitioning DONE ! just unmount /mnt to be safe with umount /mnt/"
echo "then exit and resume installation of base system"
# umount /mnt/

