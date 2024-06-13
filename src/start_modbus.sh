#!/bin/bash

# Function to get a timestamp
get_timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

# Run the ps command and count the number of rows
count=$(ps aux | grep "java -jar /home/sergiotorres/work/pi-scripts/src/modbus-slave.jar" | grep -v grep | wc -l)

# Log file path
log_file="/home/sergiotorres/work/server-control.log"
JAVA_COMMAND="/usr/bin/java -jar /home/sergiotorres/work/pi-scripts/src/modbus-slave.jar"

# Debugging output
echo "$(get_timestamp): JAVA_COMMAND = $JAVA_COMMAND" >> "$log_file"
echo "$(get_timestamp): Current directory = $(pwd)" >> "$log_file"

# Check the number of rows
if [ "$count" -eq 0 ]; then
    # If there are no rows, start the modbus-slave.jar and write a comment in the log file
    echo "$(get_timestamp): Trying to start modbus server" >> "$log_file"
    $JAVA_COMMAND >> "$log_file" 2>&1 &
    if [ $? -eq 0 ]; then
        echo "$(get_timestamp): Started modbus-slave.jar successfully" >> "$log_file"
    else
        echo "$(get_timestamp): Failed to start modbus-slave.jar" >> "$log_file"
    fi
elif [ "$count" -eq 1 ]; then
    # If there is one row, write a comment in the log file (all good)
    echo "$(get_timestamp): All good" >> "$log_file"
else
    # Handle other cases if needed
    echo "$(get_timestamp): Unexpected number of rows: $count" >> "$log_file"
fi
