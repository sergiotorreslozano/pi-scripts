#!/bin/bash

# Define variables
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
SERVICE_FILE="/etc/systemd/system/send_to_modbus.service"
TIMER_FILE="/etc/systemd/system/send_to_modbus.timer"
SCRIPT_PATH="$SCRIPT_DIR/send_to_modbus.sh"

# Function to create or update the service file
create_service_file() {
    echo "Creating service file..."
    sudo tee $SERVICE_FILE > /dev/null <<EOL
[Unit]
Description=Send data to Modbus

[Service]
Type=oneshot
ExecStart=$SCRIPT_PATH
WorkingDirectory=$SCRIPT_DIR

[Install]
WantedBy=multi-user.target
EOL
}

# Function to create or update the timer file
create_timer_file() {
    echo "Creating timer file..."
    sudo tee $TIMER_FILE > /dev/null <<EOL
[Unit]
Description=Run send_to_modbus service every 20 seconds

[Timer]
OnBootSec=1min
OnUnitActiveSec=20s

[Install]
WantedBy=timers.target
EOL
}

# Function to install pymodbus
install_pymodbus() {
    echo "Installing pymodbus..."
    sudo /usr/bin/python3 -m pip install pymodbus
}

# Function to enable and start the timer
enable_and_start_timer() {
    echo "Enabling and starting the timer..."
    sudo systemctl daemon-reload
    sudo systemctl enable send_to_modbus.timer
    sudo systemctl start send_to_modbus.timer
}

# Run the functions
install_pymodbus
create_service_file
create_timer_file
enable_and_start_timer

echo "Setup complete."
