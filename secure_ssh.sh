#!/bin/bash
# Make sure to run this script as root
# Place the public ssh key in "~/.ssh", You can make it using "ssh-keygen -b 4096"

# Add the public key to the new user's authorized_keys file
sudo -u $CURRENT_USER mkdir /home/$CURRENT_USER/.ssh && sudo -u $CURRENT_USER chmod 700 /home/$CURRENT_USER/.ssh

# Edit SSH configuration file to disable root login and limit users who can SSH
echo "Configuring SSH..."
{
      sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
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
