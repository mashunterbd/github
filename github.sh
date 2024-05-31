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

CREDENTIALS_FILE="$HOME/.github_credentials"

# Function to display help
display_help() {
    echo "GitHub Tool - by @mashunterbd"
    echo ""
    echo "This tool allows you to manage your GitHub repositories from the command line."
    echo "You can create, push to, and delete repositories with ease."
    echo ""
    echo "Usage:"
    echo "  github [option]"
    echo ""
    echo "Options:"
    echo "  -push        Create a new repository and push all files from the current directory."
    echo "  -del         Delete a repository from your GitHub account."
    echo "  --help       Display this help menu."
    echo "  -v           Display the version information."
    echo "  -save        Save your GitHub credentials (username and API token)."
    echo ""
    echo "Examples:"
    echo "  github -push"
    echo "    Prompts for necessary information and pushes the current directory's files to a new GitHub repository."
    echo ""
    echo "  github -del"
    echo "    Prompts for the repository name and deletes it from your GitHub account after confirmation."
    echo ""
    echo "  github -save"
    echo "    Prompts for your GitHub username and API token and saves them for future use."
    echo ""
    echo "Note:"
    echo "  This tool requires a GitHub API token with the necessary permissions."
    echo "  Ensure that 'git' and 'curl' are installed and available in your PATH."
    echo ""
    echo "For more information, visit: https://github.com/mashunterbd"
}

# Function to read GitHub credentials
read_credentials() {
    if [ -f "$CREDENTIALS_FILE" ]; then
        source "$CREDENTIALS_FILE"
    else
        read -p "Enter your GitHub username: " username
        read -s -p "Enter your GitHub API token: " token
        echo ""
    fi
}

# Function to verify GitHub credentials
verify_credentials() {
    local username=$1
    local token=$2
    local response
    response=$(curl -s -u "$username:$token" https://api.github.com/user)

    if [[ "$response" == *"\"login\": \"$username\""* ]]; then
        return 0
    else
        return 1
    fi
}

# Function to save GitHub credentials
save_credentials() {
    read -p "Enter your GitHub username: " username
    read -s -p "Enter your GitHub API token: " token
    echo ""

    if verify_credentials "$username" "$token"; then
        echo "username=$username" > "$CREDENTIALS_FILE"
        echo "token=$token" >> "$CREDENTIALS_FILE"
        chmod 600 "$CREDENTIALS_FILE"
        echo "Credentials verified and saved successfully."
    else
        echo "Invalid credentials. Please try again."
        exit 1
    fi
}

# Function to check if a repository exists
check_repo_exists() {
    local repo_name=$1
    local response
    response=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: token $token" "https://api.github.com/repos/$username/$repo_name")
    echo "$response"
}

# Function to check if the repository has any existing files
check_repo_files() {
    local repo_name=$1
    local response
    response=$(curl -s -H "Authorization: token $token" "https://api.github.com/repos/$username/$repo_name/contents")
    if [[ "$response" == "[]" ]]; then
        echo "empty"
    else
        echo "not_empty"
    fi
}

# Function to create a GitHub repository
create_repo() {
    local repo_name=$1
    local visibility_option=$2
    curl -s -H "Authorization: token $token" -d '{"name": "'"$repo_name"'", "private": '"$visibility_option"'}' https://api.github.com/user/repos
}

# Handle command line arguments
case "$1" in
    --help)
        display_help
        exit 0
        ;;
    -save)
        save_credentials
        exit 0
        ;;
    -push)
        read_credentials
        read -p "Enter the repository name: " repo_name
        read -p "Do you want to create a public (1) or private (2) repository? " visibility

        if [ "$visibility" -eq 1 ]; then
            visibility_option="false"
        elif [ "$visibility" -eq 2 ]; then
            visibility_option="true"
        else
            echo "Invalid option. Please choose 1 for public or 2 for private."
            exit 1
        fi

        repo_exists=$(check_repo_exists "$repo_name")

        if [ "$repo_exists" -eq 200 ]; then
            echo "Repository already exists."
        else
            create_repo "$repo_name" "$visibility_option"
            echo "Repository created successfully."
        fi

        # Initialize and push to GitHub
        git init
        git remote add origin "https://$username:$token@github.com/$username/$repo_name.git"
        git branch -M main
        git add .
        git commit -m "Initial commit"
        git push -u origin main
        git status
        ;;
    -del)
        read_credentials
        read -p "Enter the name of the repository you want to delete: " repo_name

        repo_exists=$(check_repo_exists "$repo_name")

        if [ "$repo_exists" -eq 200 ]; then
            echo "Repository found: $repo_name"
            read -p "Are you sure you want to delete $repo_name? (yes/no): " confirmation
            if [ "$confirmation" = "yes" ]; then
                curl -X DELETE -s -H "Authorization: token $token" "https://api.github.com/repos/$username/$repo_name"
                echo "Repository $repo_name successfully deleted."
            else
                echo "Deletion cancelled. Repository $repo_name was not deleted."
            fi
        else
            echo "Repository $repo_name not found in $username's account."
        fi
        ;;
    -v)
        echo "1.0 (stable)"
        echo "Owner: https://github.com/mashunterbd"
        ;;
    *)
        echo "Invalid option. Use --help to see the available options."
        ;;
esac
