#!/bin/bash

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

# Add the public key to the new user's authorized_keys file
sudo -u $NEW_USER mkdir /home/$NEW_USER/.ssh && sudo -u $NEW_USER chmod 700 /home/$NEW_USER/.ssh

# Edit SSH configuration file to disable root login and limit users who can SSH
echo "Configuring SSH..."
{
      sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
      echo "AllowUsers $NEW_USER" >> /etc/ssh/sshd_config
      systemctl restart sshd
} > /dev/null 2>&1

# Install firewall (if not already installed)
echo "Installing and enabling firewall..."
{
      apt install ufw -y
      echo "y" | ufw enable
} > /dev/null 2>&1

# Allow SSH (replace 22 with your SSH port if customized)
echo "Allowing SSH through firewall..."
{
ufw allow 22
} > /dev/null 2>&1

# Install Fail2Ban
echo "Installing Fail2Ban..."
{
apt install fail2ban -y
} > /dev/null 2>&1


# Configure Fail2Ban (optional but recommended)
echo "Configuring Fail2Ban..."
{
      cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
      sed -i 's/enable = false/enable = true/g' /etc/fail2ban/jail.local

} > /dev/null 2>&1

# Display completion message
echo "Server secured successfully. Check $LOG_FILE for details."
echo "A new user with sudo privileges has been created: $NEW_USER"
