#!/bin/bash

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

