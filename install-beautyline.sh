#!/bin/bash

#Download from this location
#https://www.opendesktop.org/s/Gnome/p/1425426
cd ~/Downloads

#Uninstall previous install
#rm ~/.icons/BeautyLine                   # Remove from local users
sudo rm -rf /usr/share/icons/BeautyLine     # Remove from all users


#Extract BeautyLine 
tar -xvf BeautyLine.tar.gz                # extract `BeautyLine.tar.gz`

#modify the inheritance for BeautyLine theme
sed -i 's/Inherits=/Inherits=candy-icons,/g' ~/Downloads/BeautyLine/index.theme

#Install BeautyLine 
#mv BeautyLine  ~/.icons/                 # Install to local users
sudo mv BeautyLine /usr/share/icons/    # Install to all users

rm -rf BeautyLine

# Set themes in Gnome
echo "## Setting the themes for Gnome"
gsettings set org.gnome.desktop.interface icon-theme BeautyLine

echo "################################################################"
echo "###################    T H E   E N D      ######################"
echo "################################################################"
