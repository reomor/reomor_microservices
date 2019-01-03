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

[![Build Status](https://api.travis-ci.com/Otus-DevOps-2018-09/reomor_microservices.svg?branch=docker-3)](https://github.com/Otus-DevOps-2018-09/reomor_microservices/tree/docker-3)

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
too much space
```
reomor@debian:~/git/reomor_microservices/src$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
rimskiy/ui          1.0                 8b69e7c17d6a        21 minutes ago      781MB
rimskiy/comment     1.0                 93e3b56daabd        34 minutes ago      773MB
rimskiy/post        1.0                 3e6d5c08b298        39 minutes ago      102MB
mongo               4.1                 d354ee440d75        8 days ago          391MB
ruby                2.2                 6c8e6f9667b2        7 months ago        715MB
python              3.6.0-alpine        cb178ebbf0f2        21 months ago       88.6MB
```
improve Dockerfile for ui
```
FROM ubuntu:16.04
RUN apt-get update \
    && apt-get install -y ruby-full ruby-dev build-essential \
    && gem install bundler --no-ri --no-rdoc

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
add volume
```
docker volume create reddit_db
```
kill all containers
```
docker kill $(docker ps -q)
```
run new containers (db with volume)
```
docker run -d --network=reddit --network-alias=post_db \
--network-alias=comment_db -v reddit_db:/data/db mongo:4.1
docker run -d --network=reddit --network-alias=post rimskiy/post:1.0
docker run -d --network=reddit --network-alias=comment rimskiy/comment:1.0
docker run -d --network=reddit -p 9292:9292 rimskiy/ui:1.0
```
improve Dockerfiles according to hadolint and alpine linux
```
docker run -d --network=reddit --network-alias=post_db \
--network-alias=comment_db -v reddit_db:/data/db mongo:4.1
docker run -d --network=reddit --network-alias=post rimskiy/post:1.0
docker run -d --network=reddit --network-alias=comment rimskiy/comment:3.0
docker run -d --network=reddit -p 9292:9292 rimskiy/ui:3.0

REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
rimskiy/ui          3.0                 056b541a7863        About a minute ago   60.1MB
rimskiy/comment     3.0                 2b93a23be758        26 minutes ago       51.9MB
rimskiy/comment     2.0                 73bed8c8b485        40 minutes ago       359MB
rimskiy/ui          2.0                 49338ccd182e        2 hours ago          453MB
rimskiy/ui          1.0                 8b69e7c17d6a        2 hours ago          781MB
rimskiy/comment     1.0                 93e3b56daabd        2 hours ago          773MB
rimskiy/post        1.0                 3e6d5c08b298        2 hours ago          102MB
```
building...
```
docker build -t rimskiy/comment:3.0 -f ./comment/Dockerfile.1 ./comment/
docker build -t rimskiy/ui:3.0 -f ./ui/Dockerfile.1 ./ui/
```

## HW15

[![Build Status](https://api.travis-ci.com/Otus-DevOps-2018-09/reomor_microservices.svg?branch=docker-4)](https://github.com/Otus-DevOps-2018-09/reomor_microservices/tree/docker-4)

### description
Docker network (none, host, bridge) | Docker compose
```
docker run -ti --rm --network none joffotron/docker-net-tools -c ifconfig
docker run -ti --rm --network host joffotron/docker-net-tools -c ifconfig
docker-machine ssh docker-host ifconfig
```
if run multiple times
```
docker run --network host -d nginx
```
docker ps whows only one container and doesn't run new, probably because port is hold
showing current net-namespaces
```
docker-machine ssh docker-host
sudo ln -s /var/run/docker/netns /var/run/
```
| net-namespace | container                  | command        | result                |
|---------------|----------------------------|----------------|-----------------------|
| none          | joffotron/docker-net-tools | --network none | one new net-namespace |
| host          | joffotron/docker-net-tools | --netowrk host | no new net-namespaces |
```
sudo ip netns exec a753779d74fc ifconfig
lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```
create bridge network
```
docker network create reddit --driver bridge
# or the same because it's default driver
docker network create reddit
```
run project only with reddit network
```
docker run -d --network=reddit mongo:4.1
docker run -d --network=reddit rimskiy/post:1.0
docker run -d --network=reddit rimskiy/comment:3.0
docker run -d --network=reddit -p 9292:9292 rimskiy/ui:3.0
```
error, because services are not registered in DNS docker and links each other with env-params
```
docker kill $(docker ps -q)
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:4.1
docker run -d --network=reddit --network-alias=post rimskiy/post:1.0
docker run -d --network=reddit --network-alias=comment rimskiy/comment:3.0
docker run -d --network=reddit -p 9292:9292 rimskiy/ui:3.0
```
separate docker bridge-networks
```
docker kill $(docker ps -q)
docker network create back_net --subnet=10.0.2.0/24
docker network create front_net --subnet=10.0.1.0/24
docker network ls
```
run with different networks
```
docker run -d --network=back_net --network-alias=post_db --network-alias=comment_db --name mongo_db mongo:4.1
docker run -d --network=back_net --name post rimskiy/post:1.0
docker run -d --network=back_net --name comment rimskiy/comment:3.0
docker run -d --network=front_net -p 9292:9292 --name ui rimskiy/ui:3.0
```
error, put post and comment in both networks manually
it's possible to connect only one network during creation
```
# docker network connect <network> <container>
docker network connect front_net post
docker network connect front_net comment
```
install bridge utils
```
docker-machine ssh docker-host
sudo apt-get update && sudo apt-get install bridge-utils
docker network ls
ifconfig | grep br
brctl show br-f7cde0dcdab6
docker-user@docker-host:~$ brctl show br-f7cde0dcdab6
bridge name	      bridge id		      STP enabled	  interfaces
br-f7cde0dcdab6		8000.02420e97c9ef	no		        veth82ad0ba
							                                    vethdd441c3
docker-user@docker-host:~$ brctl show br-71600deee650
bridge name	      bridge id		      STP enabled	  interfaces
br-71600deee650		8000.0242d76f81f3	no		        vetha3e7db3
							                                    vethd78468a

```
POSTROUTING rules for containers
```
sudo iptables -nL -t nat
sudo iptables -nL -t nat -v
ps ax | grep docker-proxy
```

Docker compose
```
pip install docker-compose
```
docker-compose.yml
```
version: '3.3'
services:
  post_db:
    image: mongo:3.2
    volumes:
      - post_db:/data/db
    networks:
      - reddit
  ui:
    build: ./ui
    image: ${USERNAME}/ui:1.0
    ports:
      - 9292:9292/tcp
    networks:
      - reddit
  post:
    build: ./post-py
    image: ${USERNAME}/post:1.0
    networks:
      - reddit
  comment:
    build: ./comment
    image: ${USERNAME}/comment:1.0
    networks:
      - reddit

volumes:
  post_db:

networks:
  reddit:
```
run
```
docker kill $(docker ps -q)
export USERNAME=rimskiy (unset USERNAME)
# in src/
docker-compose up -d (docker-compose stop)
docker-compose ps
    Name                  Command             State           Ports
----------------------------------------------------------------------------
src_comment_1   puma                          Up
src_post_1      python3 post_app.py           Up
src_post_db_1   docker-entrypoint.sh mongod   Up      27017/tcp
src_ui_1        puma                          Up      0.0.0.0:9292->9292/tcp
```

prefix `src` is base on:
 - COMPOSE_PROJECT_NAME environment variable
 - defaults to the basename of the project directory

run with multiple compose files (order matters)
```
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d
```

## HW16

[![Build Status](https://api.travis-ci.com/Otus-DevOps-2018-09/reomor_microservices.svg?branch=gitlab-ci-1)](https://github.com/Otus-DevOps-2018-09/reomor_microservices/tree/gitlab-ci-1)

### description
Install Gitlab CI
[Official documentation](https://docs.gitlab.com/ce/install/requirements.html)
```
gcloud compute --project=docker-225016 firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server

gcloud compute --project=docker-225016 firewall-rules create default-allow-https --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:443 --source-ranges=0.0.0.0/0 --target-tags=https-server

gcloud compute instances create gitlab-ci \
  --project=docker-225016 \
  --zone=europe-west4-a \
  --machine-type=n1-standard-1 \
  --boot-disk-size=100GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --tags=http-server,https-server,gitlab-ci-server \
  --restart-on-failure
```

or
[docker-machine google](https://docs.docker.com/machine/drivers/gce/)

```
export GOOGLE_PROJECT=docker-225016

docker-machine create --driver google \
--google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
--google-machine-type n1-standard-1 \
--google-zone europe-west1-b \
--google-tags http-server,https-server,gitlab-ci-server \
gitlab-ci

eval $(docker-machine env gitlab-ci)
eval $(docker-machine env --unset)
docker-machine stop gitlab-ci
```
docker-compose.yml prepare
```
sudo mkdir -p /srv/gitlab/config /srv/gitlab/data /srv/gitlab/log
cd /srv/gitlab/
touch docker-compose.yml
sudo apt-get install docker-compose
```
docker-compose.yml
```
web:
  image: 'gitlab/gitlab-ce:latest'
  restart: always
  hostname: 'gitlab.example.com'
  environment:
    GITLAB_OMNIBUS_CONFIG: |
      external_url 'http://<YOUR-VM-IP>'
  ports:
    - '80:80'
    - '443:443'
    - '2222:22'
  volumes:
    - '/srv/gitlab/config:/etc/gitlab'
    - '/srv/gitlab/logs:/var/log/gitlab'
    - '/srv/gitlab/data:/var/opt/gitlab'
```
create image
```
<YOUR-VM-IP> - is external VM IP in GCP
cd /srv/gitlab
docker-compose up -d
```
[Gitlab CI omnibus installation](https://docs.gitlab.com/omnibus/docker/README.html#install-gitlab-using-docker-compose)
```
http://<YOUR-VM-IP> - Gitlab CI ui
```
in Gitlab add user, create Group, Project
in repository
```
git checkout -b gitlab-ci-1
git remote add gitlab http://35.241.247.103/homework/example.git
git push gitlab gitlab-ci-1
```
create .gitlab-ci.yml in root
```
stages:
  - build
  - test
  - deploy

build_job:
  stage: build
  script:
    - echo 'Building'

test_unit_job:
  stage: test
  script:
    - echo 'Testing 1'

test_integration_job:
  stage: test
  script:
    - echo 'Testing 2'

deploy_job:
  stage: deploy
  script:
    - echo 'Deploy'
```
get token at Settings - CI/CD - Runners
install gitlab-runner
```
docker-machine ssh gitlab-ci
sudo docker run -d --name gitlab-runner --restart always \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner:latest
```
register runner in gitlab
```
docker exec -it gitlab-runner gitlab-runner register
 - URL
 - token
 - description (my-runner)
 - tags (linux,xenial,ubuntu,docker)
 - executor (docker)
 - docker default image (alpine:latest)

Settings - CI/CD - Runners - my-runner
```
in my case i was needed to activate `Indicates whether this runner can pick jobs without tags` manualy
then VM IP in GCP changed to another so on VM and build failed because of it
fix
```
docker-machine ssh gitlab-ci
sudo nano /srv/gitlab/config/gitlab.rb
# uncomment and set
external_url 'http://new-VM-ip/'
```
then
```
sudo docker exec -it gitlab_wev_1 bash
gitlab-ctl reconfigure
gitlab-ctl restart
```
then download reddit code
```
git clone https://github.com/express42/reddit.git && rm -rf ./reddit/.git
git add reddit/
git commit -m "add reddit app"
git push gitlab gitlab-ci-1
```
pipeline changes
```
image: ruby:2.4.2

stages:
  - build
  - test
  - deploy

variables:
  DATABASE_URL: 'mongodb://mongo/user_posts'

before_script:
  - cd reddit
  - bundle install

build_job:
  stage: build
  script:
    - echo 'Building'

test_unit_job:
  stage: test
  services:
    - mongo:latest
  script:
    - ruby simpletest.rb

test_integration_job:
  stage: test
  script:
    - echo 'Testing 2'

deploy_job:
  stage: deploy
  script:
    - echo 'Deploy'
```

Gitlab runner installation

[runner registration](https://docs.gitlab.com/runner/register/index.html)
```
touch install_and_register_gl-runners.sh
chmod +x install_and_register_gl-runners.sh
```
file contain
```sh
#!/bin/bash

EXTERNAL_URL=
TOKEN=
COUNT=1
while getopts ":u:t:c:" opt; do
  case $opt in
    u) EXTERNAL_URL="$OPTARG"
    ;;
    t) TOKEN="$OPTARG"
    ;;
    c) COUNT="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

