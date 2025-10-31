# 🚀 Prometheus + Grafana Monitoring Stack

This project sets up a **complete monitoring and visualization stack** using **Prometheus** and **Grafana**.  
Prometheus collects and stores metrics, while Grafana visualizes them through customizable dashboards.

---

## 📦 Project Structure

```

monitoring-stack/
├── docker-compose.yml (main orchestration)
├── prometheus/
│   ├── prometheus.yml (scrape configs)
│   ├── alerts/ (alert rules)
│   └── rules/ (recording rules)
├── grafana/
│   ├── provisioning/ (auto-config)
│   └── dashboards/
├── alertmanager/
│   └── alertmanager.yml (notification routing)
└── blackbox/
    └── blackbox.yml (probe configs)

````


## ⚙️ Prerequisites

Make sure you have the following installed:
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/)
- (Optional) [curl](https://curl.se/) for testing endpoints


---

### 🔹 Sample Dashboard (optional)

Save a dashboard JSON in `grafana/dashboards/system-metrics.json`
You can export it from Grafana UI after creating your dashboard.

---

## ▶️ How to Run

1. **Clone this repository**

   ```bash
   git clone https://github.com/<your-username>/prometheus-grafana.git
   cd prometheus-grafana
   ```

2. **Start the monitoring stack**

   ```bash
   docker compose up -d
   ```

3. **Access the services**

   * Prometheus: [http://localhost:9090](http://localhost:9090)
   * Grafana: [http://localhost:3000](http://localhost:3000)
     **Default credentials:** `admin / admin`

4. **Add Prometheus as a data source** (if not auto-provisioned)

   * Go to **Grafana → Connections → Data Sources**
   * Choose **Prometheus**
   * URL: `http://prometheus:9090`
   * Click **Save & Test**

5. **Import Dashboards**

   * Go to **Grafana → Dashboards → Import**
   * Upload `grafana/dashboards/system-metrics.json` or use [Grafana.com dashboards](https://grafana.com/grafana/dashboards/).

---

## 🧠 Optional: Manual Setup (Without Docker)

1. **Install Prometheus**

   ```bash
   wget https://github.com/prometheus/prometheus/releases/latest/download/prometheus-linux-amd64.tar.gz
   tar xvf prometheus-linux-amd64.tar.gz
   cd prometheus-*
   ./prometheus --config.file=prometheus.yml
   ```

2. **Install Grafana**

   ```bash
   sudo apt-get install -y apt-transport-https software-properties-common
   sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
   sudo apt-get update
   sudo apt-get install grafana -y
   sudo systemctl start grafana-server
   sudo systemctl enable grafana-server
   ```

3. **Install Node Exporter**

   ```bash
   wget https://github.com/prometheus/node_exporter/releases/latest/download/node_exporter-linux-amd64.tar.gz
   tar xvf node_exporter-linux-amd64.tar.gz
   cd node_exporter-*
   ./node_exporter
   ```

---

## 📊 Metrics and Dashboards

| Component     | Default Port | Description                    |
| ------------- | ------------ | ------------------------------ |
| Prometheus    | `9090`       | Metrics collection and storage |
| Node Exporter | `9100`       | System metrics exporter        |
| Grafana       | `3000`       | Visualization dashboard        |

---

## 🧹 Stop and Clean Up

To stop the stack:

```bash
docker compose down
```

To remove all data:

```bash
docker compose down -v
```

---

## 🛠️ Troubleshooting

* **Prometheus not connecting to Node Exporter:**
  Check that the target `node-exporter:9100` is reachable in the Docker network.

* **Grafana shows “Bad Gateway”:**
  Ensure Prometheus is running and Grafana’s datasource URL is correct.

---

## 🌐 Useful Links

* [Prometheus Docs](https://prometheus.io/docs/introduction/overview/)
* [Grafana Docs](https://grafana.com/docs/)
* [Node Exporter Docs](https://github.com/prometheus/node_exporter)

---

## 🧑‍💻 Author

**Hitesh Mondal**
Full Stack Developer | DevOps & Cloud Enthusiast
📍 Barrackpore, West Bengal
🔗 GitHub: [@HiteshMondal](https://github.com/HiteshMondal)

---

## 🪪 License

This project is licensed under the **MIT License** — feel free to use and modify it.

