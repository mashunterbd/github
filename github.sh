#!/bin/bash

# Define the ASCII banner
ascii_banner="      ___                                     ___           ___                   
     /\__\                                   /\  \         /\  \         _____    
    /:/ _/_       ___           ___          \:\  \        \:\  \       /::\  \   
   /:/ /\  \     /\__\         /\__\          \:\  \        \:\  \     /:/\:\  \  
  /:/ /::\  \   /:/__/        /:/  /      ___ /::\  \   ___  \:\  \   /:/ /::\__\ 
 /:/__\/\:\__\ /::\  \       /:/__/      /\  /:/\:\__\ /\  \  \:\__\ /:/_/:/\:|__|
 \:\  \ /:/  / \/\:\  \__   /::\  \      \:\/:/  \/__/ \:\  \ /:/  / \:\/:/ /:/  /
  \:\  /:/  /   ~~\:\/\__\ /:/\:\  \      \::/__/       \:\  /:/  /   \::/_/:/  / 
   \:\/:/  /       \::/  / \/__\:\  \      \:\  \        \:\/:/  /     \:\/:/  /  
    \::/  /        /:/  /       \:\__\      \:\__\        \::/  /       \::/  /   
     \/__/         \/__/         \/__/       \/__/         \/__/         \/__/    
                                by @mashunterbd
"

# Print the ASCII banner
echo -e "\033[1;36m$ascii_banner\033[0m"


if [ "$1" == "--help" ]; then
    echo "It is basically an automatic tool through which you can create a repository and upload your files there remotely and delete them if you want. In this case only your account should have API token."

echo ""   # Empty echo for a line break
echo ""

    echo "Usegs:"  
    echo "" 
    echo " github [option] "
echo ""   # Empty echo for a line break
echo ""

    echo " -push: Publish all files in your current directory to your GitHub account."  
    echo "" 

    echo " -del: Delete any repository in your account."  
    echo "" 

    echo " --help: Display uses."  
    echo "" 

    echo " -v: Check for version."  
    echo "" 

    exit 0
fi

if [ "$1" == "-push" ]; then
    # Prompt user for GitHub username
    read -p "Enter your GitHub username: " username

    # Prompt user for API token
    read -p "Enter your GitHub API token: " token

    # Prompt user for repository name
    read -p "Enter the repository name: " repo_name

    # Prompt user to choose repository visibility
    read -p "Do you want to create a public (1) or private (2) repository? " visibility

    if [ $visibility -eq 1 ]; then
        visibility_option="false"
    elif [ $visibility -eq 2 ]; then
        visibility_option="true"
    else
        echo "Invalid option. Please choose 1 for public or 2 for private."
        exit 1
    fi

    # Check if the repository already exists
    repo_exists=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: token $token" https://api.github.com/repos/$username/$repo_name)

    if [ $repo_exists -eq 200 ]; then
        echo "Repository already exists."
    else
        # Create repository on GitHub
        curl -s -H "Authorization: token $token" -d '{"name": "'"$repo_name"'", "private": '$visibility_option'}' https://api.github.com/user/repos
        echo "Repository created successfully."
    fi

    # Initialize a Git repository in the current directory
    git init

    # Add a remote named 'origin' for the GitHub repository
    git remote add origin "https://github.com/$username/$repo_name.git"

    # Set the remote URL for push
    git remote set-url origin "https://$token@github.com/$username/$repo_name"

    # Switch to the 'main' branch (assuming it's the default branch)
    git branch -M main

    # Add all files to the staging area
    git add .

    # Commit the changes
    git commit -m "Initial commit"

    # Push the changes to the remote repository
    git push -u origin main

    # Check the status of the repository
    git status
fi

if [ "$1" == "-del" ]; then
    # Prompt user for GitHub API token
    read -p "Enter your GitHub API token: " token

    # Prompt user for GitHub username
    read -p "Enter your GitHub username: " username

    # Prompt user for repository name to delete
    read -p "Enter the name of the repository you want to delete: " repo_name

    # Check if the repository exists
    repo_exists=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: token $token" https://api.github.com/repos/$username/$repo_name)

    if [ $repo_exists -eq 200 ]; then
        # Repository exists, ask for confirmation
        echo "Repository found: $repo_name"
        read -p "Are you sure you want to delete $repo_name? (yes/no): " confirmation
        if [ "$confirmation" = "yes" ]; then
            # Delete repository on GitHub
            curl -X DELETE -s -H "Authorization: token $token" https://api.github.com/repos/$username/$repo_name
            echo "Repository $repo_name successfully deleted."
        else
            echo "Deletion cancelled. Repository $repo_name was not deleted."
        fi
    else
        # Repository does not exist
        echo "Repository $repo_name not found in $username's account."
    fi
fi

if [ "$1" == "-v" ]; then
    echo "1.0 (stable)"
    echo "Owner: https://github.com/mashunterbd"
fi

