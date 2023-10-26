#!/bin/bash

#Install python, git, ssh, nginx
sudo dnf check-update --releasever=latest
sudo dnf install -y python3
sudo dnf install -y git
sudo dnf install -y openssh
sudo dnf install -y nginx

#Add nginx config user to this user
sudo gpasswd -a nginx ec2-user

#Set directory of default EC2 user
user_dir="/home/ec2-user"

#Allow groups like nginx to read and execute into user_dir
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
default_conf_dir="/etc/nginx/conf.d"
default_html_dir="/usr/share/nginx/html"
repo_html_dir="$user_dir/ec2-flask/html"

#Remove default nginx config
sudo rm -f "$default_conf_dir"/*

#Copy index.html and image to default location
sudo cp -r "$repo_html_dir"/* "$default_html_dir"

#Set nginx config
sudo cp "$user_dir/ec2-flask/ec2-flask.conf" "$default_conf_dir"
sudo sed -i "s,\$repo_html_dir,$repo_html_dir,g" "$default_conf_dir/ec2-flask.conf"
sudo sed -i "s,\$default_html_dir,$default_html_dir,g" "$default_conf_dir/ec2-flask.conf"

#Reload nginx
sudo systemctl restart nginx
