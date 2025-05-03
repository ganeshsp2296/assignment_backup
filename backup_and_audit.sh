#!/bin/bash

repo_list="git_url.txt"
backup_dir="/home/ubuntu/backup1"

while read repo_list
do
        #repo_name=$(awk -F/ '{print $NF}' | sed 's/ .git//')
        repo_name=$(basename "$repo_list" .git)
        #echo "Repo Name: $repo_name"
done < git_url.txt

today=$(date +%Y%m%d)

if [ ! -d "$repo_name" ]; then
        git clone "$repo_list"
else
        git pull
fi

