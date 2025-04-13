#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo yum install -y postgresql
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h1>Welcome to ACS730 Final Project! My private IP is $myip <font color="turquoise"></font></h1><br>Built by Terraform!"  >  /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl start postgresql
sudo systemctl enable postgresql

