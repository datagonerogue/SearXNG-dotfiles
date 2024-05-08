#!/bin/bash

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Update package lists
echo "Updating package lists..."
sudo apt update

# Upgrade installed packages
echo "Upgrading installed packages..."
sudo apt upgrade -y

# Install firewall (if not already installed)
echo "Installing and enabling firewall..."
sudo apt install ufw -y
sudo ufw enable

# Allow SSH (replace 22 with your SSH port if customized)
echo "Allowing SSH through firewall..."
sudo ufw allow 22

# Edit SSH configuration file to disable root login and limit users who can SSH
echo "Configuring SSH..."
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sudo echo "AllowUsers yourusername" >> /etc/ssh/sshd_config
sudo systemctl restart sshd

# Install Fail2Ban
echo "Installing Fail2Ban..."
sudo apt install fail2ban -y

# Configure Fail2Ban (optional but recommended)
echo "Configuring Fail2Ban..."
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo sed -i 's/enable = false/enable = true/g' /etc/fail2ban/jail.local

# Install unattended-upgrades
echo "Installing unattended-upgrades..."
sudo apt install unattended-upgrades -y

# Configure automatic updates
echo "Configuring automatic updates..."
sudo dpkg-reconfigure --priority=low unattended-upgrades

# Enable logging for the script
LOG_FILE="/var/log/secure_script.log"
exec > >(tee -a $LOG_FILE)
exec 2>&1

# Error handling
set -e

# Display completion message
echo "Server secured successfully. Check $LOG_FILE for details."
