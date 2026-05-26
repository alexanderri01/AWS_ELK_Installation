# ELK Stack on AWS — Automated Installation

This project contains automation scripts for deploying the following ELK stack architecture on AWS EC2 Ubuntu servers:

```text
Application Server (Filebeat)
        ↓
Logstash
        ↓
Elasticsearch
        ↓
Kibana
```

---

# Architecture

| Server | Purpose |
|---|---|
| Elasticsearch | Stores and indexes logs |
| Kibana | Visualization and dashboards |
| Logstash | Log processing pipeline |
| Application Server | Sends logs using Filebeat |

---

# Recommended AWS Setup

| Component | Recommended Instance | Disk |
|---|---|---|
| Elasticsearch | t3.medium / t3.large | 50-100 GB |
| Kibana | t3.small | 20 GB |
| Logstash | t3.small | 20 GB |
| Application Server | Any | Depends on logs |

OS:
- Ubuntu Server 22.04 LTS

---

# Included Scripts

| Script | Purpose |
|---|---|
| install-elasticsearch.sh | Install and configure Elasticsearch |
| install-kibana.sh | Install and configure Kibana |
| install-logstash.sh | Install and configure Logstash |
| install-filebeat.sh | Install and configure Filebeat |

---

# Prerequisites

Before running scripts:

- Create 4 EC2 Ubuntu instances
- Configure AWS Security Groups manually
- Ensure servers can communicate over private IPs
- Use Ubuntu 22.04 LTS
- Use sudo privileges

---

# Security Groups

## Elasticsearch Server

Allow:

| Port | Source |
|---|---|
| 9200 | Logstash + Kibana servers |
| 9300 | Elasticsearch nodes |
| 22 | Your public IP |

IMPORTANT:
Never expose Elasticsearch to the internet:

```text
0.0.0.0/0
```

for port 9200.

---

## Kibana Server

| Port | Source |
|---|---|
| 5601 | Your public IP |
| 22 | Your public IP |

---

## Logstash Server

| Port | Source |
|---|---|
| 5044 | Application Server |
| 22 | Your public IP |

---

## Application Server

| Port | Source |
|---|---|
| 22 | Your public IP |

---

# Installation Order

Run scripts in this order:

1. Elasticsearch
2. Kibana
3. Logstash
4. Filebeat (Application Server)

---

# 1. Elasticsearch Installation

Copy script:

```bash
nano install-elasticsearch.sh
```

Paste script content.

Make executable:

```bash
chmod +x install-elasticsearch.sh
```

Run:

```bash
./install-elasticsearch.sh
```

---

# 2. Kibana Installation

Copy script:

```bash
nano install-kibana.sh
```

Make executable:

```bash
chmod +x install-kibana.sh
```

Run:

```bash
./install-kibana.sh
```

The script will ask for:

```text
Enter Elasticsearch PRIVATE IP:
```

Example:

```text
10.0.1.10
```

---

# 3. Logstash Installation

Copy script:

```bash
nano install-logstash.sh
```

Make executable:

```bash
chmod +x install-logstash.sh
```

Run:

```bash
./install-logstash.sh
```

The script will ask for:

```text
Enter Elasticsearch PRIVATE IP:
```

---

# 4. Filebeat Installation

Copy script:

```bash
nano install-filebeat.sh
```

Make executable:

```bash
chmod +x install-filebeat.sh
```

Run:

```bash
./install-filebeat.sh
```

The script will ask for:

```text
Enter Logstash PRIVATE IP:
```

---

# Verify Services

## Elasticsearch

Check status:

```bash
sudo systemctl status elasticsearch
```

Test API:

```bash
curl http://localhost:9200
```

---

## Kibana

Check status:

```bash
sudo systemctl status kibana
```

Open browser:

```text
http://KIBANA_PUBLIC_IP:5601
```

---

## Logstash

Check status:

```bash
sudo systemctl status logstash
```

Check listening port:

```bash
sudo ss -lntp | grep 5044
```

---

## Filebeat

Check status:

```bash
sudo systemctl status filebeat
```

Check output:

```bash
sudo filebeat test output
```

---

# Create Kibana Data View

Open Kibana:

```text
Management → Stack Management → Data Views
```

Create:

```text
logs-*
```

Select time field:

```text
@timestamp
```

---

# Data Flow Validation

On Elasticsearch server:

```bash
curl http://localhost:9200/_cat/indices?v
```

Expected output:

```text
logs-2026.05.26
```

---

# Useful Log Files

## Elasticsearch

```bash
/var/log/elasticsearch/
```

## Kibana

```bash
/var/log/kibana/
```

## Logstash

```bash
/var/log/logstash/
```

## Filebeat

```bash
/var/log/filebeat/
```

---

# Useful Commands

## Restart Services

```bash
sudo systemctl restart elasticsearch
sudo systemctl restart kibana
sudo systemctl restart logstash
sudo systemctl restart filebeat
```

---

## Follow Logs

```bash
sudo journalctl -u elasticsearch -f
sudo journalctl -u kibana -f
sudo journalctl -u logstash -f
sudo journalctl -u filebeat -f
```

---

# Common Problems

## Elasticsearch Fails to Start

Usually caused by:
- low RAM
- incorrect heap size
- missing vm.max_map_count

Fix:

```bash
sudo sysctl -w vm.max_map_count=262144
```

---

## Kibana "Server is not ready yet"

Usually:
- Elasticsearch unavailable
- wrong IP
- firewall/security group issue

---

## Filebeat Cannot Connect

Test:

```bash
sudo filebeat test output
```

Check:
- Logstash running
- Port 5044 open
- Security group configured

---

# Production Recommendations

For production environments:

- Use private subnets
- Enable TLS/SSL
- Configure Elastic authentication
- Use snapshots/backups
- Enable monitoring
- Configure ILM (Index Lifecycle Management)
- Use multiple Elasticsearch nodes
- Use dedicated master/data nodes

---

# Future Improvements

Recommended next steps:

- Metricbeat monitoring
- Heartbeat uptime checks
- Kibana alerts
- Elastic Agent
- Docker/Kubernetes deployment
- Terraform automation
- Ansible deployment
- AWS Load Balancer
- Multi-node Elasticsearch cluster

---

# Technologies Used

- Elasticsearch
- Kibana
- Logstash
- Filebeat
- Ubuntu Linux
- AWS EC2

---

# Official Documentation

Elastic documentation:

- https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html
- https://www.elastic.co/guide/en/kibana/current/index.html
- https://www.elastic.co/guide/en/logstash/current/index.html
- https://www.elastic.co/guide/en/beats/filebeat/current/index.html

AWS documentation:

- https://docs.aws.amazon.com/ec2/

---

# License

Free to use for learning and internal infrastructure deployments.
