#!/usr/bin/env bash

# Function for program loader------------------------
function load {
    for i in {1..10}; do
        echo -n "."
        sleep 0.1
    done
    echo -e "100%\n"
}

# Check if the directory exists---------------------
folder="negpod_0-q1"

# File initialization---------------
s_email='select-emails.sh'
main='main.sh'
file_path='Students-list_1023.txt'
file_save='student-emails.txt'

# file exit

if [ -f "$s_email" ] && [ -f "$main" ] && [ -f "$file_path" ] && [ -f "$file_save" ]; then
    if [ -d "$folder" ]; then
        echo -n "Moving Files "
        load
        mv -f "$main" "$s_email" "$file_save" "$file_path" "$folder"
        echo -n "Backing up data to alu-cod.online "
        load
        ./backup-Negpod_17.sh
    else
        echo -n "Creating directory "
        load
        mkdir "$folder"

        echo -n "Folder Created Successfully!! Moving Files "
        load
        mv -f "$main" "$s_email" "$file_save" "$file_path" "$folder"
        echo -n "Backing up data to alu-cod.online "
        load
        ./backup-Negpod_17.sh
    fi
else
    echo "Error: Your Files Don't Exist"
    echo -n "Ending Programming "
    load
fi
