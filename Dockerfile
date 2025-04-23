FROM ruby:3.2.8-slim-bookworm AS ruby-builder

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update && apt install -y --no-install-recommends \
    build-essential

WORKDIR /root/build

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY _config.yml *.html ./
COPY _posts _posts
COPY _layouts _layouts

RUN bundle exec jekyll build

RUN find .


FROM node:18.20-alpine3.21 AS node-builder

RUN apk add just

WORKDIR /home/node

COPY package-lock.json package.json ./
RUN npm ci --omit=optional

RUN ls -lh
COPY tina tina

RUN chown -R node:node .

RUN ls -lh

USER node

RUN ls -lh

ARG TINA_TOKEN
ENV TINA_TOKEN=$TINA_TOKEN
RUN echo $TINA_TOKEN
ARG NEXT_PUBLIC_TINA_CLIENT_ID
ENV NEXT_PUBLIC_TINA_CLIENT_ID=$NEXT_PUBLIC_TINA_CLIENT_ID
RUN echo $NEXT_PUBLIC_TINA_CLIENT_ID

RUN whoami
RUN pwd
RUN ls -lh
RUN npx tinacms build --skip-search-index --noTelemetry --skip-indexing


FROM nginx:1.27.5-alpine3.21-slim AS built

WORKDIR /usr/share/nginx/html

COPY --from=ruby-builder /root/build/_site .
COPY --from=node-builder /home/node/admin admin
COPY favicon.ico humans.txt robots.txt ./
COPY img img
COPY js js
COPY stylesheets stylesheets
RUN ls
