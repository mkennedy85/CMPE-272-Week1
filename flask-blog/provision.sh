#!/bin/bash

# VM Provisioning Script for Flask Blog App
echo "Starting VM provisioning for Flask Blog..."

# Update system packages
echo "Updating system packages..."
sudo apt-get update -y

# Install Python 3 and pip
echo "Installing Python 3 and development tools..."
sudo apt-get install -y python3 python3-pip python3-venv python3-dev

# Install system monitoring tools for performance analysis
echo "Installing system monitoring tools..."
sudo apt-get install -y htop iotop sysstat curl wget

# Install Flask and dependencies
echo "Installing Python dependencies..."
cd /home/vagrant/flask-blog

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install Flask
pip install flask

# Initialize the database
echo "Initializing database..."
python3 init_db.py

# Set up log directory
mkdir -p logs

# Create systemd service for Flask app (optional)
sudo tee /etc/systemd/system/flask-blog.service > /dev/null <<EOF
[Unit]
Description=Flask Blog Application
After=network.target

[Service]
Type=simple
User=vagrant
WorkingDirectory=/home/vagrant/flask-blog
Environment=PATH=/home/vagrant/flask-blog/venv/bin
ExecStart=/home/vagrant/flask-blog/venv/bin/python app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable the service but don't start it yet (will be started by Vagrant)
sudo systemctl daemon-reload
sudo systemctl enable flask-blog

# Set permissions
chown -R vagrant:vagrant /home/vagrant/flask-blog
chmod +x /home/vagrant/flask-blog/build.sh

echo "VM provisioning completed successfully!"
echo "Flask blog app is ready to run on port 5001"

# Display system info for performance baseline
echo "=== VM System Information ==="
echo "CPU Info:"
lscpu | grep -E "Model name|CPU\(s\)|Thread|Core"
echo ""
echo "Memory Info:"
free -h
echo ""
echo "Disk Info:"
df -h /
echo ""
echo "Network Info:"
ip addr show | grep -E "inet.*scope global"