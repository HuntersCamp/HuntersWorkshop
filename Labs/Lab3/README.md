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

Beats ship the logs to the Elastic Stack. We use the different beats to ship logs and metrics to the Elastic Stack.

#### Filebeat

The Filebeat has a wide variety of input methods. It was originally designed to ship the logs files. But there were more and more modules released over time. Now it can ship pretty much everything!

#### Metricbeat

The Metricbeat ships host metrics and health checks to the Elastic Stack. With these can be viewed under the infrastructure tab in Kibana.

#### Packetbeat

Packetbeat acts as a Netflow sensor on the host. It ships the flows, DNS lookups and TLS handshakes to the Elastic Stack.

#### Auditbeat

The Auditbeat handles everything concerning the audit of the system. File integrity, login attempts, what ever you want!

#### Installation

Install the beats

##### Centos 7

```bash
# Add the rpm key
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

# Add repository
vi /etc/yum.repos.d/elastic.repo

[elasticsearch-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md

# Install beats
yum install filebeat auditbeat packetbeat metricbeat

# Configure beats
vi /etc/<beat>/<beat>.yml

# Setup Beat
<beat> setup -e
```

##### Windows

1. Download Beat from Elastic website
2. Extract Beat
3. Put the beat into`C:\Program Files\Beats`
4. Set the Powershell execution policy `set-executionpolicy unrestricted`
5. Execute the installation Powershell

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

