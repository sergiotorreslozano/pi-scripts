#!/bin/bash

# Define variables
LOG_FILE="/home/sergiotorres/work/client.log"
JAVA_COMMAND="/usr/bin/java -jar -Dconfig=config.properties /home/sergiotorres/work/pi-scripts/src/modbus-tcp-client.jar "
TEMPERATURE_FILE="/home/sergiotorres/work/pi-scripts/src/temperature.txt"

# Function to generate a random temperature
generate_random_temperature() {
    local delta=$((RANDOM % 4))  # Random value between 0 and 3
        # Check if the file exists
    if [ -f $TEMPERATURE_FILE ]; then
    # Read the first and second lines from the file and assign them to variables
        old_value=$(sed -n '1p' "$TEMPERATURE_FILE")
        new_value=$(sed -n '2p' "$TEMPERATURE_FILE")
        difference=$(expr $new_value - $old_value)
    else
        echo "Error: File 'temperature.txt' not found."
        return 1
    fi
    
    if [ $difference -lt 0 ]; then 
        # 90% probability to continue in the same direction
        if [ $((RANDOM % 10)) -lt 9 ]; then
            TEMPERATURE_RANDOM=$((new_value + delta))
        else 
            TEMPERATURE_RANDOM=$((new_value - delta))
        fi
    else
        # 90% probability to continue in the same direction
        if [ $((RANDOM % 10)) -lt 8 ]; then
            TEMPERATURE_RANDOM=$((new_value - delta))
        else
            TEMPERATURE_RANDOM=$((new_value + delta))
        fi
    
    fi
   
    # Ensure the temperature stays within the specified range [0, 140]
    if [ $TEMPERATURE_RANDOM -lt 0 ]; then
        # Remove the first value of the file and start over
        sed -i 1d "$TEMPERATURE_FILE"
        echo 71 >> "$TEMPERATURE_FILE"
        TEMPERATURE_RANDOM=70
    elif [ $TEMPERATURE_RANDOM -gt 140 ]; then
         # Remove the first value of the file and start over
        sed -i 1d "$TEMPERATURE_FILE"
        echo 71 >> "$TEMPERATURE_FILE"
        TEMPERATURE_RANDOM=70
    fi
    
    # Remove the first value of the file
    sed -i 1d "$TEMPERATURE_FILE"
    
    # Append the new value
    echo $TEMPERATURE_RANDOM >> "$TEMPERATURE_FILE"
    
    echo $TEMPERATURE_RANDOM
}

get_real_temperature() {

    # Get CPU temperature using vcgencmd
    local temperature=$(vcgencmd measure_temp)

    # Extract numerical value from the temperature string
    local temperature_value=$(echo $temperature | grep -oP '\d+\.\d+')

    # Convert temperature to an integer (extracting only the integer part)
    local INT_TEMPERATURE=$(echo $temperature_value | cut -f1 -d"." )
    
    echo $INT_TEMPERATURE

}

# Function to get free memory
get_memory() {
    local mem_type="$1"
    local free_output=$(free -m)

    case "$mem_type" in
        "total")
            # Extract total memory value (in MB)
            echo "$free_output" | awk '/^Mem/ { print $2 }'
            ;;
        "used")
            # Extract used memory value (in MB)
            echo "$free_output" | awk '/^Mem/ { print $3 }'
            ;;
        "free")
            # Extract free memory value (in MB)
            echo "$free_output" | awk '/^Mem/ { print $4 }'
            ;;
        *)
            echo "Invalid memory type. Use 'total', 'used', or 'free'."
            ;;
    esac
}

# Function to return 0 or 1 randomly based on the given probability
available() {
    local probability=$1
    local random_number=$((RANDOM % 100))  # Generate a random number between 0 and 99

    # Return 0 based on the given probability
    if [ $random_number -lt $probability ]; then
        echo 0
    else
        echo 1
    fi
}


# Get CPU temperature using vcgencmd
TEMPERATURE=$(get_real_temperature)
# Generate random temperature
RANDOM_TEMPERATURE=$(generate_random_temperature)
# Reads the free memory
FREE_MEMORY=$(get_memory "free")
USED_MEMORY=$(get_memory "used")
# Random status values
RANDOM_80=$(available 80)
RANDOM_90=$(available 90)
RANDOM_95=$(available 95)

# Print the temperature
echo "Integer value: $TEMPERATURE Random temperature: $RANDOM_TEMPERATURE Free memory: $FREE_MEMORY Used memory: $USED_MEMORY"  >> "$LOG_FILE"
echo "Status 80: $RANDOM_80 Status 90: $RANDOM_90 Status 95: $RANDOM_95 " >> "$LOG_FILE"

# Call the Java program with the temperature as a parameter
$JAVA_COMMAND 40   "$TEMPERATURE" >> "$LOG_FILE" 2>&1
$JAVA_COMMAND 50  "$RANDOM_TEMPERATURE" >> "$LOG_FILE" 2>&1
$JAVA_COMMAND 60  "$FREE_MEMORY" >> "$LOG_FILE" 2>&1
$JAVA_COMMAND 70  "$USED_MEMORY" >> "$LOG_FILE" 2>&1
$JAVA_COMMAND 80  "$RANDOM_80" >> "$LOG_FILE" 2>&1
$JAVA_COMMAND 81  "$RANDOM_90" >> "$LOG_FILE" 2>&1
$JAVA_COMMAND 82  "$RANDOM_95" >> "$LOG_FILE" 2>&1


# Get current timestamp
timestamp=$(date +"%Y-%m-%d %T")

# Append timestamp and information to the log file
echo "Last run: $timestamp" >> "$LOG_FILE"
