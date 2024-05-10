## Introduction

This repository contains two essential shell scripts for securing a server environment. The scripts, secure.sh and secure_ssh.sh, automate the process of enhancing server security by installing necessary packages, configuring settings, and creating a new user with sudo privileges. Below is a detailed guide on how to use these scripts effectively.

## secure.sh

The secure.sh script focuses on installing unattended-upgrades, a crucial package for automatic system updates, and creating a new user with sudo privileges. It ensures that your server stays up-to-date and secure without manual intervention.

### Usage

1. Run the script as root.
2. Follow the on-screen instructions to proceed with the script.
3. The script will update packages, install unattended-upgrades, configure automatic updates, and prompt for a new username with sudo privileges.

## secure_ssh.sh

The secure_ssh.sh script is designed to configure SSH settings, install and enable a firewall (UFW), allow SSH through the firewall, install Fail2Ban for intrusion prevention, and configure it to enhance server security.

MAKE SURE TO ADD A SSH KEY TO YOUR SERVER AND CHECK BY CONNECTING IT OR YOU WILL BE LOCKED OUT OF YOUR SERVER

### Usage

1. Run the script as root.
2. Confirm your intention to proceed with the script.
3. Enter the user with SSH keys when prompted.
4. The script will configure SSH settings, install and enable UFW, allow SSH through the firewall, install Fail2Ban, and configure it for enhanced security.

## Important Notes

- Ensure you have necessary permissions to run these scripts.
- Review the scripts and customize any settings as needed before execution.
- Make sure to back up any critical data before making system changes.

## Conclusion

By using these scripts in the SearXNG-dotfiles repository, you can automate the process of securing your server environment effectively. These scripts provide a convenient way to enhance security measures and ensure your server remains protected against potential threats.
