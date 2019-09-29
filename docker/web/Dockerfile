FROM ruby

WORKDIR /app

RUN apt-get update -y && \
    gem install rails -v 4.2.11 --no-document

COPY Gemfile /app/
COPY Gemfile.lock /app/

RUN bundle install --jobs 5

COPY . /app

RUN apt-get install vim -y

CMD rm -f tmp/pids/server.pid && rails s -b 0.0.0.0
