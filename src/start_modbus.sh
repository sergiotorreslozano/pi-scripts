#!/bin/bash


# Function to get a timestamp
get_timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

# Run the ps command and count the number of rows
count=$(ps aux | grep "java -jar modbus-slave.jar" | grep -v grep | wc -l)

# Log file path
log_file="/home/sergiotorres/work/server-control.log"

# Check the number of rows
if [ "$count" -eq 0 ]; then
    # If there is only one row, start the modbus-slave.jar and write a comment in the log file
    java -jar modbus-slave.jar > server.log 2>&1 &
    echo "$(get_timestamp): Started modbus-slave.jar" >> "$log_file"
elif [ "$count" -eq 1 ]; then
    # If there are two rows, write a comment in the log file (all good)
    echo "$(get_timestamp): All good" >> "$log_file"
else
    # Handle other cases if needed
    echo "$(get_timestamp): Unexpected number of rows: $count" >> "$log_file"
fi

