FROM  golang:1.10

ENV SRC $GOPATH/src/github.com/percona/mongodb_exporter
WORKDIR $SRC

# COPY mongodb_exporter /bin/mongodb_exporter
RUN git clone "https://github.com/percona/mongodb_exporter" $SRC \
    && go get -d \
    && go build -o /bin/mongodb_exporter

EXPOSE      9216
ENTRYPOINT  [ "/bin/mongodb_exporter" ]