printf "External Gitlab url is %s\n" "$EXTERNAL_URL"
printf "TOKEN is %s\n" "$TOKEN"
printf "COUNT is %s\n" "$COUNT"

for i in `seq 1 $COUNT`; do
            #echo gitlab-runner-$i
            docker run -d --name gitlab-runner-$i --restart always \
            -v /srv/gitlab-runner/config:/etc/gitlab-runner \
            -v /var/run/docker.sock:/var/run/docker.sock \
            gitlab/gitlab-runner:latest

            docker exec -it gitlab-runner gitlab-runner register \
            --non-interactive \
            --url "$EXTERNAL_URL" \
            --registration-token "$TOKEN" \
            --executor "docker" \
            --docker-image alpine:3 \
            --description "docker-runner" \
            --tag-list "docker" \
            --run-untagged \
            --locked="false"
        done
```
then
```
docker-machine scp install_and_register_gl-runners.sh gitlab-ci:/tmp
sudo ./install_and_register_gl-runners.sh -u http://35.205.189.16/ -t t.o.k.e.n -c 4
```

[Slack channel notifications here](https://devops-team-otus.slack.com/messages/CDBMV15RU)

## HW17

[![Build Status](https://api.travis-ci.com/Otus-DevOps-2018-09/reomor_microservices.svg?branch=gitlab-ci-2)](https://github.com/Otus-DevOps-2018-09/reomor_microservices/tree/gitlab-ci-2)

### description

create new project, add to remote repo
```
git remote add gitlab2 http://35.205.189.16/homework/example2.git
```
add job with manual confirmation
```
stages:
  - build
  - test
  - review
  - stage
  - production
