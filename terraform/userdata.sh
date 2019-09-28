#!/bin/bash
cd /home/ec2-user/ruby-docker-app
sudo bash -c "echo 'NODE_HOST=$(curl http://169.254.169.254/latest/meta-data/local-hostname)' >> .env"

sudo docker-compose down

sudo git pull
sudo git stash #gemfile.lock error if don't git stash
sudo git pull

#sudo docker-compose build
#sudo docker-compose run -d web
#sudo docker-compose run web bundle update
sudo docker-compose run -p 5000:3000 web rake db:create
sudo docker-compose run -p 5000:3000 web rake db:migrate
sudo docker-compose run -p 5000:3000 web rake assets:precompile
sudo docker-compose down
sudo docker-compose up -d
