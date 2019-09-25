FROM ruby

WORKDIR /app

RUN apt-get update -y

RUN gem install rails -v 4.2.11

COPY Gemfile /app/
COPY Gemfile.lock /app/
RUN bundle update

COPY . /app

CMD rm -f tmp/pids/server.pid && rails s -b 0.0.0.0
