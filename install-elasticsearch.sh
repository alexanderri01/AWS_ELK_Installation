# ================================
# 1. Elasticsearch Install Script
# File: install-elasticsearch.sh
# ================================

#!/bin/bash

set -e

echo "======================================="
echo " ELASTICSEARCH INSTALLATION STARTED"
echo "======================================="

sudo apt update -y

sudo apt install -y openjdk-17-jdk wget apt-transport-https curl

echo "Installing Elasticsearch repository..."

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | \
sudo tee /etc/apt/sources.list.d/elastic-8.x.list

sudo apt update -y

echo "Installing Elasticsearch..."

sudo apt install -y elasticsearch

echo "Configuring Elasticsearch..."

sudo tee /etc/elasticsearch/elasticsearch.yml > /dev/null <<EOF
cluster.name: production-elk

node.name: node-1

network.host: 0.0.0.0

http.port: 9200

discovery.type: single-node
EOF

echo "Setting JVM heap..."

sudo mkdir -p /etc/elasticsearch/jvm.options.d/

sudo tee /etc/elasticsearch/jvm.options.d/custom.options > /dev/null <<EOF
-Xms2g
-Xmx2g
EOF

echo "Setting vm.max_map_count..."

sudo sysctl -w vm.max_map_count=262144

echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf

echo "Starting Elasticsearch..."

sudo systemctl daemon-reload
sudo systemctl enable elasticsearch
sudo systemctl restart elasticsearch

echo "Waiting for Elasticsearch..."

sleep 20

curl http://localhost:9200

echo ""
echo "======================================="
echo " ELASTICSEARCH INSTALLATION COMPLETED"
echo "======================================="
