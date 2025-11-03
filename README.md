# 🚀 Production Monitoring Stack

Enterprise-grade Prometheus & Grafana monitoring solution with complete observability, alerting, and visualization.

## ⚡ Quick Start

```bash
# Clone and setup
git clone <your-repo>
cd monitoring-stack

# Set permissions
mkdir -p {prometheus,grafana,alertmanager}_data
sudo chown -R 65534:65534 {prometheus,alertmanager}_data
sudo chown -R 472:472 grafana_data

# Configure
cp .env.example .env
# Edit .env with your credentials

# Deploy
docker-compose up -d

# Verify
docker-compose ps
```

## 🔗 Access Services

| Service | URL | Default Credentials |
|---------|-----|---------------------|
| **Grafana** | http://localhost:3000 | admin / admin_change_me |
| **Prometheus** | http://localhost:9090 | - |
| **AlertManager** | http://localhost:9093 | - |

## 📦 What's Inside

- ✅ **Prometheus** - Metrics collection & storage
- ✅ **Grafana** - Visualization dashboards
- ✅ **AlertManager** - Alert routing (Slack, Email, PagerDuty)
- ✅ **Node Exporter** - System metrics
- ✅ **cAdvisor** - Container metrics
- ✅ **Blackbox Exporter** - Endpoint monitoring
- ✅ **Pushgateway** - Batch job metrics

## 🎯 Features

- 🔔 **15+ Pre-configured Alerts** - CPU, Memory, Disk, Container health
- 📊 **Ready-to-use Dashboards** - Import community dashboards
- 🔐 **Security Hardened** - User isolation, configurable authentication
- 💾 **Persistent Storage** - Data survives restarts
- 🏥 **Health Checks** - Auto-restart on failures
- 📈 **Production Ready** - 30-day retention, optimized performance

## 📋 Prerequisites

- Docker 20.10+
- Docker Compose 2.0+
- 4GB RAM minimum
- 20GB disk space

## ⚙️ Configuration

### Add Monitoring Target

Edit `prometheus/prometheus.yml`:
```yaml
scrape_configs:
  - job_name: 'my-app'
    static_configs:
      - targets: ['app:8080']
```

### Configure Alerts

Edit `alertmanager/alertmanager.yml` for Slack/Email/PagerDuty:
```yaml
receivers:
  - name: 'slack'
    slack_configs:
      - api_url: 'YOUR_WEBHOOK'
        channel: '#alerts'
```

### Import Grafana Dashboards

Popular dashboard IDs:
- **1860** - Node Exporter Full
- **893** - Docker & System Monitoring
- **11074** - Node Exporter for Prometheus

## 🔧 Common Commands

```bash
# View logs
docker-compose logs -f prometheus

# Restart services
docker-compose restart

# Check health
curl http://localhost:9090/-/healthy

# Reload Prometheus config
curl -X POST http://localhost:9090/-/reload

# Backup data
docker run --rm -v monitoring-stack_prometheus_data:/data \
  -v ./backup:/backup alpine tar czf /backup/prometheus.tar.gz /data
```

## 🛡️ Security

**⚠️ Before Production:**
1. Change default Grafana password
2. Enable HTTPS with reverse proxy
3. Configure firewall rules
4. Set up authentication for all services
5. Review and update `.env` file

## 📊 Pre-configured Alerts

- **System**: Low memory, High CPU, Disk full, Swap usage
- **Container**: Container killed, High resource usage
- **Prometheus**: Target down, Config reload failed
- **Endpoint**: HTTP service unavailable

## 🔍 Troubleshooting

**Services not starting?**
```bash
docker-compose logs
docker-compose ps
```

**Grafana can't connect to Prometheus?**
- Check datasource: http://localhost:3000/datasources
- Test connection: `curl http://prometheus:9090/api/v1/query?query=up`

**Alerts not firing?**
```bash
# Check alert rules
docker exec prometheus promtool check rules /etc/prometheus/alerts/*.yml

# View active alerts
curl http://localhost:9090/api/v1/alerts
```

## 📚 Documentation

- Full documentation in `DOCUMENTATION.md`
- [Prometheus Docs](https://prometheus.io/docs)
- [Grafana Docs](https://grafana.com/docs)
- [PromQL Guide](https://prometheus.io/docs/prometheus/latest/querying/basics/)

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/new-feature`
3. Commit changes: `git commit -am 'Add feature'`
4. Push to branch: `git push origin feature/new-feature`
5. Submit pull request

## 📝 License

MIT License - feel free to use in your projects!

## 🆘 Support

- 📖 Check documentation first
- 🐛 Open an issue for bugs
- 💡 Discussions for questions
- ⭐ Star if you find it useful!

---

**Made with ❤️ for DevOps Engineers**