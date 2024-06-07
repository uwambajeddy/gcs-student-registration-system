#!/usr/bin/env bash

# Function for displaying loading progress
function load {
    for i in {1..10}; do
        echo -n "."
        sleep 0.1
    done
    echo -e "100%\n"
}

# Configuration for variables
source_directory="negpod_17-q1"
username="64293e56bc62"
host="64293e56bc62.3a2627c1.alu-cod.online"
password="328d3b338a4ced526c9a"
dest="summative/1023-2024j"

# Create the destination directory on the remote server if it doesn't exist
sshpass -p "$password" ssh -o StrictHostKeyChecking=no "$username@$host" "mkdir -p /summative/1023-2024j"

# Use rsync to backup the directory to the alu-cod.online server
rsync -avz --delete -e "sshpass -p $password ssh -o StrictHostKeyChecking=no" "$source_directory" "$username@$host:$dest"

echo -n "Backup completed. Ending Program ."
load
echo -e "\n\n **************************** Thank You!!*****************************"
