#!/bin/bash

/usr/bin/mongod --fork --logpath /var/log/mongodb/mongod.log --config /etc/mongod.conf

source /reddit/docker/db_config

puma || exit
