FROM ruby:3.2.9-alpine3.22 AS ruby-builder

# https://github.com/jekyll/jekyll/issues/7801
ENV BUNDLE_FORCE_RUBY_PLATFORM=true

RUN apk add --no-cache \
    build-base \
    libffi-dev

WORKDIR /root/build
COPY Gemfile Gemfile.lock ./

RUN bundle install


FROM ruby-builder AS jekyll-builder

COPY _config.yml *.html ./
COPY _posts _posts
COPY _layouts _layouts
COPY new_site new_site

RUN bundle exec jekyll build


FROM node:22-alpine3.22 AS node-builder

WORKDIR /home/node

COPY package-lock.json package.json ./
RUN npm ci --omit=optional


FROM node-builder AS tina-builder

WORKDIR /home/node

COPY tina tina

RUN --mount=type=secret,id=env,target=/home/node/.env \
    if [ -f /home/node/.env ]; then \
        export $(grep -v '^#' /home/node/.env | xargs); \
    fi && \
    npx tinacms build --skip-search-index --noTelemetry --skip-indexing --skip-cloud-checks


FROM nginx:alpine3.22-slim AS http-server

WORKDIR /usr/share/nginx/html

COPY --from=jekyll-builder /root/build/_site .
COPY --from=tina-builder /home/node/admin admin
COPY favicon.ico humans.txt robots.txt ./
COPY img img
COPY new_site new_site
COPY js js
COPY stylesheets stylesheets

RUN ls -lh


FROM ruby-builder AS github-builder

LABEL org.opencontainers.image.source=https://github.com/zen-ireland/zenireland.github.io

RUN apk add --no-cache git tar

COPY --from=tina-builder /home/node/admin admin
# /root/build, ownded by root


FROM github-builder AS github-builder-run

RUN bundle exec jekyll build
