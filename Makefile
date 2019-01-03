USER_NAME ?= $(USERNAME)

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
