#!/bin/bash
# sudo bash -c 'echo export HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/local-hostname) >> /root/.bash_profile'
sudo bash -c "echo 'NODE_HOST=$(curl http://169.254.169.254/latest/meta-data/local-hostname)' >> .env"
# source /root/.bash_profile

#source /root/.bashrc
#export RAILS_ENV=$(RAILS_ENV)
#export MEMCACHED_SERVER=$(MEMCACHED_SERVER)

# whoami > whoami.txt
# env > env.txt

export MEMCACHED_SERVER=$1
export RAILS_ENV=$2
export RUBY_DOCKER_APP_DATABASE_HOST=$3
export RUBY_DOCKER_APP_DATABASE_PASSWORD=$4
export RUBY_DOCKER_APP_DATABASE_USERNAME=$5
export NODE_HOST=$(curl http://169.254.169.254/latest/meta-data/local-hostname)

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
sudo docker-compose run web rake assets:precompile
sudo docker-compose down
sudo docker-compose up -d

# source /root/.bash_profile
# source /root/.bashrc
# whoami > whoami2.txt
# env > env2.txt
