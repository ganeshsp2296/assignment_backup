git config --global --add safe.directory /var/backups/git-repos/temp1
git config --global --add safe.directory /var/backups/git-repos/temp2
git config --global --add safe.directory /var/backups/git-repos/temp3

#!/bin/bash

repo_list_file="git_url.txt"
backup_dir="/var/backups/git-repos"
today=$(date +%Y%m%d)

mkdir -p "$backup_dir"

while read -r repo_url; do
    repo_name=$(basename "$repo_url" .git)
    repo_path="$backup_dir/$repo_name"

    if [ ! -d "$repo_path/.git" ]; then
        echo "Cloning $repo_name..."
        git clone "$repo_url" "$repo_path"
    else
        echo "Updating $repo_name..."
        cd "$repo_path" && git pull
    fi


echo "Creating a tar backup for $repo_name"
tar -czvf "$backup_dir/${repo_name}-${today}.tar.gz" -C "$backup_dir" "$repo_name"

echo "Searching for recent commits for $repo_name"
cd "$repo_path"
git log --since=1.day > "$backup_dir/audit-${repo_name}-${today}.txt"

done < "$repo_list_file"
