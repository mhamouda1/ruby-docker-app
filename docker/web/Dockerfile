FROM ruby

WORKDIR /app

RUN apt-get update -y && \
    gem install rails -v 4.2.11 --no-document

COPY Gemfile /app/
COPY Gemfile.lock /app/

RUN bundle update --jobs 5

COPY . /app

CMD rm -f tmp/pids/server.pid && rails s -b 0.0.0.0
