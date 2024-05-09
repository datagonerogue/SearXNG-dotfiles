#!/bin/bash
# Make sure to run this script as root

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Update 
echo "Updating and Upgrading packages ..."
{
    apt update
    apt upgrade -y
} > /dev/null 2>&1

# Install unattended-upgrades
echo "Installing unattended-upgrades..."
{
      apt install unattended-upgrades -y
} > /dev/null 2>&1


# Configure automatic updates
echo "Configuring automatic updates..."
dpkg-reconfigure -fnoninteractive unattended-upgrades

# Prompt for new username with sudo privileges
read -p "Enter the username for the new user with sudo privileges: " NEW_USER
useradd  -m -s /bin/bash $NEW_USER
usermod -aG sudo $NEW_USER
passwd $NEW_USER
# Display completion message
echo "Server secured successfully."
echo "A new user with sudo privileges has been created: $NEW_USER"
