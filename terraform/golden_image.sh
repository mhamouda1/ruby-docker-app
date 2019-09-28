#!/bin/bash
chmod 400 default_my_key_pair.pem
sudo yum install docker -y
sudo yum install git -y
sudo curl -L 'https://github.com/docker/compose/releases/download/1.24.1/docker-compose-Linux-x86_64' -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo service docker start
sudo systemctl enable docker

cd /home/ec2-user
sudo git clone https://github.com/mhamouda1/ruby-docker-app
cd /home/ec2-user/ruby-docker-app

sudo touch .env
sudo bash -c "echo 'MEMCACHED_SERVER=$1' >> .env"
sudo bash -c "echo 'RAILS_ENV=$2' >> .env"
sudo bash -c "echo 'RUBY_DOCKER_APP_DATABASE_HOST=$3' >> .env"
sudo bash -c "echo 'RUBY_DOCKER_APP_DATABASE_PASSWORD=$4' >> .env"
sudo bash -c "echo 'RUBY_DOCKER_APP_DATABASE_USERNAME=$5' >> .env"
sudo bash -c "echo 'RAILS_SERVE_STATIC_FILES=true' >> .env"

sudo $(aws ecr get-login --no-include-email --region us-east-1)
sudo docker-compose pull
sudo docker-compose up -d
sleep 7 #wait until database is ready, must be a better solution
sudo docker-compose run web bundle update
sudo docker-compose run web rake db:create
sudo docker-compose run web rake db:migrate
sudo docker-compose down
sudo docker-compose kill
