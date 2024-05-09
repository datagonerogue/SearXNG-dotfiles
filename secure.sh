#!/bin/bash
# Make sure to run this script as root

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Confirmation message with user input
echo "This script will install unattended-upgrades packages"
read -p "Proceed with the script? (y/n): " CONFIRMATION

if [[ $CONFIRMATION != "y" ]]; then
    echo "Script execution aborted."
    exit 1
fi

# Update 
echo -n "Updating and Upgrading packages "
while true; do
    echo -n "/"
    sleep 0.2
    echo -ne "\b-"
    sleep 0.2
    echo -ne "\b\\"
    sleep 0.2
    echo -ne "\b|"
    sleep 0.2
    echo -ne "\b"
done &
UPDATE_PID=$!
{
    apt update
    apt upgrade -y
} > /dev/null 2>&1
kill $UPDATE_PID
echo "
Done!"

# Install unattended-upgrades
echo -n "
Installing unattended-upgrades "
while true; do
    echo -n "/"
    sleep 0.2
    echo -ne "\b-"
    sleep 0.2
    echo -ne "\b\\"
    sleep 0.2
    echo -ne "\b|"
    sleep 0.2
    echo -ne "\b"
done &
INSTALL_PID=$!
{
      apt install unattended-upgrades -y
} > /dev/null 2>&1
kill $INSTALL_PID
echo "
Done!"

# Configure automatic updates
echo -n "
Configuring automatic updates "
while true; do
    echo -n "/"
    sleep 0.2
    echo -ne "\b-"
    sleep 0.2
    echo -ne "\b\\"
    sleep 0.2
    echo -ne "\b|"
    sleep 0.2
    echo -ne "\b"
done &
CONFIG_PID=$!
dpkg-reconfigure -fnoninteractive unattended-upgrades
kill $CONFIG_PID
echo "
Done!"

# Prompt for new username with sudo privileges
echo "
Adding a new user..."
read -p "Enter the username for the new user with sudo privileges: " NEW_USER
useradd  -m -s /bin/bash $NEW_USER
usermod -aG sudo $NEW_USER
passwd $NEW_USER

# Display completion message
echo "
A new user with sudo privileges has been created: $NEW_USER"
echo "Server secured successfully."