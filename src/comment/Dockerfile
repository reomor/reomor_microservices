FROM ubuntu:16.04
RUN apt-get update -qq && apt-get install -y --no-install-recommends ruby-full=1:2.3.0+1 ruby-dev=1:2.3.0+1 build-essential=12.1ubuntu2 \ 
&& rm -rf /var/lib/apt/lists/* 
RUN gem install bundler --version '1.16.1' --no-ri --no-rdoc

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/
RUN bundle install
COPY . $APP_HOME

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

CMD ["puma"]
