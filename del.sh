#!/bin/bash

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

