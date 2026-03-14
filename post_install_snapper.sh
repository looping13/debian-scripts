#!/bin/bash

# Install Snapper and required tools
sudo apt install -y snapper inotify-tools make

# Create Snapper config for root (@) and home (@home) subvolumes
sudo snapper -c root create-config /
sudo snapper -c home create-config /home

# Grant user access and synchronize ACLs
sudo snapper -c root set-config ALLOW_USERS=$USER SYNC_ACL=yes
sudo snapper -c home set-config ALLOW_USERS=$USER SYNC_ACL=yes

# List available Snapper configs
sudo snapper list-configs

# Show current settings for root and home
snapper -c root get-config
snapper -c home get-config

# List snapshots for root and home
snapper ls
snapper -c home ls

#You can check their status with these commands:

sudo systemctl status snapper-boot.timer
sudo systemctl status snapper-timeline.timer
sudo systemctl status snapper-cleanup.timer

#By default, timeline snapshots are enabled for both root (@) and home (@home) subvolumes. 
#However, it is recommended to keep timeline snapshots enabled only for root 
#and disable them for home to avoid excessive snapshot clutter:

sudo snapper -c home set-config TIMELINE_CREATE=no
