FROM rimskiy/reddit-base:1.0

RUN gem install bundler --version '1.16.0' --no-ri --no-rdoc

COPY . /reddit
WORKDIR /reddit
RUN bundle install
RUN mv ./docker/mongod.conf /etc/mongod.conf \
    && chmod 0777 /reddit/docker/start.sh

CMD ["/reddit/docker/start.sh"]
