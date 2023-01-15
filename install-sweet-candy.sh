#!/bin/bash
###################################
## Review - Modify - Run - Enjoy ##
###################################

echo "## Cloning github repositories "
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
echo "## Uninstalling old files for all users"
sudo rm -rf /usr/share/icons/candy*
sudo rm -rf /usr/share/icons/Sweet-Rainbow
sudo rm -rf /usr/share/themes/Sweet

#install new for all users
echo "## Installing new files for all users"
sudo mv candy* /usr/share/icons/    # Install to all users
sudo mv Sweet-folders/Sweet-Rainbow /usr/share/icons/ 
sudo mv Sweet /usr/share/themes/ 

# fixing some icons symlink into candy-icons
echo "## Fixing candy-icons symlinks"
cd /usr/share/icons/candy-icons/apps/scalable
sudo ln -sf accessories-text-editor.svg org.gnome.TextEditor.svg
sudo ln -sf meld.svg org.gnome.Meld.svg
sudo ln -sf org.gnome.Rhythmbox.svg org.gnome.Rhythmbox3.svg
sudo ln -sf system-software-update.svg software-properties.svg
# Need to update icon cache after modification of the folder
sudo update-icon-caches /usr/share/icons/candy-icons/

# Cleaning local repository
echo "## Cleaning local user temp repositories"
rm -rf ~/Projects/candy-icons
rm -rf ~/Projects/Sweet*

# Set themes in Gnome
echo "## Setting the themes for Gnome"
gsettings set org.gnome.desktop.interface icon-theme Sweet-Rainbow
gsettings set org.gnome.desktop.interface gtk-theme Sweet
gsettings set org.gnome.desktop.wm.preferences theme Sweet

echo "################################################################"
echo "###################    T H E   E N D      ######################"
echo "################################################################"
