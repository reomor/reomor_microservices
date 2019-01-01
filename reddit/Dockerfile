FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y mongodb-server ruby-full ruby-dev build-essential && \
    gem install bundler

COPY . /reddit

WORKDIR /reddit

RUN bundle install && \
    mv ./docker/mongod.conf /etc/mongod.conf && \
    chmod 0777 /reddit/start.sh  

CMD ["/reddit/start.sh"]
