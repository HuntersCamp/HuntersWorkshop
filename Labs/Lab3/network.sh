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

# Add connection
nmcli con add con-name "internal" ifname eth1 type ethernet ip4 192.168.40.10/24 gw4 192.168.40.1

# Set DNS server for connection
nmcli con mod "internal" ipv4.dns "208.67.222.222,208.67.220.220"

# Start new connection
nmcli con up "internal" iface eth1

# Restart networking stack
systemctl restart network

# Disable gateway over eth0
nmcli con modify "System eth0" ipv4.never-default yes
systemctl restart network

# Correct yum settings
sed -i -e 's/gpgcheck=1/gpgcheck=0/' /etc/yum.conf
