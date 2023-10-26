#!/bin/bash

#Install python, git, ssh, nginx
sudo apt update
sudo apt -y install python3
sudo apt -y install python3-venv
sudo apt -y install git
sudo apt -y install openssh-server
sudo apt -y install nginx

#Add nginx config user to this user
sudo gpasswd -a www-data ubuntu

#Set directory of default EC2 user
user_dir="/home/ubuntu"

#Allow groups like www-data to read and execute into user_dir
chmod 750 "$user_dir"

#Enable/start ssh
sudo systemctl enable --now ssh

#Enable/start nginx
sudo systemctl enable --now nginx

#Clone this repo
git clone https://github.com/shyguyCreate/ec2-flask "$user_dir/ec2-flask"

#Create and activate virtual environment
python3 -m venv "$user_dir/ec2-flask/.venv"
source "$user_dir/ec2-flask/.venv/bin/activate"

#Install program dependencies
pip install -r "$user_dir/ec2-flask/requirements.txt"

#Nginx configuration variables
default_conf_dir="/etc/nginx/sites-enabled"
default_html_dir="/var/www/html"
repo_html_dir="$user_dir/ec2-flask/html"

#Remove default nginx config
sudo rm -f "$default_conf_dir"/*

#Copy index.html and image to default location
sudo cp "$repo_html_dir"/* "$default_html_dir"

#Set nginx config
sudo cp "$user_dir/ec2-flask/ec2-flask.conf" /etc/nginx/sites-available
sudo sed -i "s,\$repo_html_dir,$repo_html_dir,g" /etc/nginx/sites-available/ec2-flask.conf
sudo sed -i "s,\$default_html_dir,$default_html_dir,g" /etc/nginx/sites-available/ec2-flask.conf
sudo ln -sf /etc/nginx/sites-available/ec2-flask.conf "$default_conf_dir"

#Reload nginx
sudo systemctl restart nginx
