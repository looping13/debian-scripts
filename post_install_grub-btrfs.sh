#!/bin/bash

# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please run it using sudo or as the root user."
    exit 1
fi
btrfs subvolume snapshot -r / /.snapshots/post_installer

apt install build-essential gawk inotify-tools git 
git clone https://github.com/Antynea/grub-btrfs.git


cd grub-btrfs
make install
grub-update
systemctl daemon-reload
systemctl enable grub-btrfsd.service
systemctl start grub-btrfsd.service

btrfs subvolume snapshot -r / /.snapshots/post_grub-btrfs
