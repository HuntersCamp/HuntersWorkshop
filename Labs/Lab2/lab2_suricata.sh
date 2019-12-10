#!/bin/bash

# Define Basic Shell Funcitons

NCL='\033[0m'
CLR='\033[0;31m'
CLG='\033[0;32m'

# Check if script is run as root

if [ "$EUID" -ne 0 ]; then
  echo -e "${CLR}[ USER ] - ERROR: Please run this script as root!${NCL}"
  exit
fi

# Install repository
yum -y install epel-release

# Install Suricata
yum -y install suricata python-pip

# Install Suricata-Update
pip install --upgrade suricata-update --user

# Start Suricata
sudo systemctl start suricata
