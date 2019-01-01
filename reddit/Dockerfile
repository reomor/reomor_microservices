FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y ruby-full ruby-dev build-essential mongodb-server \
    && gem install bundler --version '<= 1.16.1' --no-ri --no-rdoc

COPY . /reddit

WORKDIR /reddit

RUN bundle install

RUN mv ./docker/mongod.conf /etc/mongod.conf \
    && chmod 0777 /reddit/docker/start.sh

CMD ["/reddit/docker/start.sh"]
