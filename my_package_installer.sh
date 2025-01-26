#!/bin/bash

# Define the packages in separate arrays with the new names
declare -a utils=("curl" "git" "vim")
declare -a browsers=("firefox-esr" "chromium")
declare -a fileManagers=("thunar" "pcmanfm" "krusader" "nautilus" "nemo" "dolphin" "ranger" "nnn" "lf")
declare -a graphics=("gimp" "flameshot" "eog" "sxiv" "qimgv" "inkscape" "scrot")
declare -a terminals=("alacritty" "gnome-terminal" "kitty" "konsole" "terminator" "xfce4-terminal")
declare -a textEditors=("geany" "kate" "gedit" "l3afpad" "mousepad" "pluma")
declare -a multimedia=("mpv" "vlc" "audacity" "kdenlive" "amberol" "rhythmbox" "ncmpcpp" "mkvtoolnix-gui")
declare -a utilities=( "gparted" "gnome-disk-utility" "nitrogen" "numlockx" "galculator" "cpu-x" "udns-utils" "whois" "tree" "btop" "htop" "bat" "brightnessctl" "redshift" ) 

# Array of arrays names
package_lists=("utils" "browsers" "fileManagers" "graphics" "terminals" "textEditors" "multimedia" "utilities")


#Declare colors
red='\033[0;31m'
nc='\033[0m'
yellow='\e[38;5;220m'

#checks user
runas=$(whoami)
if [ $runas != 'root' ]; then
    printf "${red} command must be run as root...exiting${nc}\n" && exit 1
fi
# Check if necessary packages are already installed
if ! dpkg -s libncurses5-dev dialog > /dev/null 2>&1; then
  # Install necessary packages if not already installed
  printf "${red} Installing necessary packages...${nc}\n"
  apt-get update -y && \
  apt-get install -y libncurses5-dev dialog
fi

# Initialize an empty string to hold all selections
selected_packages=""

# Intro
dialog --clear --stdout --title " Package Installer "\
 --msgbox "Created by Olivier, with invaluable help from my assistant (powered by LLaMA 3.1)" 10 60

# First loop based on the length of the package_lists array
for i in $(seq 0 $((${#package_lists[@]} - 1))); do
    # Dynamically access the package list based on index
    eval "packages=\${${package_lists[$i]}[@]}"  # Dynamically access each array
    dialog_options=()
    for package in $packages; do
        dialog_options+=("$package" "" "off")
    done
    # Show dialog checklist
	#dialog --checklist "Select file managers" 20 40 10 "${dialog_options[@]}" 2>> $output_file
	selected_items=$(dialog --stdout --checklist "Select packages in ${package_lists[$i]}" 20 40 10 "${dialog_options[@]}")
	#echo -n " " >> $output_file
	clear

    # Append the selected items to the selected packages, separated by a space
    if [[ -n "$selected_packages" ]]; then
		    if [[ -n "$selected_items" ]]; then
				selected_packages="$selected_packages $selected_items"	
			fi
    else
        selected_packages="$selected_items"
    fi
done

# Check if the selection is empty
if [[ -z "$selected_packages" ]]; then
    printf "${red} No packages selected. Exiting...${nc}\n"
    exit 1
fi

# Print the selected packages
printf "${yellow}You selected the following packages for installation:${nc}\n"
printf "${yellow}$selected_packages${nc}\n"

apt-get update -y && \
apt-get install $selected_packages
