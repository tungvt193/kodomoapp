FROM ruby:2.6.5

LABEL maintainer="Vu Thanh Tung <tungvt@its-global.vn>"
RUN apt-get update -qq && apt-get install -y libxml2-dev libxslt-dev nodejs postgresql-client yarn
WORKDIR /kodomoapp
COPY Gemfile /kodomoapp/Gemfile
COPY Gemfile.lock /kodomoapp/Gemfile.lock

RUN gem install bundler && bundle config set force_ruby_platform true && \
  bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]
EXPOSE 3000