...
staging:
  stage: stage
  when: manual
  script:
    - echo 'Deploy'
  environment:
    name: stage
    url: https://beta.example.com
...
```
git tag regex limitation
```
staging:
  stage: stage
  when: manual
  only:
    - /^\d+\.\d+\.\d+/
  script:
    - echo 'Deploy'
  environment:
    name: stage
    url: https://beta.example.com
```
add taged commit 
```
git commit -a -m 'comment'
git tag 2.4.10
git push gitlab2 gitlab-ci-2 --tags
```
dynamic environment for each branch
```
branch review:
  stage: review
  script: echo "Deploy to $CI_ENVIRONMENT_SLUG"
  environment:
    name: branch/$CI_COMMIT_REF_NAME
    url: http://$CI_ENVIRONMENT_SLUG.example.com
  only:
    - branches
  except:
    - master
```
to create server for every branch use terrraform and it's [integration with Gitlab pipline](https://medium.com/@timhberry/terraform-pipelines-in-gitlab-415b9d842596)
because i'm using foreign manual i'm:
adding credentials from GCP
```
cat gitlab-ci/infra/credentials/project.json | base64 -w0
```

[environment variables](https://www.terraform.io/docs/configuration/environment-variables.html)

add Gitlab -> Settings -> CI/CD -> Variables
- SERVICEACCOUNT
- TF_VAR_private_key_path
- TF_VAR_public_key_path

before creating infrastructure must exist:
- rule
```
resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["puma-default"]
}
```
- google storage bucket
```
resource "google_storage_bucket" "gitlab_state_bucket" {
  
  name = "gitlab-terraform-state-storage-bucket"

  versioning {
    enabled = true
  }

  force_destroy = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_storage_bucket_acl" "state_storage_bucket_acl" {
  bucket         = "${google_storage_bucket.gitlab_state_bucket.name}"
  predefined_acl = "private"
}
```

add two stages
```
image:
  name: hashicorp/terraform:light
  entrypoint:
    - '/usr/bin/env'
    - 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

