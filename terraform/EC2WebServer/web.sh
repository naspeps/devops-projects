#!/bin/bash
sudo apt update
sudo apt upgrade -y
apt install apache2 -y --fix-missing
systemctl start apache2
systemctl enable apache2

# PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
PUBLIC_IP=$(curl -s https://api.ipify.org)

mkdir -p /var/www/html
echo "I am Nasser, My IP is: $PUBLIC_IP" > /var/www/html/index.html

systemctl restart apache2