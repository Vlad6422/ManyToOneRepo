# ManyToOneRepo

# Repository Migration Script

This script automates the process of migrating repositories from various source repositories to specific branches in a destination repository. It clones each source repository, creates a corresponding branch in the destination repository, and then pushes the content to the new branch.

## Purpose

The primary goal of this script is to simplify and automate the integration of multiple repositories into a single destination repository. This can be useful for consolidating related projects or managing dependencies across different repositories in a centralized location.

## How It Works

1. **Define Source Repositories and Branches**:
   - The script uses an associative array (`REPOS_BRANCHES`) where each key-value pair maps a source repository URL to a branch name in the destination repository.

2. **Define Destination Repository**:
   - The script specifies the destination repository where all the source repositories will be pushed into their respective branches.

3. **Temporary Directory**:
   - A temporary directory (`TEMP_DIR`) is used to clone the source repositories.

4. **Processing Loop**:
   - For each source repository:
     1. Clone the source repository into the temporary directory.
     2. Navigate into the cloned repository.
     3. Add the destination repository as a remote.
     4. Create a new branch with the specified name.
     5. Push the repository content to the corresponding branch in the destination repository.
     6. Clean up by removing the temporary directory.

## Usage Instructions

1. **Setup**:
   - Ensure you have `git` installed on your machine.
   - Modify the script to include the correct URLs and branch names for your repositories.
   - Set the correct destination repository URL.

2. **Run the Script**:
   - Save the script to a file, e.g., `ManyToOneRepo.sh`.
   - Make the script executable:
     ```bash
     chmod +x ManyToOneRepo.sh
     ```
   - Execute the script:
     ```bash
     ./ManyToOneRepo.sh
     ```

## Script Details

```bash
#!/bin/bash

# Define source repositories and corresponding branches for the destination repo
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
```

## Notes

- **Error Handling**: The script includes basic error handling to log and skip over any issues encountered during the cloning, branch creation, or pushing processes.
- **Temporary Directory**: The temporary directory used for cloning is cleaned up after each source repository is processed to prevent clutter.

Feel free to modify the script according to your specific needs and repository setup.
