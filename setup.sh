#!/bin/bash

# Prometheus and Grafana Setup Script
echo "🚀 Setting up Prometheus and Grafana monitoring stack..."

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p prometheus alertmanager grafana/{provisioning/{datasources,dashboards},dashboards}

# Check if docker-compose.yml exists
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Error: docker-compose.yml not found!"
    echo "Please ensure all configuration files are in place."
    exit 1
fi

# Create prometheus.yml if it doesn't exist
if [ ! -f "prometheus/prometheus.yml" ]; then
    echo "⚠️  Warning: prometheus/prometheus.yml not found!"
    echo "Please create the Prometheus configuration file."
fi

# Create alert_rules.yml if it doesn't exist
if [ ! -f "prometheus/alert_rules.yml" ]; then
    echo "⚠️  Warning: prometheus/alert_rules.yml not found!"
    echo "Please create the alert rules file."
fi

# Create alertmanager.yml if it doesn't exist
if [ ! -f "alertmanager/alertmanager.yml" ]; then
    echo "⚠️  Warning: alertmanager/alertmanager.yml not found!"
    echo "Please create the Alertmanager configuration file."
fi

# Create Grafana provisioning files if they don't exist
if [ ! -f "grafana/provisioning/datasources/datasource.yml" ]; then
    echo "⚠️  Warning: Grafana datasource configuration not found!"
    echo "Please create grafana/provisioning/datasources/datasource.yml"
fi

if [ ! -f "grafana/provisioning/dashboards/dashboard.yml" ]; then
    echo "⚠️  Warning: Grafana dashboard provider not found!"
    echo "Please create grafana/provisioning/dashboards/dashboard.yml"
fi

# Set proper permissions
echo "🔐 Setting permissions..."
chmod -R 755 prometheus alertmanager grafana

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running!"
    echo "Please start Docker and try again."
    exit 1
fi

# Pull latest images
echo "📥 Pulling Docker images..."
docker-compose pull

# Start the monitoring stack
echo "🎬 Starting monitoring stack..."
docker-compose up -d

# Wait for services to be healthy
echo "⏳ Waiting for services to start..."
sleep 10

# Check service status
echo ""
echo "📊 Service Status:"
docker-compose ps

echo ""
echo "✅ Setup complete!"
echo ""
echo "🌐 Access URLs:"
echo "   Prometheus:    http://localhost:9090"
echo "   Grafana:       http://localhost:3000 (admin/admin123)"
echo "   Alertmanager:  http://localhost:9093"
echo "   Node Exporter: http://localhost:9100/metrics"
echo "   cAdvisor:      http://localhost:8080"
echo ""
echo "📚 Next Steps:"
echo "   1. Login to Grafana at http://localhost:3000"
echo "   2. Import dashboards (IDs: 1860 for Node Exporter, 893 for Docker)"
echo "   3. Configure Alertmanager email settings in alertmanager/alertmanager.yml"
echo "   4. Customize alert rules in prometheus/alert_rules.yml"
echo ""
echo "🛠️  Useful Commands:"
echo "   View logs:        docker-compose logs -f"
echo "   Stop services:    docker-compose down"
echo "   Restart services: docker-compose restart"
echo "   Remove volumes:   docker-compose down -v"
echo ""