# Prometheus and Grafana Monitoring Stack

A complete DevOps monitoring solution using Prometheus, Grafana, Alertmanager, Node Exporter, and cAdvisor.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Accessing Services](#accessing-services)
- [Setting Up Dashboards](#setting-up-dashboards)
- [Alert Configuration](#alert-configuration)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

This project provides a production-ready monitoring stack with:

- **Prometheus**: Time-series database and monitoring system
- **Grafana**: Visualization and analytics platform
- **Alertmanager**: Alert management and routing
- **Node Exporter**: Hardware and OS metrics
- **cAdvisor**: Container metrics

## 🏗️ Architecture

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   Grafana   │────▶│  Prometheus  │────▶│ Exporters   │
│   :3000     │     │    :9090     │     │ (Metrics)   │
└─────────────┘     └──────────────┘     └─────────────┘
                           │
                           ▼
                    ┌──────────────┐
                    │ Alertmanager │
                    │    :9093     │
                    └──────────────┘
```

## 📦 Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- At least 2GB of free RAM
- Ports available: 3000, 8080, 9090, 9093, 9100

## 🚀 Quick Start

### 1. Clone and Setup

```bash
# Create project directory
mkdir prometheus-monitoring && cd prometheus-monitoring

# Create directory structure
mkdir -p prometheus alertmanager grafana/{provisioning/{datasources,dashboards},dashboards}

# Copy all configuration files to their respective directories
# (docker-compose.yml, prometheus.yml, alert_rules.yml, etc.)
```

### 2. Directory Structure

```
prometheus-monitoring/
├── docker-compose.yml
├── setup.sh
├── prometheus/
│   ├── prometheus.yml
│   └── alert_rules.yml
├── alertmanager/
│   └── alertmanager.yml
└── grafana/
    ├── provisioning/
    │   ├── datasources/
    │   │   └── datasource.yml
    │   └── dashboards/
    │       └── dashboard.yml
    └── dashboards/
```

### 3. Start the Stack

```bash
# Make setup script executable
chmod +x setup.sh

# Run setup
./setup.sh

# Or manually start with docker-compose
docker-compose up -d
```

### 4. Verify Installation

```bash
# Check all services are running
docker-compose ps

# Check logs
docker-compose logs -f
```

## ⚙️ Configuration

### Prometheus Configuration

Edit `prometheus/prometheus.yml` to add new targets:

```yaml
scrape_configs:
  - job_name: 'my_application'
    static_configs:
      - targets: ['app:8000']
        labels:
          environment: 'production'
```

### Alert Rules

Customize alerts in `prometheus/alert_rules.yml`:

```yaml
- alert: MyCustomAlert
  expr: my_metric > 100
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "Custom alert triggered"
```

### Alertmanager

Configure notifications in `alertmanager/alertmanager.yml`:

**Email Setup:**
```yaml
global:
  smtp_smarthost: 'smtp.gmail.com:587'
  smtp_from: 'alerts@yourdomain.com'
  smtp_auth_username: 'your-email@gmail.com'
  smtp_auth_password: 'your-app-password'
```

**Slack Setup:**
```yaml
receivers:
  - name: 'slack-alerts'
    slack_configs:
      - api_url: 'https://hooks.slack.com/services/YOUR/WEBHOOK/URL'
        channel: '#alerts'
        title: 'Alert: {{ .GroupLabels.alertname }}'
```

## 🌐 Accessing Services

| Service | URL | Credentials |
|---------|-----|-------------|
| Grafana | http://localhost:3000 | admin / admin123 |
| Prometheus | http://localhost:9090 | - |
| Alertmanager | http://localhost:9093 | - |
| Node Exporter | http://localhost:9100/metrics | - |
| cAdvisor | http://localhost:8080 | - |

## 📊 Setting Up Dashboards

### Import Pre-built Dashboards

1. Login to Grafana (http://localhost:3000)
2. Navigate to **Dashboards** → **Import**
3. Enter Dashboard ID and click **Load**

**Recommended Dashboard IDs:**
- **1860**: Node Exporter Full (System metrics)
- **893**: Docker Dashboard (Container metrics)
- **3662**: Prometheus 2.0 Overview
- **315**: Kubernetes Cluster Monitoring

### Create Custom Dashboard

1. Click **+** → **Dashboard**
2. Add Panel → Choose visualization
3. Select Prometheus as data source
4. Write PromQL query (e.g., `rate(cpu_usage[5m])`)
5. Customize and Save

## 🔔 Alert Configuration

### Testing Alerts

```bash
# Trigger high CPU alert (simulate load)
docker exec -it node_exporter stress --cpu 8 --timeout 300s

# Check Prometheus alerts
curl http://localhost:9090/api/v1/alerts

# Check Alertmanager
curl http://localhost:9093/api/v1/alerts
```

### Alert States

- **Inactive**: Condition not met
- **Pending**: Condition met, waiting for `for` duration
- **Firing**: Alert is active and being sent

## 🔧 Common Operations

### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f prometheus
docker-compose logs -f grafana
```

### Restart Services

```bash
# Restart all
docker-compose restart

# Restart specific service
docker-compose restart prometheus
```

### Update Configuration

```bash
# After editing prometheus.yml or alert_rules.yml
docker-compose restart prometheus

# Reload without restart (if web.enable-lifecycle is enabled)
curl -X POST http://localhost:9090/-/reload
```

### Backup Data

```bash
# Backup volumes
docker-compose down
docker run --rm -v prometheus-monitoring_prometheus_data:/data -v $(pwd):/backup alpine tar czf /backup/prometheus-backup.tar.gz /data

# Restore
docker run --rm -v prometheus-monitoring_prometheus_data:/data -v $(pwd):/backup alpine tar xzf /backup/prometheus-backup.tar.gz
```

## 🐛 Troubleshooting

### Services Not Starting

```bash
# Check Docker is running
docker info

# Check ports are available
netstat -tuln | grep -E '3000|8080|9090|9093|9100'

# Check logs for errors
docker-compose logs
```

### Prometheus Can't Scrape Targets

```bash
# Check Prometheus targets
curl http://localhost:9090/api/v1/targets

# Verify network connectivity
docker-compose exec prometheus wget -O- http://node_exporter:9100/metrics
```

### Grafana Can't Connect to Prometheus

1. Check datasource configuration in Grafana
2. Verify Prometheus URL: `http://prometheus:9090`
3. Test connection in Grafana datasource settings

### No Alerts Firing

```bash
# Check alert rules are loaded
curl http://localhost:9090/api/v1/rules

# Verify Alertmanager connection
curl http://localhost:9090/api/v1/alertmanagers
```

## 📈 PromQL Examples

```promql
# CPU usage per core
rate(node_cpu_seconds_total[5m])

# Memory usage percentage
100 * (1 - ((node_memory_MemAvailable_bytes) / (node_memory_MemTotal_bytes)))

# Disk usage
100 - ((node_filesystem_avail_bytes * 100) / node_filesystem_size_bytes)

# Container memory usage
sum(container_memory_usage_bytes) by (name)

# HTTP request rate
rate(http_requests_total[5m])
```

## 🔐 Security Recommendations

1. **Change default passwords** in `docker-compose.yml`
2. **Use environment variables** for sensitive data
3. **Enable HTTPS** with reverse proxy (nginx/traefik)
4. **Restrict network access** using firewall rules
5. **Regularly update** Docker images
6. **Enable authentication** on Prometheus (basic auth/OAuth)

## 📚 Additional Resources

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [PromQL Basics](https://prometheus.io/docs/prometheus/latest/querying/basics/)
- [Alerting Rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/)
- [Grafana Dashboards](https://grafana.com/grafana/dashboards/)

## 🛑 Cleanup

```bash
# Stop and remove containers
docker-compose down

# Remove volumes (WARNING: deletes all data)
docker-compose down -v

# Remove images
docker-compose down --rmi all
```

## 📝 License

This project is open source and available under the MIT License.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

---

**Created for DevOps monitoring and observability**