stages:
  - create_infra
  - clear_infra

create infra:
  stage: create_infra
  before_script:
    - cd gitlab-ci/infra/terraform 
    - rm -rf .terraform
    - terraform --version
    - mkdir -p ./credentials
    - echo $SERVICEACCOUNT | base64 -d > ./credentials/project.json
    - mv terraform.tfvars.example terraform.tfvars
    - echo CI_COMMIT_REF_NAME=$CI_COMMIT_REF_NAME
    - export TF_VAR_vm_name=$CI_COMMIT_REF_NAME
    - terraform init
  script:
    - terraform validate
    - terraform plan -out "planfile"
    - terraform apply -input=false "planfile"

clear infra:
  stage: clear_infra
  when: manual
  before_script:
    - cd gitlab-ci/infra/terraform
    - mkdir -p ./credentials
    - echo $SERVICEACCOUNT | base64 -d > ./credentials/project.json
    - mv terraform.tfvars.example terraform.tfvars
    - export TF_VAR_vm_name=$CI_COMMIT_REF_NAME
  script:
    - terraform init
    - terraform destroy -auto-approve
```
creating non-optimazed Dockerfile for reddit based on ubuntu
```
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
```
for using docker images there is a need to create previleged runners and off shared and group runners
Settings -> Ci/CD -> Runners  
```
#!/bin/bash

