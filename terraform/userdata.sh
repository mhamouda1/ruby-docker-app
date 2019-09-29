#!/bin/bash
cd /home/ec2-user/ruby-docker-app

sudo bash -c "echo 'NODE_HOST=$(curl http://169.254.169.254/latest/meta-data/local-hostname)' >> .env"
export $(cat .env | xargs)

sudo docker-compose down

sudo git pull
sudo git stash #gemfile.lock error if don't git stash
sudo git pull

sudo docker-compose run -p 5000:3000 web rake db:create
sudo docker-compose run -p 5000:3000 web rake db:migrate
sudo docker-compose run -p 5000:3000 web rake assets:precompile
# aws s3 cp public/assets/ s3://mys3-bucket-1d175bfa0725cdc7/assets/ --recursive --include "*"
aws s3 cp public/assets/ s3://$S3_BUCKET/assets/ --recursive --include "*"
sudo docker-compose down
sudo docker-compose up -d
