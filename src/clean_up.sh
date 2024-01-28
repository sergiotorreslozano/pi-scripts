#!/bin/bash



if [ $# -eq 0 ]; then
    echo "Usage: $0 <file_path>"
    exit 1
fi

# Define the file name
file_path="$1"

get_timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

# Check if the file exists
if [ -e "$file_path" ]; then
    # File exists, so delete it
    rm "$file_path"
    echo "$(get_timestamp): File $client_file deleted, creating an empty one"
    touch "$file_path"
else
    # File doesn't exist
    echo "$(get_timestamp): File $client_file not found, creating one empty"
    touch "$file_path"
fi
