#!/bin/bash
## run this command to output the list to a text file
apt update
apt list --upgradable > upgradable.txt
# the edit the file and remove the lines for package you don't want to update
nano upgradable.txt

# the awk command will read the first column separated by forward slash
# then the tr command will replace new line with space to output a single line
# the result is passed to apt as an argument
apt install $(awk -F '/' '{print $1}' upgradable.txt | tr '\n' ' ')
