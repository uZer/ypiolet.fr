# Multistage build

# Stage 1: build
FROM alpine AS build

COPY . /app

RUN set -x \
      && apk add --no-cache hugo git \
      && hugo version \
      && cd /app \
      && hugo --minify --enableGitInfo

# Stage 2: run
FROM nginx:alpine

ARG APP_NAME="wwwypiolet"
ARG APP_DESCRIPTION="Static website served by nginx"
ARG BUILD_DATE
ARG BUILD_VCS_REF
ARG BUILD_VCS_URL="https://github.com/uZer/ypiolet.fr"

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.description=$APP_DESCRIPTION \
      org.label-schema.name=$APP_NAME \
      org.label-schema.schema-version="1.0" \
      org.label-schema.url=$BUILD_REPO \
      org.label-schema.version=$BUILD_VCS_REF

WORKDIR /usr/share/nginx/html/

RUN set -x \
      && apk update \
      && apk upgrade \
      && rm -rf * .??* \
      && sed -i '9i\        include /etc/nginx/conf.d/cache.inc;\n' /etc/nginx/conf.d/default.conf

COPY nginx.cache.inc /etc/nginx/conf.d/cache.inc
COPY --from=build /app/public /usr/share/nginx/html

EXPOSE 80
