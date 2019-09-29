#!/bin/bash
cd /home/ec2-user/ruby-docker-app

sudo bash -c "echo 'NODE_HOST=$(curl http://169.254.169.254/latest/meta-data/local-hostname)' >> .env"
export $(cat .env | xargs)

sudo docker-compose down

sudo git pull
sudo git stash #gemfile.lock error if don't git stash
sudo git pull

sudo docker-compose run -p 5000:3000 web bash -c "bundle install && rake db:create && rake db:migrate && rake assets:precompile"
sudo aws s3 cp public/assets/ s3://$S3_BUCKET/assets/ --recursive --include "*" --acl "public-read"
sudo docker-compose down
sudo docker-compose up -d
