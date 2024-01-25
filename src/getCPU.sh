#!/bin/bash

# Run the free command and capture the output
free_output=$(free -m)

# Extract the free memory value (in MB)
free_memory=$(echo "$free_output" | awk '/^Mem/ { print $4 }')

# Print the result
echo "Free Memory: $free_memory MB"
