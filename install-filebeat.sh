# ================================
# 4. Application Server Script
# File: install-filebeat.sh
# ================================

#!/bin/bash

set -e

echo "======================================="
echo " FILEBEAT INSTALLATION STARTED"
echo "======================================="

read -p "Enter Logstash PRIVATE IP: " LOGSTASH_IP

sudo apt update -y

sudo apt install -y wget apt-transport-https curl

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | \
sudo tee /etc/apt/sources.list.d/elastic-8.x.list

sudo apt update -y

echo "Installing Filebeat..."

sudo apt install -y filebeat

echo "Configuring Filebeat..."

sudo tee /etc/filebeat/filebeat.yml > /dev/null <<EOF
filebeat.inputs:

- type: filestream
  id: system-logs
  enabled: true
  paths:
    - /var/log/*.log

output.logstash:
  hosts: ["$LOGSTASH_IP:5044"]
EOF

echo "Enabling system module..."

sudo filebeat modules enable system

echo "Starting Filebeat..."

sudo systemctl enable filebeat
sudo systemctl restart filebeat

echo ""
echo "======================================="
echo " FILEBEAT INSTALLATION COMPLETED"
echo "======================================="
