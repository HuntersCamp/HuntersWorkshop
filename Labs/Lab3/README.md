# Lab 3 - Elastic Stack

Getting started with Zeek!

## Prerequisites

- [ ] CentOS 7 Host
- [ ] Gateway configured

## Create Zeek Gateway

### Configure Network

Run the `network.sh` script to configure the network on this host.

### Install Docker

Install Docker and all required packages on the host with the `install_docker.sh` script.

### Deploy the Elastic Stack with Docker Compose

Get the folder `elk` on to the Host.

``` bash
# Get into the docker folder
cd elk

# Get the docker compose up and running
docker-compose up -d

# Check that everything is installed
docker ps -a
```

### Deploy Beats

Beats ship the logs to the Elastic Stack

### Forward Logs to ELK

Forward Zeek logs with Filebeat to the Elastic Stack:

```bash
# Stop Zeek
broctl stop

# Change logging to JSON format
sed -i -e 's/use_json = F/use_json = T/' /usr/share/bro/base/frameworks/logging/writers/ascii.bro

# Start Zeek
broctl start

# Add these lines to the Filebeat config
-----
  - module: zeek
    connection:
      enabled: true
      var.paths: ["/var/log/bro/current/connection.log"]
    dns:
      enabled: true
      var.paths: ["/var/log/bro/current/dns.log"]
    http:
      enabled: true
      var.paths: ["/var/log/bro/current/http.log"]
    files:
      enabled: true
      var.paths: ["/var/log/bro/current/files.log"]
    ssl:
      enabled: true
      var.paths: ["/var/log/bro/current/ssl.log"]
    notice:
      enabled: true
      var.paths: ["/var/log/bro/current/notice.log"]
-----
```

