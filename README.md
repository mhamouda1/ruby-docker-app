# README

Pre-requisites: install docker and docker-compose

Run these commands to get the application working:

#### create the database
```bash
docker-compose run web rake db:create
```

#### migrate the database
```bash
docker-compose run web rake db:migrate
```

#### run the applicaton
```bash
docker-compose up
```
