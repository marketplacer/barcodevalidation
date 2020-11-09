FROM node:alpine
WORKDIR /app

RUN apk --update add --no-cache git

COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile
