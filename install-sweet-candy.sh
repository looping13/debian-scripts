#!/bin/bash

cd ~/Projects/
rm -rf ~/Projects/candy-icons
rm -rf ~/Projects/sweet
git clone https://github.com/EliverLara/candy-icons.git ~/Projects/candy-icons
git clone https://github.com/EliverLara/Sweet-folders.git ~/Projects/sweet

#modify the inheritance for Sweet-Rainbow theme
# sed -i 's/Inherits=/Inherits=candy-icons,/g' ~/Projects/sweet/Sweet-Rainbow/index.theme

#uninstall previous for all users
sudo rm -rf /usr/share/icons/candy*
sudo rm -rf /usr/share/icons/Sweet*

#install new for all users
sudo mv candy* /usr/share/icons/    # Install to all users
sudo mv sweet/Sweet-Rainbow /usr/share/icons/ 


rm -rf ~/Projects/candy-icons
rm -rf ~/Projects/sweet

gsettings set org.gnome.desktop.interface icon-theme Sweet-Rainbow

echo "################################################################"
echo "###################    T H E   E N D      ######################"
echo "################################################################"