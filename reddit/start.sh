#!/bin/bash

/usr/bin/mongod --fork --logpath /var/log/mongod.log --config /etc/mongod.conf

source /reddit/docker/db_config

/reddit/puma || exit
