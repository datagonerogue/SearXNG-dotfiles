#!/bin/bash
# Make sure to run this script as root
# Place the public ssh key in "~/.ssh", You can make it using "ssh-keygen -b 4096"

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Confirmation message with user input
echo "This script will configure SSH, install and enable a firewall, allow SSH through the firewall, install Fail2Ban, and configure it."
read -p "Proceed with the script? (y/n): " CONFIRMATION

if [[ $CONFIRMATION != "y" ]]; then
    echo "aborted."
    exit 1
fi

CURRENT_USER=$(whoami)

# Add the public key to the new user's authorized_keys file
sudo chmod 700 /home/$CURRENT_USER/.ssh

# Configure SSH
echo -n "Configuring SSH "
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
SSH_PID=$!
{
      sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
      echo "AllowUsers $CURRENT_USER" >> /etc/ssh/sshd_config
      sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
      systemctl restart sshd
} > /dev/null 2>&1
kill $SSH_PID
echo "
Done!"


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
echo "
/////////////////////////////////////////////////////////////////////
SSH configured, firewall installed and enabled, SSH allowed through firewall,
Fail2Ban installed and configured.
Server secured successfully.
/////////////////////////////////////////////////////////////////////
"
