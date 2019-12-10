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
nmcli con add con-name "internal" ifname eth1 type ethernet ip4 192.168.40.1/24 gw4 192.168.40.1

# Set DNS server for connection
nmcli con mod "internal" ipv4.dns "208.67.222.222,208.67.220.220"

# Start new connection
nmcli con up "internal" iface eth1

# Restart networking stack
systemctl restart network

# Enable IP Forwarding
sysctl -w net.ipv4.ip_forward=1

# Configure NAT on the host firewall
firewall-cmd --permanent --direct --passthrough ipv4 -t nat -I POSTROUTING -o eth0 -j MASQUERADE -s 192.168.40.1/24

# Trust all traffic from internal interface
firewall-cmd --permanent --zone=trusted --add-interface=eth1

# Reload firewall
firewall-cmd --reload

# Install repository
yum -y install epel-release

# Install Zeek
yum -y install bro

# Create directories
mkdir -p /var/lib/bro/{host,site} /var/log/bro/{archive,sorted-logs,stats} /var/spool/bro/tmp

# Change paths in configs
sed -i -e '
    s|LogDir = /usr/logs|LogDir = /var/log/bro|;
    s|SpoolDir = /usr/spool|SpoolDir = /var/spool/bro|;
    ' /etc/bro/broctl.cfg

echo "LibDirInternal = /usr/lib/python2.7/site-packages/BroControl/" >> /etc/bro/broctl.cfg

# Change logging to JSON format
sed -i -e 's/use_json = F/use_json = T/' /usr/share/bro/base/frameworks/logging/writers/ascii.bro

# Deploy Zeek
broctl deploy

