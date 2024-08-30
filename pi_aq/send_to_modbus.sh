#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Assigning arguments to variables
server_address="192.168.68.210"
port="50200"

# Path to the Python script
PYTHON_SCRIPT="$SCRIPT_DIR/04_send_to_modbus.py"

# Calling the Python script with parameters
/usr/bin/python3 "$PYTHON_SCRIPT" "$server_address" "$port" "100" "temp"
/usr/bin/python3 "$PYTHON_SCRIPT" "$server_address" "$port" "110" "co2"
