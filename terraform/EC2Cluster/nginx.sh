#!/bin/bash
sudo apt update
sudo apt upgrade -y
apt install -y nginx


# PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
PUBLIC_IP=$(curl -s https://api.ipify.org)
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
INST_NUM=${instance_num}

mkdir -p /var/www/html
cat > /var/www/html/index.html << EOF
Instance Number: $INST_NUM
Instance ID: $INSTANCE_ID
IP Address: $PUBLIC_IP
EOF

systemctl restart nginx
systemctl enable nginx