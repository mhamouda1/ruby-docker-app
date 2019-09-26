#!/bin/bash
export HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/local-hostname)

cd /home/ec2-user/ruby-docker-app
sudo docker-compose down
sudo git pull
sudo docker-compose up -d
sleep 7
sudo docker-compose run web bundle update
sudo docker-compose run web rake db:create
sudo docker-compose run web rake db:migrate
sudo docker-compose down
sudo docker-compose up -d
