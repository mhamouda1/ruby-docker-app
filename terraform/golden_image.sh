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

#echo env argument variables to .env file
sudo touch .env
array="${@}"
echo $array | tr " " "\n" >> .env
sudo bash -c "echo 'RAILS_SERVE_STATIC_FILES=true' >> .env"

sudo $(aws ecr get-login --no-include-email --region us-east-1)
sudo docker-compose pull
sudo docker-compose run web bundle update
sudo docker-compose up -d
sudo docker-compose run web rake db:create
sudo docker-compose run web rake db:migrate
sudo docker-compose down
sudo docker-compose kill
