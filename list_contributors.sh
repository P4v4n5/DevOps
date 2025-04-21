#!/bin/bash

# Exit on error
set -e

# GitHub API base URL
API_URL="https://api.github.com"

# Check for required arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <repo_owner> <repo_name>"
    exit 1
fi

# GitHub username and token must be set in environment
if [[ -z "$username" || -z "$token" ]]; then
    echo "Error: Please export your GitHub username and token:"
    echo "  export username=your_username"
    echo "  export token=your_token"
    exit 1
fi

REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    curl -s -u "${username}:${token}" "${API_URL}/${endpoint}"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."

    collaborators=$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')

    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access:"
        echo "$collaborators"
    fi
}

# Run the function
list_users_with_read_access

