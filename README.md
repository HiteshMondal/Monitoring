# 🚀 Production Prometheus & Grafana Monitoring Stack

[![Docker](https://img.shields.io/badge/Docker-20.10%2B-blue)](https://www.docker.com/)
[![Prometheus](https://img.shields.io/badge/Prometheus-v2.47-orange)](https://prometheus.io/)
[![Grafana](https://img.shields.io/badge/Grafana-v10.1-yellow)](https://grafana.com/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

A complete, production-ready monitoring solution with Prometheus, Grafana, AlertManager, and multiple exporters. Deploy in minutes with comprehensive alerting, dashboards, and best practices built-in.

---

## 📋 Table of Contents

- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Detailed Setup](#-detailed-setup)
- [Configuration](#-configuration)
- [Access & Credentials](#-access--credentials)
- [Dashboards](#-dashboards)
- [Alerting](#-alerting)
- [Troubleshooting](#-troubleshooting)
- [Maintenance](#-maintenance)

---

## ✨ Features

- **🔍 Prometheus**: Time-series database with 30-day retention
- **📊 Grafana**: Beautiful dashboards with auto-provisioning
- **🚨 AlertManager**: Multi-channel alert routing (Slack, Email, PagerDuty)
- **💻 Node Exporter**: Host/VM metrics (CPU, Memory, Disk, Network)
- **🐳 cAdvisor**: Docker container metrics
- **🔗 Blackbox Exporter**: HTTP/HTTPS/TCP endpoint monitoring
- **📤 Pushgateway**: Batch job and short-lived process metrics
- **✅ Health Checks**: Automatic service monitoring and restart
- **💾 Persistent Storage**: Data survives container restarts
- **🔐 Security**: Built-in authentication and network isolation

---

## 📦 Prerequisites

Before you begin, ensure you have:

- **Docker**: Version 20.10 or higher
- **Docker Compose**: Version 2.0 or higher
- **System Resources**:
  - Minimum: 4GB RAM, 2 CPU cores, 20GB disk
  - Recommended: 8GB RAM, 4 CPU cores, 50GB disk
- **Operating System**: Linux, macOS, or Windows with WSL2
- **Network Ports Available**: 3000, 8080, 9090, 9091, 9093, 9100, 9115

### Check Prerequisites

```bash
# Check Docker version
docker --version
# Should show: Docker version 20.10.0 or higher

# Check Docker Compose version
docker-compose --version
# Should show: Docker Compose version v2.0.0 or higher

# Check available disk space
df -h
# Should have at least 20GB free
```

---

## 🚀 Quick Start

Get up and running in 5 minutes:

### Step 1: Create Project Directory

```bash
# Create main directory
mkdir monitoring-stack
cd monitoring-stack

# Create subdirectories
mkdir -p prometheus/alerts prometheus/rules
mkdir -p grafana/provisioning/datasources grafana/provisioning/dashboards grafana/dashboards
mkdir -p alertmanager
mkdir -p blackbox
```

### Step 2: Create Configuration Files

Create the following files with the configurations from the artifact:

#### 📄 `docker-compose.yml`
```bash
nano docker-compose.yml
# Copy the docker-compose.yml content from the artifact
```

#### 📄 `prometheus/prometheus.yml`
```bash
nano prometheus/prometheus.yml
# Copy the prometheus configuration
```

#### 📄 `prometheus/alerts/node_alerts.yml`
```bash
nano prometheus/alerts/node_alerts.yml
# Copy the node alert rules
```

#### 📄 `prometheus/alerts/container_alerts.yml`
```bash
nano prometheus/alerts/container_alerts.yml
# Copy the container alert rules
```

#### 📄 `prometheus/alerts/prometheus_alerts.yml`
```bash
nano prometheus/alerts/prometheus_alerts.yml
# Copy the prometheus alert rules
```

#### 📄 `alertmanager/alertmanager.yml`
```bash
nano alertmanager/alertmanager.yml
# Copy the alertmanager configuration
```

#### 📄 `blackbox/blackbox.yml`
```bash
nano blackbox/blackbox.yml
# Copy the blackbox exporter configuration
```

#### 📄 `grafana/provisioning/datasources/datasource.yml`
```bash
nano grafana/provisioning/datasources/datasource.yml
# Copy the datasource configuration
```

#### 📄 `grafana/provisioning/dashboards/dashboard.yml`
```bash
nano grafana/provisioning/dashboards/dashboard.yml
# Copy the dashboard provisioning configuration
```

### Step 3: Create Environment File

```bash
nano .env
```

Add the following content:

```env
# Grafana Admin Credentials
GF_SECURITY_ADMIN_USER=admin
GF_SECURITY_ADMIN_PASSWORD=YourSecurePassword123!

# SMTP Configuration (for email alerts)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_FROM=alerts@yourdomain.com
SMTP_USER=alerts@yourdomain.com
SMTP_PASSWORD=your-app-password

# Slack Webhook (optional)
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK

# PagerDuty (optional)
PAGERDUTY_SERVICE_KEY=your-pagerduty-service-key

# Prometheus Configuration
PROMETHEUS_RETENTION_TIME=30d
PROMETHEUS_RETENTION_SIZE=10GB
```

### Step 4: Set Proper Permissions

```bash
# Create data directories
mkdir -p prometheus_data grafana_data alertmanager_data

# Set ownership for Prometheus (UID 65534)
sudo chown -R 65534:65534 prometheus_data
sudo chown -R 65534:65534 alertmanager_data

# Set ownership for Grafana (UID 472)
sudo chown -R 472:472 grafana_data

# Set read permissions for config files
chmod 644 prometheus/prometheus.yml
chmod 644 prometheus/alerts/*.yml
chmod 644 alertmanager/alertmanager.yml
chmod 644 blackbox/blackbox.yml
chmod 644 grafana/provisioning/datasources/datasource.yml
chmod 644 grafana/provisioning/dashboards/dashboard.yml
```

### Step 5: Validate Configuration

```bash
# Validate Prometheus config (requires promtool)
docker run --rm -v $(pwd)/prometheus:/etc/prometheus prom/prometheus:v2.47.0 \
  promtool check config /etc/prometheus/prometheus.yml

# Validate alert rules
docker run --rm -v $(pwd)/prometheus:/etc/prometheus prom/prometheus:v2.47.0 \
  promtool check rules /etc/prometheus/alerts/*.yml
```

### Step 6: Start the Stack

```bash
# Pull all images first (recommended)
docker-compose pull

# Start all services in detached mode
docker-compose up -d

# Watch logs (optional)
docker-compose logs -f
```

### Step 7: Verify Services

```bash
# Check all services are running
docker-compose ps

# Expected output: All services should show "Up" status
# NAME                  STATUS              PORTS
# prometheus            Up (healthy)        0.0.0.0:9090->9090/tcp
# grafana               Up (healthy)        0.0.0.0:3000->3000/tcp
# alertmanager          Up (healthy)        0.0.0.0:9093->9093/tcp
# node-exporter         Up                  0.0.0.0:9100->9100/tcp
# cadvisor              Up                  0.0.0.0:8080->8080/tcp
# blackbox-exporter     Up                  0.0.0.0:9115->9115/tcp
# pushgateway           Up                  0.0.0.0:9091->9091/tcp
```

### Step 8: Access the Services

Open your browser and navigate to:

1. **Grafana**: http://localhost:3000
   - Login with credentials from `.env` file
   - Default: `admin` / `YourSecurePassword123!`

2. **Prometheus**: http://localhost:9090
   - No authentication by default
   - Check Status → Targets to verify all exporters are up

3. **AlertManager**: http://localhost:9093
   - View active alerts and silences

---

## 🔧 Detailed Setup

### Directory Structure

After setup, your directory should look like:

```
monitoring-stack/
├── docker-compose.yml
├── .env
├── .env.example
├── README.md
│
├── prometheus/
│   ├── prometheus.yml
│   ├── alerts/
│   │   ├── node_alerts.yml
│   │   ├── container_alerts.yml
│   │   └── prometheus_alerts.yml
│   └── rules/
│       └── (recording rules - optional)
│
├── grafana/
│   ├── provisioning/
│   │   ├── datasources/
│   │   │   └── datasource.yml
│   │   └── dashboards/
│   │       └── dashboard.yml
│   └── dashboards/
│       └── (custom dashboards - optional)
│
├── alertmanager/
│   └── alertmanager.yml
│
├── blackbox/
│   └── blackbox.yml
│
└── data/ (created automatically)
    ├── prometheus_data/
    ├── grafana_data/
    └── alertmanager_data/
```

---

## ⚙️ Configuration

### 1. Configure Prometheus Scrape Targets

Edit `prometheus/prometheus.yml` to add your application metrics:

```yaml
scrape_configs:
  # Add your custom application
  - job_name: 'my-application'
    static_configs:
      - targets: ['app-host:8080']
        labels:
          environment: 'production'
          service: 'api'
          team: 'backend'
    
  # Monitor multiple instances
  - job_name: 'web-servers'
    static_configs:
      - targets:
          - 'web1:9100'
          - 'web2:9100'
          - 'web3:9100'
        labels:
          job: 'web'
```

After editing, reload Prometheus:

```bash
# Reload configuration without restart
curl -X POST http://localhost:9090/-/reload

# Or restart the service
docker-compose restart prometheus
```

### 2. Configure AlertManager Notifications

#### Slack Notifications

Edit `alertmanager/alertmanager.yml`:

```yaml
receivers:
  - name: 'slack-notifications'
    slack_configs:
      - api_url: 'https://hooks.slack.com/services/YOUR/WEBHOOK/URL'
        channel: '#alerts'
        title: '🚨 {{ .GroupLabels.alertname }}'
        text: |
          {{ range .Alerts }}
          *Alert:* {{ .Labels.alertname }}
          *Severity:* {{ .Labels.severity }}
          *Instance:* {{ .Labels.instance }}
          *Description:* {{ .Annotations.description }}
          {{ end }}
        send_resolved: true
```

#### Email Notifications

```yaml
receivers:
  - name: 'email-team'
    email_configs:
      - to: 'team@example.com'
        from: 'alertmanager@example.com'
        smarthost: 'smtp.gmail.com:587'
        auth_username: 'alertmanager@example.com'
        auth_password: 'your-app-password'
        headers:
          Subject: '{{ .GroupLabels.alertname }} - {{ .GroupLabels.cluster }}'
```

#### PagerDuty Integration

```yaml
receivers:
  - name: 'pagerduty-critical'
    pagerduty_configs:
      - service_key: 'YOUR_PAGERDUTY_INTEGRATION_KEY'
        description: '{{ .GroupLabels.alertname }}'
        severity: '{{ .GroupLabels.severity }}'
```

Reload AlertManager:

```bash
# Reload configuration
docker-compose restart alertmanager

# Verify configuration
docker-compose logs alertmanager
```

### 3. Add Custom Alert Rules

Create `prometheus/alerts/custom_alerts.yml`:

```yaml
groups:
  - name: application_alerts
    interval: 30s
    rules:
      # HTTP Error Rate Alert
      - alert: HighErrorRate
        expr: |
          rate(http_requests_total{status=~"5.."}[5m]) / 
          rate(http_requests_total[5m]) * 100 > 5
        for: 5m
        labels:
          severity: critical
          category: application
        annotations:
          summary: "High error rate on {{ $labels.instance }}"
          description: "Error rate is {{ $value }}% (threshold: 5%)"
      
      # Response Time Alert
      - alert: HighResponseTime
        expr: histogram_quantile(0.95, http_request_duration_seconds_bucket) > 1
        for: 5m
        labels:
          severity: warning
          category: performance
        annotations:
          summary: "High response time on {{ $labels.instance }}"
          description: "95th percentile response time is {{ $value }}s"
      
      # Database Connection Pool Alert
      - alert: DatabaseConnectionPoolExhausted
        expr: db_connection_pool_active / db_connection_pool_max * 100 > 90
        for: 2m
        labels:
          severity: critical
          category: database
        annotations:
          summary: "Database connection pool nearly exhausted"
          description: "{{ $value }}% of connections in use"
```

Validate and reload:

```bash
# Validate rules
docker run --rm -v $(pwd)/prometheus:/etc/prometheus prom/prometheus:v2.47.0 \
  promtool check rules /etc/prometheus/alerts/custom_alerts.yml

# Reload Prometheus
curl -X POST http://localhost:9090/-/reload
```

---

## 🔑 Access & Credentials

### Default Login Credentials

| Service | URL | Username | Password |
|---------|-----|----------|----------|
| **Grafana** | http://localhost:3000 | admin | (from .env file) |
| **Prometheus** | http://localhost:9090 | - | No auth |
| **AlertManager** | http://localhost:9093 | - | No auth |

### Change Grafana Password

**Method 1: Via UI**
1. Login to Grafana
2. Click profile icon → Change Password

**Method 2: Via CLI**
```bash
docker exec -it grafana grafana-cli admin reset-admin-password NewSecurePassword123!
```

**Method 3: Via Environment Variable**
Edit `.env` file:
```env
GF_SECURITY_ADMIN_PASSWORD=NewSecurePassword123!
```
Then restart:
```bash
docker-compose restart grafana
```

### Enable Prometheus Authentication (Optional)

Create `prometheus/web-config.yml`:

```yaml
basic_auth_users:
  admin: $2y$10$hashpasswordhere
```

Generate password hash:
```bash
docker run --rm httpd:2.4-alpine htpasswd -nbBC 10 admin YourPassword
```

Update `docker-compose.yml`:
```yaml
prometheus:
  command:
    - '--web.config.file=/etc/prometheus/web-config.yml'
  volumes:
    - ./prometheus/web-config.yml:/etc/prometheus/web-config.yml:ro
```

---

## 📊 Dashboards

### Import Pre-built Dashboards

1. **Login to Grafana** (http://localhost:3000)

2. **Navigate**: Dashboards → Import (+ icon → Import)

3. **Import by ID**:

   | ID | Dashboard Name | Description |
   |----|---------------|-------------|
   | **1860** | Node Exporter Full | Complete system metrics |
   | **893** | Docker & System Monitoring | Container insights |
   | **3662** | Prometheus 2.0 Overview | Prometheus stats |
   | **11074** | Node Exporter for Prometheus | Detailed node metrics |
   | **179** | Prometheus Stats | Internal metrics |
   | **11713** | Blackbox Exporter | Endpoint monitoring |

4. **Steps**:
   - Enter dashboard ID
   - Click "Load"
   - Select "Prometheus" as data source
   - Click "Import"

### Create Custom Dashboard

**Example: Application Metrics Dashboard**

1. Go to Dashboards → New → New Dashboard
2. Add Panel → Add a new panel
3. Enter PromQL query:

```promql
# Request Rate
rate(http_requests_total[5m])

# Error Rate
rate(http_requests_total{status=~"5.."}[5m])

# Response Time (95th percentile)
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# Active Connections
http_active_connections

# Memory Usage
process_resident_memory_bytes / 1024 / 1024
```

4. Configure visualization:
   - Select graph type (Time series, Gauge, Bar chart)
   - Set thresholds and colors
   - Add title and description

5. Click "Apply" → "Save dashboard"

### Dashboard Best Practices

- **Group by Service**: Create separate dashboards per service
- **Use Variables**: Add dropdown filters for dynamic queries
- **Set Refresh Rate**: Configure auto-refresh (5s, 10s, 30s)
- **Add Annotations**: Mark deployments and incidents
- **Use Templates**: Create reusable dashboard templates

---

## 🚨 Alerting

### View Active Alerts

**Prometheus UI**:
```
http://localhost:9090/alerts
```

**AlertManager UI**:
```
http://localhost:9093/#/alerts
```

**Grafana Alerting**:
```
Grafana → Alerting → Alert rules
```

### Test Alerts

#### Trigger CPU Alert Manually

```bash
# Stress test to trigger high CPU alert
docker run --rm -it progrium/stress --cpu 8 --timeout 300s
```

Wait 5 minutes for the alert to fire.

#### Test AlertManager Notification

```bash
# Send test alert
curl -X POST http://localhost:9093/api/v2/alerts \
  -H 'Content-Type: application/json' \
  -d '[
    {
      "labels": {
        "alertname": "TestAlert",
        "severity": "warning",
        "instance": "test-instance"
      },
      "annotations": {
        "summary": "This is a test alert",
        "description": "Testing AlertManager notification channels"
      },
      "startsAt": "2025-10-31T10:00:00.000Z",
      "endsAt": "2025-10-31T11:00:00.000Z"
    }
  ]'
```

### Silence Alerts

**Via AlertManager UI**:
1. Go to http://localhost:9093
2. Click "Silence" button on an alert
3. Set duration and comment
4. Click "Create"

**Via API**:
```bash
curl -X POST http://localhost:9093/api/v2/silences \
  -H 'Content-Type: application/json' \
  -d '{
    "matchers": [
      {
        "name": "alertname",
        "value": "HostHighCpuLoad",
        "isRegex": false
      }
    ],
    "startsAt": "2025-10-31T10:00:00.000Z",
    "endsAt": "2025-10-31T12:00:00.000Z",
    "createdBy": "admin",
    "comment": "Planned maintenance"
  }'
```

### Alert Routing Examples

**Route by Severity**:
```yaml
routes:
  - match:
      severity: critical
    receiver: pagerduty-oncall
    continue: true
  
  - match:
      severity: warning
    receiver: slack-team
```

**Route by Team**:
```yaml
routes:
  - match:
      team: backend
    receiver: backend-team-slack
  
  - match:
      team: frontend
    receiver: frontend-team-email
```

---

## 🔍 Troubleshooting

### Common Issues

#### ❌ Services Not Starting

**Check logs**:
```bash
docker-compose logs prometheus
docker-compose logs grafana
docker-compose logs alertmanager
```

**Check configuration**:
```bash
# Validate Prometheus config
docker exec prometheus promtool check config /etc/prometheus/prometheus.yml

# Validate alert rules
docker exec prometheus promtool check rules /etc/prometheus/alerts/*.yml
```

**Check permissions**:
```bash
ls -la prometheus_data grafana_data alertmanager_data
```

Fix permissions if needed:
```bash
sudo chown -R 65534:65534 prometheus_data alertmanager_data
sudo chown -R 472:472 grafana_data
```

#### ❌ Prometheus Not Scraping Targets

**Check targets status**:
```
http://localhost:9090/targets
```

**Common causes**:
1. Wrong target address in `prometheus.yml`
2. Target service not running
3. Firewall blocking connection
4. Network issues

**Debug**:
```bash
# Test connectivity from Prometheus container
docker exec prometheus wget -O- http://node-exporter:9100/metrics

# Check Prometheus logs
docker-compose logs prometheus | grep -i error
```

#### ❌ Grafana Can't Connect to Prometheus

**Test connection manually**:
```bash
# From Grafana container
docker exec grafana curl http://prometheus:9090/api/v1/query?query=up

# Expected: JSON response with metrics
```

**Check datasource configuration**:
```bash
# Verify datasource in Grafana
curl -u admin:password http://localhost:3000/api/datasources
```

**Fix**:
1. Go to Grafana → Configuration → Data Sources
2. Click "Prometheus"
3. Update URL to `http://prometheus:9090`
4. Click "Save & Test"

#### ❌ Alerts Not Firing

**Check alert rules**:
```
http://localhost:9090/alerts
```

**Common causes**:
1. Wrong PromQL expression
2. `for` duration not met
3. Alert rule file not loaded
4. Metrics not available

**Debug**:
```bash
# Test PromQL query
curl 'http://localhost:9090/api/v1/query?query=up==0'

# Check alert manager
curl http://localhost:9093/api/v2/alerts

# View rule evaluation
docker-compose logs prometheus | grep -i "evaluating rule"
```

#### ❌ AlertManager Notifications Not Sending

**Check AlertManager status**:
```
http://localhost:9093/#/status
```

**Test notification manually** (Slack example):
```bash
curl -X POST 'YOUR_SLACK_WEBHOOK_URL' \
  -H 'Content-Type: application/json' \
  -d '{"text": "Test notification from AlertManager"}'
```

**Check logs**:
```bash
docker-compose logs alertmanager | grep -i error
```

#### ❌ High Memory Usage

**Check resource usage**:
```bash
docker stats
```

**Reduce Prometheus memory**:
Edit `docker-compose.yml`:
```yaml
prometheus:
  command:
    - '--storage.tsdb.retention.time=15d'  # Reduce retention
    - '--storage.tsdb.retention.size=5GB'  # Limit size
```

**Optimize queries**:
- Reduce scrape frequency
- Use recording rules for complex queries
- Limit cardinality (fewer unique label combinations)

#### ❌ Disk Space Issues

**Check disk usage**:
```bash
du -sh prometheus_data grafana_data alertmanager_data
```

**Clean old data**:
```bash
# Stop services
docker-compose down

# Remove old Prometheus data (keeps last 7 days)
find prometheus_data -type d -mtime +7 -exec rm -rf {} +

# Start services
docker-compose up -d
```

### Debug Commands

```bash
# View all container logs
docker-compose logs -f --tail=100

# Check specific service
docker-compose logs -f prometheus

# Execute command in container
docker exec -it prometheus /bin/sh

# Check container health
docker inspect prometheus | grep -A 10 Health

# View container processes
docker-compose top

# Restart single service
docker-compose restart prometheus

# Rebuild and restart
docker-compose up -d --build
```

---

## 🛠️ Maintenance

### Daily Tasks

```bash
# Check service health
docker-compose ps

# View recent alerts
curl http://localhost:9090/api/v1/alerts | jq

# Check disk usage
df -h
du -sh *_data
```

### Weekly Tasks

```bash
# Update Docker images
docker-compose pull
docker-compose up -d

# Backup data
./backup.sh

# Review and update alert rules
vim prometheus/alerts/custom_alerts.yml

# Check for security updates
docker-compose images
```

### Backup Script

Create `backup.sh`:

```bash
#!/bin/bash
set -e

BACKUP_DIR="/backup/monitoring/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Starting backup to $BACKUP_DIR"

# Backup Prometheus data
echo "Backing up Prometheus..."
docker run --rm \
  -v monitoring-stack_prometheus_data:/data:ro \
  -v "$BACKUP_DIR":/backup \
  alpine tar czf /backup/prometheus.tar.gz /data

# Backup Grafana data
echo "Backing up Grafana..."
docker run --rm \
  -v monitoring-stack_grafana_data:/data:ro \
  -v "$BACKUP_DIR":/backup \
  alpine tar czf /backup/grafana.tar.gz /data

# Backup AlertManager data
echo "Backing up AlertManager..."
docker run --rm \
  -v monitoring-stack_alertmanager_data:/data:ro \
  -v "$BACKUP_DIR":/backup \
  alpine tar czf /backup/alertmanager.tar.gz /data

# Backup configurations
echo "Backing up configurations..."
tar czf "$BACKUP_DIR/configs.tar.gz" \
  prometheus/ grafana/ alertmanager/ blackbox/ \
  docker-compose.yml .env

echo "Backup completed: $BACKUP_DIR"
ls -lh "$BACKUP_DIR"
```

Make executable and run:
```bash
chmod +x backup.sh
./backup.sh
```

### Restore Script

Create `restore.sh`:

```bash
#!/bin/bash
set -e

BACKUP_DIR=$1

if [ -z "$BACKUP_DIR" ]; then
  echo "Usage: ./restore.sh /path/to/backup"
  exit 1
fi

echo "Restoring from $BACKUP_DIR"

# Stop services
docker-compose down

# Restore Prometheus
echo "Restoring Prometheus..."
docker run --rm \
  -v monitoring-stack_prometheus_data:/data \
  -v "$BACKUP_DIR":/backup \
  alpine sh -c "cd / && tar xzf /backup/prometheus.tar.gz"

# Restore Grafana
echo "Restoring Grafana..."
docker run --rm \
  -v monitoring-stack_grafana_data:/data \
  -v "$BACKUP_DIR":/backup \
  alpine sh -c "cd / && tar xzf /backup/grafana.tar.gz"

# Restore AlertManager
echo "Restoring AlertManager..."
docker run --rm \
  -v monitoring-stack_alertmanager_data:/data \
  -v "$BACKUP_DIR":/backup \
  alpine sh -c "cd / && tar xzf /backup/alertmanager.tar.gz"

# Restore configurations
echo "Restoring configurations..."
tar xzf "$BACKUP_DIR/configs.tar.gz"

# Start services
docker-compose up -d

echo "Restore completed!"
```

### Update Stack

```bash
# Pull latest images
docker-compose pull

# Recreate containers with new images
docker-compose up -d

# Verify all services are healthy
docker-compose ps
```

### Cleanup

```bash
# Remove stopped containers
docker-compose down

# Remove unused images
docker image prune -a

# Remove unused volumes (CAUTION: This deletes data!)
docker volume prune

# Clean everything (CAUTION!)
docker-compose down -v
rm -rf *_data
```

---

## 📚 Additional Resources

- **Prometheus Documentation**: https://prometheus.io/docs/
- **Grafana Documentation**: https://grafana.com/docs/
- **PromQL Guide**: https://prometheus.io/docs/prometheus/latest/querying/basics/
- **AlertManager**: https://prometheus.io/docs/alerting/latest/alertmanager/
- **Best Practices**: https://prometheus.io/docs/practices/naming/
- **Community Dashboards**: https://grafana.com/grafana/dashboards/

---

## 🆘 Getting Help

If you encounter issues:

1. **Check the logs**: `docker-compose logs [service-name]`
2. **Verify configuration**: Use `promtool` to validate configs
3. **Test connectivity**: Ensure services can communicate
4. **Review documentation**: Check official docs for your specific issue
5. **Community support**: 
   - [Prometheus Community](https://prometheus.io/community/)
   - [Grafana Community](https://community.grafana.com/)
   - [CNCF Slack](https://slack.cncf.io/)

---

## 📄 License

This project is licensed under the MIT License.

---

## 🎯 Next Steps

After successful setup:

1. ✅ Configure notification channels (Slack, Email, PagerDuty)
2. ✅ Import community dashboards from Grafana.com
3. ✅ Add your application metrics endpoints
4. ✅ Customize alert rules for your use case
5. ✅ Set up regular backups
6. ✅ Implement TLS/HTTPS for production
7. ✅ Configure user authentication and RBAC
8. ✅ Integrate with your CI/CD pipeline

---

**Happy Monitoring! 🚀📊**