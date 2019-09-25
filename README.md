README

Pre-requisites: install docker and docker-compose

Run these commands to get the application working:

```bash
docker-compose run web rake db:create
```

```bash
docker-compose run web rake db:migrate
```

```bash
docker-compose up
```




This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.
