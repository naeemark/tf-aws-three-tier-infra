#!/bin/bash
  
mkdir /home/ec2-user/site-content
echo "<body><center><h1>Hello from BastionHost @ <i style=color:red;>`hostname -f`</i></h1></center></body>" > /home/ec2-user/site-content/index.html
docker run -d -p 80:80 --name nginx -v /home/ec2-user/site-content:/usr/share/nginx/html nginx:latest

# docker run -d -p 8080:80 --name whoami traefik/whoami
