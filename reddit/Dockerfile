FROM rimskiy/reddit-base:1.0

COPY . /reddit
WORKDIR /reddit
RUN bundle install
RUN mv ./docker/mongod.conf /etc/mongod.conf \
    && chmod 0777 /reddit/docker/start.sh

CMD ["/reddit/docker/start.sh"]
