#!/bin/bash

# Define source repositories and corresponding branches for the destination repo
# ["URL"]="NameOfBranch"
declare -A REPOS_BRANCHES
REPOS_BRANCHES=(
    ["https://github.com/Vlad6422/IPK-Project-2-Udp-Tcp-Chat-Server.git"]="IpkChatServer"
    ["https://github.com/Vlad6422/IPK-Project-1-Udp-Tcp-Chat-Client.git"]="IpkChatClient"
    ["https://github.com/Vlad6422/IPP-patterns.git"]="IppPatters"
    ["https://github.com/Vlad6422/IFJ-2023.git"]="IfjProject"
    ["https://github.com/Vlad6422/IZG-VUT-FIT-GPU.git"]="IzgProject"
    ["https://github.com/Vlad6422/IOS-Project-2-VUT.git"]="IosProject"
    ["https://github.com/Vlad6422/IDS-Project-VUT.git"]="IdsProject"
    ["https://github.com/Vlad6422/ICS-project-VUT.git"]="IcsProject"
)

# Define the destination repository
DEST_REPO="https://github.com/Vlad6422/VUT_Projects.git"

# Define a temporary directory for cloning
TEMP_DIR="temp-repo"

# Clone each source repository and push it to the corresponding branch in the destination repository
for SOURCE_REPO in "${!REPOS_BRANCHES[@]}"; do
    BRANCH=${REPOS_BRANCHES[$SOURCE_REPO]}
    
    echo "Processing $SOURCE_REPO..."

    # Clone the source repository to a temporary directory
    git clone "$SOURCE_REPO" "$TEMP_DIR" || { echo "Failed to clone $SOURCE_REPO."; continue; }

    # Navigate into the cloned repository
    cd "$TEMP_DIR" || { echo "Failed to navigate into $TEMP_DIR."; exit 1; }

    # Add the destination repository as a new remote
    git remote add destination "$DEST_REPO" || { echo "Failed to add destination remote."; exit 1; }

    # Create a new branch for the repository
    git checkout -b "$BRANCH" || { echo "Failed to create branch $BRANCH."; exit 1; }

    # Push the repository to the destination repository's branch
    git push destination "$BRANCH" || { echo "Failed to push to branch $BRANCH."; exit 1; }

    # Clean up the temporary directory
    cd ..
    rm -rf "$TEMP_DIR"
    
    echo "Finished processing $SOURCE_REPO to branch $BRANCH."
done

echo "All repositories processed."
