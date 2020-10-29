ARG RUBY_VERSION=2.6
FROM ruby:${RUBY_VERSION}-alpine
WORKDIR /app

RUN apk --update add --no-cache \
  bash \
  grep
RUN gem install bundler

COPY . ./

RUN ./bin/setup
