#!/bin/bash
#Use with user root
wget https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-amd64.tar.gz
tar xvf node_exporter-1.9.1.linux-amd64.tar.gz
sudo cp node_exporter-1.9.1.linux-amd64/node_exporter /usr/local/bin
sudo useradd -rs /bin/false node_exporter
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
rm -rf node_exporter-1.9.1.linux-amd64.tar.gz node_exporter-1.9.1.linux-amd64
sudo mkdir /var/lib/node_exporter
cat  > /etc/systemd/system/node_exporter.service <<"EOF"
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter --collector.processes --collector.systemd --collector.network_route --collector.textfile.directory=/var/lib/node_exporter

[Install]
WantedBy=multi-user.target


EOF

sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
sudo systemctl status node_exporter.service 
cd /usr/local/bin/
wget https://raw.githubusercontent.com/prometheus-community/node-exporter-textfile-collector-scripts/master/apt.sh
sudo chmod +x apt.sh
cat > /etc/cron.d/prom-apt <<"EOF"
0 0 * * 0 root /usr/local/bin/apt.sh >/var/lib/node_exporter/apt.prom.new && mv /var/lib/node_exporter/apt.prom.new /var/lib/node_exporter/apt.prom

EOF
sudo firewall-cmd --add-port=9100/tcp --permanent
sudo systemctl restart firewalld
echo "Successful Installation!"
