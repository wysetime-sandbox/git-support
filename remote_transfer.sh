# https://docs.github.com/en/repositories/creating-and-managing-repositories/duplicating-a-repository

#!/bin/bash

# Define variables
BITBUCKET_REPO_URL="https://bitbucket.org/exampleuser/repository-to-mirror.git"
GITHUB_REPO_URL="https://github.com/exampleuser/mirrored.git"
REPO_DIR="repository-to-mirror.git"

# Clone the repository as a mirror
git clone --mirror $BITBUCKET_REPO_URL

# Navigate into the cloned repository directory
cd $REPO_DIR

# Set the push location to your GitHub repository
git remote set-url --push origin $GITHUB_REPO_URL

# Push the mirrored repository to GitHub
git push --mirror

# Return to the original directory (optional)
cd ..

echo "Mirroring complete!"
