ARG RUBY_VERSION=2.6
FROM ruby:${RUBY_VERSION}-alpine
WORKDIR /app

RUN apk --update add --no-cache \
  nodejs \
  yarn \
  git
RUN gem install bundler

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . ./
