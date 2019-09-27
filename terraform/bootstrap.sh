#!/bin/bash
sudo bash -c 'echo export HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/local-hostname) >> /root/.bash_profile'
source /root/.bash_profile
source /root/.bashrc

whoami > whoami.txt
env > env.txt

cd /home/ec2-user/ruby-docker-app
sudo docker-compose down
sudo docker-compose kill

sudo git pull
sudo git stash #gemfile.lock error if don't git stash
sudo git pull

sudo docker-compose build
sudo docker-compose up -d
sleep 7
sudo docker-compose run web bundle update
sudo docker-compose run web rake db:create
sudo docker-compose run web rake db:migrate
sudo docker-compose down
sudo docker-compose up -d

source /root/.bash_profile
source /root/.bashrc
whoami > whoami2.txt
env > env2.txt
