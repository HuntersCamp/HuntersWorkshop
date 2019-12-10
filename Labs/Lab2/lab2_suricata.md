# Lab 2 - Suricata

Getting started with Suricata!

## Prerequisites

- [ ] CentOS 7 Host

## Create Suricata Gateway

In this module we install Suricata

### Install Suricata

We install Suricata on the host using the epel repository:

```bash
# Install epel-repository
yum -y install epel-release

# Install Suricata
yum -y install suricata

# Install PIP for the rule updater
yum -y install python-pip

# Install the rules
pip install --upgrade suricata-update --user

# Start Suricata
sudo systemctl start suricata
```

