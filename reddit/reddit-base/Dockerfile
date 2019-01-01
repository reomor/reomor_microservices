FROM ubuntu:16.04

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \ 
    ruby-full=1:2.3.0+1 ruby-dev=1:2.3.0+1 build-essential=12.1ubuntu2 mongodb-server \ 
    && rm -rf /var/lib/apt/lists/*
