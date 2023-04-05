#!/bin/bash

# Create mount volume for logs
  sudo su - root
  mkfs.ext4 /dev/sdf
  mount -t ext4 /dev/sdf /var/log

# Install & Start nginx server
  yum search nginx 
  amazon-linux-extras install nginx1 -y
  systemctl start nginx
  systemctl enable nginx
  
# Print the hostname which includes instance details on nginx homepage  
  echo "<body><h1>Hello from BastionHost @ <i style=color:red;>`hostname -f`</i></h1></body>" > /usr/share/nginx/html/index.html

  # Install MySQL Client
  sudo yum install mysql -y

  # Install Docker and Docker-Compose
  sudo yum install docker -y
  sudo usermod -a -G docker ec2-user
  id ec2-user
  sudo yum install python3-pip 
  sudo pip3 install docker-compose

  sudo systemctl enable docker.service
  sudo systemctl start docker.service