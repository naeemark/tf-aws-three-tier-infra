#!/bin/bash

# Set password
echo 'ec2-user:pas$w0rd&6%0' | chpasswd

# Allow password authentication
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Restart the SSH service to apply changes
systemctl restart sshd

mkdir /home/ec2-user/site-content
echo "<body><center><h1>Hello from Backend @ <i style=color:red;>`hostname -f`</i></h1></center></body>" > /home/ec2-user/site-content/index.html
docker run -d -p 8000:80 --name nginx -v /home/ec2-user/site-content:/usr/share/nginx/html nginx:latest
# docker run -d -p 80:80 traefik/whoami:latest