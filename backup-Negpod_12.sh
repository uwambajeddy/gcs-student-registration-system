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
source_directory="negpod_12-q1"
username="f51f177bfab6"
host="f51f177bfab6.51efc529.alu-cod.online"
password="07b7a900c3039680b412"
dest="summative/1023-2024j"

# Create the destination directory on the remote server if it doesn't exist
sshpass -p "$password" ssh -o StrictHostKeyChecking=no "$username@$host" "mkdir -p /summative/1023-2024j"

# Use rsync to backup the directory to the alu-cod.online server
rsync -avz --delete -e "sshpass -p $password ssh -o StrictHostKeyChecking=no" "$source_directory" "$username@$host:$dest"

echo -n "Backup completed. Ending Program ."
load
echo -e "\n\n **************************** Thank You!!*****************************"
