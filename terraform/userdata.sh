#!/bin/bash
cd /home/ec2-user/ruby-docker-app

#export env variables
sudo bash -c "echo 'NODE_HOST=$(curl http://169.254.169.254/latest/meta-data/local-hostname)' >> .env"
export $(cat .env | xargs)

sudo docker-compose down

#TODO: add git commit hash and checkout that version
sudo rm Gemfile.lock #don't worry, it will be pulled on next line
sudo git pull

#run migrations, compile assets, and run server
sudo docker-compose run -p 5000:3000 web bash -c "bundle install && rake db:create && rake db:migrate && rake assets:precompile"
sudo aws s3 cp public/assets/ s3://$S3_BUCKET/assets/ --recursive --include "*" --acl "public-read"
sudo docker-compose down
sudo docker-compose up -d
