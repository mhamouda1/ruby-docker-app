# README

Pre-requisites: install docker and docker-compose

Run these commands to get the application working:

#### run the applicaton
```bash
sudo docker-compose pull
sudo docker-compose build
sudo docker-compose up -d
sudo docker-compose run web bundle update
sudo docker-compose run web rake db:create
sudo docker-compose run web rake db:migrate
```
