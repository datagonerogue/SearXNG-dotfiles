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
apt upgrade -y

# Prompt for new username with sudo privileges
read -p "Enter the username for the new user with sudo privileges: " NEW_USER
useradd -m -s /bin/bash $NEW_USER
usermod -aG sudo $NEW_USER

# Edit SSH configuration file to disable root login and limit users who can SSH
echo "Configuring SSH..."
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
echo "AllowUsers $NEW_USER" >> /etc/ssh/sshd_config
systemctl restart sshd

# Install firewall (if not already installed)
echo "Installing and enabling firewall..."
apt install ufw -y
ufw enable

# Allow SSH (replace 22 with your SSH port if customized)
echo "Allowing SSH through firewall..."
ufw allow 22

# Install Fail2Ban
echo "Installing Fail2Ban..."
apt install fail2ban -y

# Configure Fail2Ban (optional but recommended)
echo "Configuring Fail2Ban..."
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sed -i 's/enable = false/enable = true/g' /etc/fail2ban/jail.local

# Install unattended-upgrades
echo "Installing unattended-upgrades..."
apt install unattended-upgrades -y

# Configure automatic updates
echo "Configuring automatic updates..."
dpkg-reconfigure --priority=low unattended-upgrades


# Enable logging for the script
LOG_FILE="/var/log/secure_script.log"
exec > >(tee -a $LOG_FILE)
exec 2>&1

# Error handling
set -e

# Display completion message
echo "Server secured successfully. Check $LOG_FILE for details."
echo "A new user with sudo privileges has been created: $NEW_USER"
