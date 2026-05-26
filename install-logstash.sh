# ================================
# 3. Logstash Install Script
# File: install-logstash.sh
# ================================

#!/bin/bash

set -e

echo "======================================="
echo " LOGSTASH INSTALLATION STARTED"
echo "======================================="

read -p "Enter Elasticsearch PRIVATE IP: " ES_IP

sudo apt update -y

sudo apt install -y openjdk-17-jdk wget apt-transport-https curl

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | \
sudo tee /etc/apt/sources.list.d/elastic-8.x.list

sudo apt update -y

echo "Installing Logstash..."

sudo apt install -y logstash

echo "Creating Logstash pipeline..."

sudo tee /etc/logstash/conf.d/logstash.conf > /dev/null <<EOF
input {
  beats {
    port => 5044
  }
}

filter {

}

output {
  elasticsearch {
    hosts => ["http://$ES_IP:9200"]
    index => "logs-%{+YYYY.MM.dd}"
  }
}
EOF

echo "Starting Logstash..."

sudo systemctl enable logstash
sudo systemctl restart logstash

echo ""
echo "======================================="
echo " LOGSTASH INSTALLATION COMPLETED"
echo "======================================="