# my_script -p '/some/path' -a5
EXTERNAL_URL=
TOKEN=
COUNT=1
while getopts ":u:t:c:" opt; do
  case $opt in
    u) EXTERNAL_URL="$OPTARG"
    ;;
    t) TOKEN="$OPTARG"
    ;;
    c) COUNT="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

printf "External Gitlab url is %s\n" "$EXTERNAL_URL"
printf "TOKEN is %s\n" "$TOKEN"
printf "COUNT is %s\n" "$COUNT"

for i in `seq 1 $COUNT`; do
            #echo gitlab-runner-$i
            docker run -d --name gitlab-runner-$i --restart always \
            -v /srv/gitlab-runner/config:/etc/gitlab-runner \
            -v /var/run/docker.sock:/var/run/docker.sock \
            gitlab/gitlab-runner:latest

            docker exec -it gitlab-runner gitlab-runner register \
	          --non-interactive \
            --url "$EXTERNAL_URL" \
            --registration-token "$TOKEN" \
            --executor "docker" \
            --docker-image docker:latest \
            --docker-privileged \
            --description "docker-runner"
        done
```
during installation was error, because of bundler version, the fix is:
```
...
&& gem install bundler --version '<= 1.16.1' --no-ri --no-rdoc
...
```
new version of Dockerfile
```
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

```
usefull commands 
```
docker system prune
df -h
du -sh *
```
result gitlab-ci.yml
with CI\CD variables
- DOCKER_IP
- HUB_PASS
- HUB_USER
- SERVICEACCOUNT
- TF_VAR_private_key_path
- TF_VAR_public_key_path
```
image: docker:stable

services:
  - docker:dind

stages:
  - build
  - test
  - create_infra
  - review
  - stage
  - production
  - clear_infra

variables:
  DATABASE_URL: 'mongodb://mongo/user_posts'
  CI_SHORT_COMMIT_SHA: '$${CI_COMMIT_SHA:0:8}'
  DOCKER_IMAGE: '${CI_COMMIT_REF_NAME}:1.0'

build_job:
  stage: build
  before_script: 
    - cd reddit
    - echo CI_COMMIT_REF_NAME=$CI_COMMIT_REF_NAME
    - echo DOCKER_IMAGE=$DOCKER_IMAGE
    - docker login -u $HUB_USER -p $HUB_PASS
  script:
    - docker build -t $DOCKER_IMAGE .
    - docker tag $DOCKER_IMAGE $HUB_USER/$DOCKER_IMAGE
    - docker push $HUB_USER/$DOCKER_IMAGE

test_unit_job:
  stage: test
  image:
    name: $HUB_USER/$DOCKER_IMAGE
  script:
    - echo DOCKER_IMAGE=$DOCKER_IMAGE
    - cd /reddit
    - ruby simpletest.rb

test_integration_job:
  stage: test
  script:
    - echo 'Testing 2'

