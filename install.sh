#!/bin/bash 

apt install wget git -y

# then 

wget https://github.com/mashunterbd/github/blob/main/github.sh

# Permission
chmod +x github.sh 

# Reneame this file  

mv github.sh github

# Move this file to bin

mv github /usr/local/bin/ 

echo "Install Successful"

echo "try to use now"

echo "github --help"
