#!/bin/bash

mkdir /home/ec2-user/site-content
echo "<body><center><h1>Hello from Backend @ <i style=color:red;>`hostname -f`</i></h1></center></body>" > /home/ec2-user/site-content/index.html
docker run -d -p 8000:80 --name nginx -v /home/ec2-user/site-content:/usr/share/nginx/html nginx:latest