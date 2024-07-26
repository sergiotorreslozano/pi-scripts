#!/bin/bash

# Assigning arguments to variables
server_address="192.168.68.202"
port="50200"


# Calling the Python script with parameters
    /usr/bin/python3 /home/sergiotorres/pi_aq/04_send_to_modbus.py "$server_address" "$port" "100" "temp"
    /usr/bin/python3 /home/sergiotorres/pi_aq/04_send_to_modbus.py "$server_address" "$port" "110" "co2"

    
