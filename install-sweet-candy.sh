#!/bin/bash

cd ~/Projects/
rm -rf ~/Projects/candy-icons
rm -rf ~/Projects/Sweet-folders
rm -rf ~/Projects/Sweet

git clone https://github.com/EliverLara/candy-icons.git ~/Projects/candy-icons
git clone https://github.com/EliverLara/Sweet-folders.git ~/Projects/Sweet-folders
git clone https://github.com/EliverLara/Sweet.git ~/Projects/Sweet

#modify the inheritance for Sweet-Rainbow theme
# sed -i 's/Inherits=/Inherits=candy-icons,/g' ~/Projects/Sweet-folders/Sweet-Rainbow/index.theme

#uninstall previous for all users
sudo rm -rf /usr/share/icons/candy*
sudo rm -rf /usr/share/icons/Sweet-Rainbow
sudo rm -rf /usr/share/themes/Sweet

#install new for all users
sudo mv candy* /usr/share/icons/    # Install to all users
sudo mv Sweet-folders/Sweet-Rainbow /usr/share/icons/ 
sudo mv Sweet /usr/share/themes/ 


rm -rf ~/Projects/candy-icons
rm -rf ~/Projects/Sweet*

gsettings set org.gnome.desktop.interface icon-theme Sweet-Rainbow
#gsettings set org.gnome.desktop.interface gtk-theme "Sweet"
#gsettings set org.gnome.desktop.wm.preferences theme "Sweet"

echo "################################################################"
echo "###################    T H E   E N D      ######################"
echo "################################################################"