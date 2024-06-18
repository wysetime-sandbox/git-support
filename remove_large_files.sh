#!/bin/bash

# Ensure the large_files.txt file is in the current directory
if [ ! -f large_files.txt ]; then
  echo "large_files.txt file not found in the current directory."
  exit 1
fi

# Clone the repository as a mirror
repo_url="https://wysetime-admin@bitbucket.org/wysetime-development/perception-module.git"
repo_dir="my_repo"

git clone --mirror "$repo_url" "$repo_dir"
cd "$repo_dir" || { echo "Failed to enter repository directory"; exit 1; }

# Identify large objects in the repository (Maximum 50kb)
large_objects=$(git rev-list --objects --all | grep -f <(git verify-pack -v .git/objects/pack/pack-*.idx | awk '$3 > 50000 {print $1}'))

echo "Identified large objects:"
echo "$large_objects"

# Read the list of large files and remove them
while IFS= read -r line
do
  file_path=$(echo "$line" | awk '{print $2}')
  echo "Removing $file_path from history"

  git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch '$file_path'" \
  --prune-empty --tag-name-filter cat -- --all \
  || { echo "git filter-branch failed for $file_path"; exit 1; }

done < ../large_files.txt

# Clean up references
rm -rf .git/refs/original/
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Set the push location to your GitHub repository
git remote set-url origin "https://github.com/yourusername/your-repo.git"
git push origin --force --all
git push origin --force --tags

echo "Mirroring and cleaning complete!"
