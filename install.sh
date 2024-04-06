#!/bin/bash 


wget https://raw.githubusercontent.com/mashunterbd/github/github.sh

# Permission
chmod +x github.sh 

# Reneame this file  

mv github.sh github

# Move this file to bin

mv github /usr/local/bin/ 

echo "Install Successful"

echo "try to use now"

echo "github --help"
