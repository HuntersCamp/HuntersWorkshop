#!/bin/bash -e

# Define Basic Shell Funcitons

NCL='\033[0m'
CLR='\033[0;31m'
CLG='\033[0;32m'

# Check if script is run as root

if [ "$EUID" -ne 0 ]; then
  echo -e "${CLR}[ USER ] - ERROR: Please run this script as root!${NCL}"
  exit
fi


# Install elastic repo
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cp ./beats/elastic.repo /etc/yum.repos.d/
chmod --reference=/etc/yum.repos.d/epel.repo /etc/yum.repos.d/elastic.repo

# Install Filebeat
yum install -y filebeat
mv /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.back
cp ./beats/filebeat.yml /etc/filebeat/filebeat.yml
chown --reference=/etc/filebeat/filebeat.yml.back /etc/filebeat/filebeat.yml
chmod --reference=/etc/filebeat/filebeat.yml.back /etc/filebeat/filebeat.yml

# Install Metricbeat
yum install -y metricbeat
mv /etc/metricbeat/metricbeat.yml /etc/metricbeat/metricbeat.yml.back
cp ./beats/metricbeat.yml /etc/metricbeat/metricbeat.yml
chown --reference=/etc/metricbeat/metricbeat.yml.back /etc/metricbeat/metricbeat.yml
chmod --reference=/etc/metricbeat/metricbeat.yml.back /etc/metricbeat/metricbeat.yml

# Install Packetbeat
yum install -y packetbeat
mv /etc/packetbeat/packetbeat.yml /etc/packetbeat/packetbeat.yml.back
cp ./beats/packetbeat.yml /etc/packetbeat/packetbeat.yml
chown --reference=/etc/packetbeat/packetbeat.yml.back /etc/packetbeat/packetbeat.yml
chmod --reference=/etc/packetbeat/packetbeat.yml.back /etc/packetbeat/packetbeat.yml

# Install Auditbeat
service auditd stop
yum install -y auditbeat
mv /etc/auditbeat/auditbeat.yml /etc/auditbeat/auditbeat.yml.back
cp ./beats/auditbeat.yml /etc/auditbeat/auditbeat.yml
cp ./beats/auditd-attack.rules /etc/auditbeat/audit.rules.d/attack.conf
chown --reference=/etc/auditbeat/audit.rules.d/sample-rules.conf.disabled /etc/auditbeat/audit.rules.d/attack.conf
chmod --reference=/etc/auditbeat/audit.rules.d/sample-rules.conf.disabled /etc/auditbeat/audit.rules.d/attack.conf
chown --reference=/etc/auditbeat/auditbeat.yml.back /etc/auditbeat/auditbeat.yml
chmod --reference=/etc/auditbeat/auditbeat.yml.back /etc/auditbeat/auditbeat.yml

# Setup Beats
filebeat setup -e
metricbeat setup -e
packetbeat setup -e
auditbeat setup -e

# Start Beats
systemctl enable filebeat --now
systemctl enable metricbeat --now
systemctl enable packetbeat --now
systemctl enable auditbeat --now
