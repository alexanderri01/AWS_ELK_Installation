# ================================
# 2. Kibana Install Script
# File: install-kibana.sh
# ================================

#!/bin/bash

set -e

echo "======================================="
echo " KIBANA INSTALLATION STARTED"
echo "======================================="

read -p "Enter Elasticsearch PRIVATE IP: " ES_IP

sudo apt update -y

sudo apt install -y openjdk-17-jdk wget apt-transport-https curl

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | \
sudo tee /etc/apt/sources.list.d/elastic-8.x.list

sudo apt update -y

echo "Installing Kibana..."

sudo apt install -y kibana

echo "Configuring Kibana..."

sudo tee /etc/kibana/kibana.yml > /dev/null <<EOF
server.port: 5601

server.host: "0.0.0.0"

elasticsearch.hosts: ["http://$ES_IP:9200"]
EOF

echo "Starting Kibana..."

sudo systemctl enable kibana
sudo systemctl restart kibana

echo ""
echo "======================================="
echo " KIBANA INSTALLATION COMPLETED"
echo "======================================="
echo ""
echo "Open browser:"
echo "http://YOUR_KIBANA_PUBLIC_IP:5601"
