#!/bin/bash
chmod 400 default_my_key_pair.pem
sudo yum install docker -y
sudo yum install git -y
sudo curl -L 'https://github.com/docker/compose/releases/download/1.24.1/docker-compose-Linux-x86_64' -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo service docker start
sudo systemctl enable docker
sudo git clone https://github.com/mhamouda1/ruby-docker-app
cd ~/ruby-docker-app

echo MEMCACHED_SERVER VARIABLE IS: ${var.MEMCACHED_SERVER}

sudo bash -c 'echo \"#!/bin/bash\" >> /etc/profile.d/export_env_variables.sh'
sudo bash -c 'echo export RAILS_ENV=production >> /etc/profile.d/export_env_variables.sh'
sudo bash -c 'echo export MEMCACHED_SERVER=${var.MEMCACHED_SERVER} >> /etc/profile.d/export_env_variables.sh'

sudo bash -c 'echo export RAILS_ENV=production >> /root/.bash_profile'
sudo bash -c 'echo export MEMCACHED_SERVER=${var.MEMCACHED_SERVER} >> /root/.bash_profile'

sudo bash -c 'echo export RAILS_ENV=production >> /root/.bashrc'
sudo bash -c 'echo export MEMCACHED_SERVER=${var.MEMCACHED_SERVER} >> /root/.bashrc'

sudo bash -c 'source /root/.bash_profile'
sudo bash -c 'source /root/.bashrc'
sudo bash /etc/profile.d/export_env_variables.sh

sudo cat /root/.bash_profile'
cat /root/.bash_profile'

sudo $(aws ecr get-login --no-include-email --region us-east-1)
sudo docker-compose pull
sudo docker-compose up -d
sleep 7 #wait until database is ready, must be a better solution
sudo docker-compose run web bundle update
sudo docker-compose run web rake db:create
sudo docker-compose run web rake db:migrate
sudo docker-compose down
sudo docker-compose kill
