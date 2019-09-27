#!/bin/bash
#parameter 1 = memcached server
#parameter 2 = rails environment
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

echo MEMCACHED_SERVER VARIABLE IS: $1
echo RAILS_ENV VARIABLE IS: $2

export MEMCACHED_SERVER=$1
export RAILS_ENV=$2

sudo touch .env
sudo bash -c "echo 'MEMCACHED_SERVER=$1' >> .env"
sudo bash -c "echo 'RAILS_ENV=$2' >> .env"

sudo bash -c "echo '#!/bin/bash' >> /etc/profile.d/export_env_variables.sh"
sudo bash -c "echo 'export MEMCACHED_SERVER=$1' >> /etc/profile.d/export_env_variables.sh"
sudo bash -c "echo 'export RAILS_ENV=$2' >> /etc/profile.d/export_env_variables.sh"

sudo bash -c "echo 'export MEMCACHED_SERVER=$1' >> /root/.bash_profile"
sudo bash -c "echo 'export RAILS_ENV=$2' >> /root/.bash_profile"

sudo bash -c "echo 'export MEMCACHED_SERVER=$1' >> /root/.bashrc"
sudo bash -c "echo 'export RAILS_ENV=$2' >> /root/.bashrc"

sudo bash -c "echo 'export MEMCACHED_SERVER=$1'"
sudo bash -c "echo 'export RAILS_ENV=$2'"

sudo bash -c "source /root/.bash_profile"
sudo bash -c "source /root/.bashrc"
sudo bash /etc/profile.d/export_env_variables.sh

cd /home/ec2-user/ruby-docker-app

sudo $(aws ecr get-login --no-include-email --region us-east-1)
sudo docker-compose pull
sudo docker-compose up -d
sleep 7 #wait until database is ready, must be a better solution
sudo docker-compose run web bundle update
sudo docker-compose run web rake db:create
sudo docker-compose run web rake db:migrate
sudo docker-compose down
sudo docker-compose kill
