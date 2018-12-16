FROM alpine:3.7

ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/

RUN apk add --no-cache ruby=2.4.5-r0 ruby-dev=2.4.5-r0 build-base=0.5-r0 ruby-bundler=1.16.1-r0 \
&& bundle install \
&& apk del build-base ruby-dev ruby-bundler

COPY . $APP_HOME

ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292

CMD ["puma"]
