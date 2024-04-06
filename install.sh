#!/bin/bash

apt install wget git -y

# then 
wget -O github.sh https://raw.githubusercontent.com/mashunterbd/github/main/github.sh

# Permission
chmod +x github.sh 

# Reneame this file  

mv github.sh github

# Move this file to bin

mv github /usr/local/bin/ 

# delete
rm -rf install.sh

echo "Install Successful"

echo "try to use now"

echo "github --help"
