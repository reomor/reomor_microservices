# reomor_microservices
reomor microservices repository

## HW12

[![Build Status](https://api.travis-ci.com/Otus-DevOps-2018-09/reomor_microservices.svg?branch=docker-1)](https://github.com/Otus-DevOps-2018-09/reomor_microservices/tree/docker-1)

### description
Docker monolith
[install docker on debian](https://docs.docker.com/install/linux/docker-ce/debian/#set-up-the-repository)
```
sudo apt-get remove docker docker-engine docker.io

sudo apt-get update

sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

sudo apt-get install docker-ce
```
docker commands run over SUDO
commands
```
docker version
docker info
docker run hello-world
```
list containers
```
docker ps
docker ps -a
```
list images
```
docker images
```
run container from image
```
docker run -it ubuntu:16.04 /bin/bash
--rm - delete container after stop
```
start already create container && connect terminal
```
docker start <u_container_id>
docker attach <u_container_id>
ctrl + p, ctrl + q
docker run = create + start + attach
-i docker attach
-d background
-t - TTY
```
run new process in container
```
docker exec -it <u_container_id> bash
```
create image from container, container runs
```
docker commit f806830d7ab3 me/temp-ubuntu
```
stop
```
docker container stop <u_container_id>
```
kill
```
docker ps -q
docker kill $(docker ps -q)
```
info about size of images, containers and volumes
```
docker system df
```
delete container, with -f working container too
```
docker rm
docker rm -f
```
delete image if no containers depends on it
```
docker rmi
```

## HW13

[![Build Status](https://api.travis-ci.com/Otus-DevOps-2018-09/reomor_microservices.svg?branch=docker-2)](https://github.com/Otus-DevOps-2018-09/reomor_microservices/tree/docker-2)

### description
...
create project docker in GCP
install gcloud sdk locally
```
gcloud init
gcloud auth application-default login
```
[install docker-machine](https://docs.docker.com/machine/install-machine/#install-machine-directly)
```
base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  sudo install /tmp/docker-machine /usr/local/bin/docker-machine
```
enable compute engine API (before or after machine creation error)
create host in GCP with docker ce by docker machine 
```
export GOOGLE_PROJECT=docker-225016
docker-machine create --driver google \
--google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
--google-machine-type n1-standard-1 \
--google-zone europe-west1-b \
docker-host
```
docker-host is a name of machine
check docker-host status and switch to remote docker (the command has no output)
```
docker-machine ls
eval $(docker-machine env docker-host)
```
back to local docker
```
eval $(docker-machine env --unset)
```
isolated area, instant PID
```
 docker run --rm -ti tehbilly/htop
```
among host processes, host PID
``` 
 docker run --rm --pid host -ti tehbilly/htop
```
[docker in docker image](https://github.com/jpetazzo/dind)
[user namespace docs](https://docs.docker.com/engine/security/userns-remap/)
Dockerfile
```
FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y mongodb-server ruby-full ruby-dev build-essential git
RUN gem install bundler
RUN git clone -b monolith https://github.com/express42/reddit.git

COPY mongod.conf /etc/mongod.conf
COPY db_config /reddit/db_config
COPY start.sh /start.sh

RUN cd /reddit && bundle install
RUN chmod 0777 /start.sh

CMD ["/start.sh"]
```
build
```
docker build -t reddit:latest .
```
gcloud rule - allow acces to port 9292
```
gcloud compute firewall-rules create reddit-app \
--allow tcp:9292 \
--target-tags=docker-machine \
--description="Allow PUMA connections" \
--direction=INGRESS
```
login at Docker-Hub with Docker-Hub registration name and password
```
docker login
```
push my own image
```
docker tag reddit:latest rimskiy/otus-reddit:1.0
docker push rimskiy/otus-reddit:1.0
```
use image from Docker-Hub
```
docker run --name reddit -d -p 9292:9292 rimskiy/otus-reddit:1.0
```
useful commands
```
docker logs reddit -f 
docker exec -it reddit bash
 - ps aux
 - killall5 1
docker start reddit
docker stop reddit && docker rm reddit
docker run --name reddit --rm -it rimskiy/otus-reddit:1.0 bash
 - ps aux
 - exit
```
additional useful commands
```
docker inspect rimskiy/otus-reddit:1.0
docker inspect rimskiy/otus-reddit:1.0 -f '{{.ContainerConfig.Cmd}}'
docker run --name reddit -d -p 9292:9292 docker inspect rimskiy/otus-reddit:1.0
docker exec -it reddit bash
 - mkdir /test123
 - touch /test123/file123
 - rmdir /opt
 - exit
docker diff reddit 
```
docker image via terraform
 - create directory terraform in infra
 - create empty main.tf
 - then
```
terraform init
```
 - add provider
 - describe google_compute_instance
 - extract variables and its defaults
 - put output variables
 - set exact variables in terraform.tfvars (terraform.tfvars.example)
 - apply
```
terraform apply
```
it is possible to install docker only by terraform [link](https://collabnix.com/5-minutes-to-run-your-first-docker-container-on-google-cloud-platform-using-terraform/)

ansible
 - add ansible.cfg
 - add GCP dynamic inventory
 - add credentials
 - add playbooks
```
ansible-playbook playbooks/site.yml --check -vvvv
ansible-playbook playbooks/site.yml
```

packer
```
cd infra
packer validate -var-file packer/variables.json packer/packer_docker.json
packer build -var-file packer/variables.json packer/packer_docker.json
```


## HW14

[![Build Status](https://api.travis-ci.com/Otus-DevOps-2018-09/reomor_microservices.svg?branch=docker-33)](https://github.com/Otus-DevOps-2018-09/reomor_microservices/tree/docker-3)

### description

install Haskell stack
```
curl -sSL https://get.haskellstack.org/ | sh
git clone https://github.com/hadolint/hadolint
cd hadolint
stack install
```
create Dockerfile for each service
post-py
```
FROM python:3.6.0-alpine

WORKDIR /app
ADD . /app

RUN pip install -r /app/requirements.txt

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

CMD ["python3", "post_app.py"]
```
comment
```
FROM ruby:2.2
RUN apt-get update -qq && apt-get install -y build-essential

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install
ADD . $APP_HOME

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

CMD ["puma"]
```
ui
```
FROM ruby:2.2
RUN apt-get update -qq && apt-get install -y build-essential

ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
RUN bundle install
ADD . $APP_HOME

ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292

CMD ["puma"]
```
get latest version fixed mongo docker image
```
docker pull mongo:4.1
```
build images
```
docker build -t rimskiy/post:1.0 ./post-py
docker build -t rimskiy/comment:1.0 ./comment
docker build -t rimskiy/ui:1.0 ./ui/
```
create separate network
```
docker network create reddit
```
and run containers
```
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:4.1
docker run -d --network=reddit --network-alias=post rimskiy/post:1.0
docker run -d --network=reddit --network-alias=comment rimskiy/comment:1.0
docker run -d --network=reddit -p 9292:9292 rimskiy/ui:1.0
```
run with my own network aliases and ENV parameters
```
docker run -d --network=reddit --network-alias=p_db --network-alias=c_db mongo:4.1
docker run -d --network=reddit --network-alias=p --env POST_DATABASE_HOST=p_db rimskiy/post:1.0
docker run -d --network=reddit --network-alias=c --env COMMENT_DATABASE_HOST=c_db rimskiy/comment:1.0
docker run -d --network=reddit -p 9292:9292 --env POST_SERVICE_HOST=p --env COMMENT_SERVICE_HOST=c rimskiy/ui:1.0
```
