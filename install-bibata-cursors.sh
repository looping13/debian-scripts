#!/bin/bash

#Download from this location
#https://github.com/ful1e5/Bibata_Cursor/releases
wget https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata.tar.xz /home/olivier/Downloads/Bibata.tar.xz
cd ~/Downloads

#Uninstall previous install
#rm ~/.icons/Bibata-*                  # Remove from local users
sudo rm /usr/share/icons/Bibata-*     # Remove from all users


#Install Bibata cursor
tar -xvf Bibata.tar.xz                # extract `Bibata.tar.gz` edit: xz extension now. Check it
#mv Bibata-* ~/.icons/                 # Install to local users
sudo mv Bibata-* /usr/share/icons/    # Install to all users

rm -rf Bibata-*



echo "################################################################"
echo "###################    T H E   E N D      ######################"
echo "################################################################"
