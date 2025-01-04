#!/bin/bash

# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please run it using sudo or as the root user."
    exit 1
fi

# Check if powertop is installed
if ! command -v powertop &> /dev/null
then
    echo "powertop not found, installing..."
    # Update package list and install powertop
    apt update && apt install -y powertop
else
    echo "powertop is already installed."
fi

# Create a systemd service file for powertop
SERVICE_FILE="/etc/systemd/system/powertop-auto-tune.service"

# Check if the systemd service file already exists
if [ ! -f "$SERVICE_FILE" ]; then
    echo "Creating systemd service to run powertop with --auto-tune at startup..."
    
    # Create the service file with the necessary configuration
    cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Powertop Auto-Tune at Startup
After=multi-user.target

[Service]
ExecStart=/usr/sbin/powertop --auto-tune
Type=simple
ExecStartPost=/usr/bin/sleep 2

[Install]
WantedBy=multi-user.target
EOF

    # Reload systemd to recognize the new service
    systemctl daemon-reload

    # Enable the service to run at startup
    systemctl enable powertop-auto-tune.service

    # Start the service immediately (optional)
    systemctl start powertop-auto-tune.service

    echo "Systemd service created and started successfully."
else
    echo "Systemd service for powertop already exists."
fi

# Display status of the service
systemctl status powertop-auto-tune.service

# Check current CPU governor and prompt user to change it to 'powersave' if needed
echo "Checking current CPU governor settings..."

# Loop through all CPUs and check the current governor
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    current_governor=$(cat "$cpu")
    echo "Current governor for $(basename $(dirname $cpu)) is: $current_governor"

    if [ "$current_governor" != "powersave" ]; then
        read -p "Do you want to set the governor of $(basename $(dirname $cpu)) to 'powersave'? (y/n): " choice
        case "$choice" in
            [Yy]* )
                echo "Setting CPU governor to 'powersave' mode for $(basename $(dirname $cpu))..."
                echo "powersave" > "$cpu"
                echo "CPU governor for $(basename $(dirname $cpu)) set to 'powersave'."
                ;;
            [Nn]* )
                echo "Skipping setting CPU governor for $(basename $(dirname $cpu))."
                ;;
            * )
                echo "Invalid input. Skipping setting CPU governor for $(basename $(dirname $cpu))."
                ;;
        esac
    fi
done