create_infra_job:
  stage: create_infra
  image:
    name: hashicorp/terraform:light
    entrypoint:
      - '/usr/bin/env'
      - 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
  before_script:
    - cd gitlab-ci/infra/terraform 
    - rm -rf .terraform
    - terraform --version
    - mkdir -p ./credentials
    - echo $SERVICEACCOUNT | base64 -d > ./credentials/project.json
    - mv terraform.tfvars.example terraform.tfvars
    - echo CI_COMMIT_REF_NAME=$CI_COMMIT_REF_NAME
    - export TF_VAR_vm_name=$CI_COMMIT_REF_NAME
    - export TF_VAR_hub_docker_image=$HUB_USER/$DOCKER_IMAGE
    - terraform init
    - terraform destroy -auto-approve
  script:
    - terraform validate
    - terraform plan -out "planfile"
    - terraform apply -input=false "planfile"

branch_review:
  stage: review
  image:
    name: hashicorp/terraform:light
    entrypoint:
      - '/usr/bin/env'
      - 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
  before_script:
    - echo VM_IP=$VM_IP
    - cd gitlab-ci/infra/terraform
    - mkdir -p ./credentials
    - echo $SERVICEACCOUNT | base64 -d > ./credentials/project.json
    - mv terraform.tfvars.example terraform.tfvars
    - terraform init
    - export DOCKER_IP=$(terraform output docker_external_ip)
    - echo DOCKER_IP=$DOCKER_IP
  script:
    - echo 'Deploy'
  environment:
    name: branch/$CI_COMMIT_REF_NAME
    url: http://$DOCKER_IP:9292
  only:
    - branches
  except:
    - master

staging:
  stage: stage
  when: manual
  only:
    - /^\d+\.\d+\.\d+/
  script:
    - echo 'Deploy'
  environment:
    name: stage
    url: https://beta.example.com

production:
  stage: production
  when: manual
  only:
    - /^\d+\.\d+\.\d+/
  script:
    - echo 'Deploy'
  environment:
    name: production
    url: https://example.com

clear_infra:
  stage: clear_infra
  image:
    name: hashicorp/terraform:light
    entrypoint:
      - '/usr/bin/env'
      - 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
  when: manual
  before_script:
    - cd gitlab-ci/infra/terraform
    - mkdir -p ./credentials
    - echo $SERVICEACCOUNT | base64 -d > ./credentials/project.json
    - mv terraform.tfvars.example terraform.tfvars
    - export TF_VAR_vm_name=$CI_COMMIT_REF_NAME
    - export TF_VAR_hub_docker_image=$HUB_USER/$DOCKER_IMAGE
  script:
    - terraform init
    - terraform destroy -auto-approve
```

## HW18

[![Build Status](https://api.travis-ci.com/Otus-DevOps-2018-09/reomor_microservices.svg?branch=monitoring-1)](https://github.com/Otus-DevOps-2018-09/reomor_microservices/tree/monitoring-1)

### description

Prometheus installation

check existing firewall rules in GCP
```
gcloud compute firewall-rules create prometheus-default --allow tcp:9090
gcloud compute firewall-rules create puma-default --allow tcp:9292
```
create VM in GCP
```
export GOOGLE_PROJECT=docker-225016
docker-machine create --driver google \
--google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
--google-machine-type n1-standard-1 \
--google-zone europe-west1-b \
docker-host

eval $(docker-machine env docker-host)
docker run --rm -p 9090:9090 -d --name prometheus prom/prometheus:v2.1.0
```
useful commands
```
docker-machine ip docker-host
docker stop prometheus
docker-compose logs --follow
```
build each microservice
```
for i in ui post-py comment; do cd src/$i; bash docker_build.sh; cd -; done
```
https://cloud.docker.com/u/rimskiy/repository/list

https://github.com/prometheus/
docker-compose.yml
```
version: '3.3'
services:

  post_db:
    image: mongo:${MONGO_IMAGE_VERSION}
    volumes:
      - post_db:/data/db
    networks:
      back_net:
         aliases:
           - mongodb
           - post_db
           - comment_db

  ui:
    image: ${USER_NAME}/ui:${UI_SERVICE_VERSION}
    ports:
      - ${UI_PUBLICATION_PORT}:9292/tcp
    networks:
      - front_net

  post:
    image: ${USER_NAME}/post:${POST_SERVICE_VERSION}
    networks:
      front_net:
        aliases:
          - post
      back_net:
        aliases:
          - post

  comment:
    image: ${USER_NAME}/comment:${COMMENT_SERVICE_VERSION}
    networks:
      front_net:
        aliases:
          - comment
      back_net:
        aliases:
          - comment
  
  prometheus:
    image: ${USER_NAME}/prometheus
    ports:
      - '9090:9090'
    volumes:
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--storage.tsdb.retention=1d'
    networks:
      front_net:
        aliases:
          - prometheus
      back_net:
        aliases:
          - prometheus
