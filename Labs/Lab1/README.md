# Lab 1 - Zeek

Getting started with Zeek!

## Prerequisites

- [ ] CentOS 7 Host
- [ ] Two NICs
  - [ ] Public NIC
  - [ ] Private NIC

## Create Zeek Gateway

In this module we create a Gateway with Zeek installed on it!

### Configure Networking

To use the Linux host as gateway we need to enable IP NAT on the host.

First we need to set the IP address on the internal interfaces:

```bash
# Add connection
nmcli con add con-name "internal" ifname eth1 type thernet ip4 192.168.40.1/24 gw4 192.168.40.1

# Set DNS server for connection
nmcli con mod "internal" ipv4.dns "208.67.222.222,208.67.220.220"

# Start new connection
nmcli con up "internal" iface eth1

# Restart networking stack
systemctl restart network
```

Now we enable IP NAT on the host:

```bash
# Enable IP Forwarding
sysctl -w net.ipv4.ip_forward=1

# Configure NAT on the host firewall
firewall-cmd --permanent --direct --passthrough ipv4 -t nat -I POSTROUTING -o eth0 -j MASQUERADE -s 192.168.40.1/24

# Trust all traffic from internal interface
firewall-cmd --permanent --zone=trusted --add-interface=eth1

# Reload firewall
firewall-cmd --reload
```

### Install Zeek

Install Zeek:

```bash
# Install repository
yum install epel-release

# Install Zeek
yum install bro

# Create directories
mkdir -p /var/lib/bro/{host,site} /var/log/bro/{archive,sorted-logs,stats} /var/spool/bro/tmp

# Change paths in configs
sed -i -e '
    s|LogDir = /usr/logs|LogDir = /var/log/bro|;
    s|SpoolDir = /usr/spool|SpoolDir = /var/spool/bro|;
    ' /etc/bro/broctl.cfg
    
# Deploy zeek
broctl deploy
```

### Zeek Scripting

Learn everything about Zeek scripting at: [try.zeek.org](http://try.bro.org/#/?example=hello)