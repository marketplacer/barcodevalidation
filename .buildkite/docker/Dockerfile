ARG RUBY_VERSION=3.4
FROM ruby:${RUBY_VERSION}-alpine

ENV BUNDLE_WITHOUT="console"
WORKDIR /app

RUN apk --update add --no-cache \
  build-base \
  bash \
  grep
RUN gem install bundler

COPY . ./

RUN ./bin/setup