```
prometheus.yml
```
global:
  scrape_interval: '5s'

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets:
        - 'localhost:9090'

  - job_name: 'ui'
    static_configs:
      - targets:
        - 'ui:9292'

  - job_name: 'comment'
    static_configs:
      - targets:
        - 'comment:9292'
```
https://github.com/prometheus/node_exporter
docker-compose.yml
```
node-exporter:
    image: prom/node-exporter:v0.15.2
    user: root
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.ignored-mount-points="^/(sys|proc|dev|host|etc)($$|/)"'
    networks:
      front_net:
        aliases:
          - node-exporter
      back_net:
        aliases:
          - node-exporter
```
prometheus.yml
```
- job_name: 'node'
    static_configs:
      - targets:
        - 'node-exporter:9100'
```
https://github.com/percona/mongodb_exporter
docker-compose.yml
```
mongodb_exporter:
    image: rimskiy/mongodb_exporter:latest
    user: root
    command:
      - '-mongodb.uri=mongodb://mongodb:27017'
      - '-web.listen-address=mongodb-exporter:9104'
    networks:
      back_net:
        aliases:
          - mongodb-exporter
```
prometheus.yml
```
- job_name: 'mongodb'
    static_configs:
      - targets:
        - 'mongodb-exporter:9104'
```
https://github.com/prometheus/blackbox_exporter
docker-compose.yml
```
blackbox_exporter:
    image: prom/blackbox-exporter:latest
    user: root
    ports:
      - '9115:9115'
    networks:
      front_net:
        aliases:
          - blackbox-exporter
      back_net:
        aliases:
          - blackbox-exporter
```
prometheus.yml
```
- job_name: 'blackbox'
  metrics_path: /probe
  params:
    module: [http_2xx]  # Look for a HTTP 200 response.
  static_configs:
    - targets:
      - http://comment
      - http://post
      - http://ui:9292
  relabel_configs:
    - source_labels: [__address__]
      target_label: __param_target
    - source_labels: [__param_target]
      target_label: instance
    - target_label: __address__
      replacement: blackbox-exporter:9115
```
Makefile
- http://rus-linux.net/nlib.php?name=/MyLDP/algol/gnu_make/gnu_make_3-79_russian_manual.html#SEC33
- https://habr.com/post/132524/
- https://www.ibm.com/developerworks/ru/library/l-debugmake/index.html
```
USER_NAME ?= $(USERNAME) # default if not set

all : prom ui post comment exporters
.PHONY : all
settings:
	@echo USER_NAME=$(USER_NAME) USERNAME=$(USERNAME)
prom :
	cd monitoring/prometheus; docker build -t $(USER_NAME)/prometheus .
ui : 
	export USER_NAME=$(USER_NAME); cd src/ui; bash docker_build.sh; cd -;
post :
	export USER_NAME=$(USER_NAME); cd src/post; bash docker_build.sh; cd -;
comment :
	export USER_NAME=$(USER_NAME); cd src/comment; bash docker_build.sh; cd -;
exporters:
	cd monitoring; \
	cd node_exporter; docker build -t prom/node-exporter .; cd -; \
	cd mongodb_exporter; docker build -t rimskiy/mongodb_exporter .; cd -; \
	cd blackbox_exporter; docker build -t prom/blackbox-exporter .; cd -;
compose :
	cd docker; docker-compose up -d
clean:
	cd docker; docker-compose down
```
