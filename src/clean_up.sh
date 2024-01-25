#!/bin/bash

# Define the file name
client_file="client.log"
server_file="server.log"

get_timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

# Check if the file exists
if [ -e "$client_file" ]; then
    # File exists, so delete it
    rm "$client_file"
    echo "$(get_timestamp): File $client_file deleted, creating an empty one"
    touch "$client_file"
else
    # File doesn't exist
    echo "$(get_timestamp): File $client_file not found, creating one empty"
    touch "$client_file"
fi


# Check if the file exists
if [ -e "$server_file" ]; then
    # File server_file, so delete it
    rm "$server_file"
    echo "$(get_timestamp): File $server_file deleted, creating an empty one"
    touch "$server_file"
else
    # File doesn't exist
    echo "$(get_timestamp): File $server_file not found, creating one empty"
    touch "$server_file"
fi
