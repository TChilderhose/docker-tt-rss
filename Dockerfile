FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.18

LABEL build_version="master"
LABEL maintainer="tchilderhose"

RUN \
  echo "**** Install Packages ****" && \
  apk add --no-cache --upgrade \
	dcron php82 php82-fpm php82-phar php82-sockets php82-pecl-apcu \
	php82-pdo php82-gd php82-pgsql php82-pdo_pgsql php82-xmlwriter php82-opcache \
	php82-mbstring php82-intl php82-xml php82-curl php82-simplexml \
	php82-session php82-tokenizer php82-dom php82-fileinfo php82-ctype \
	php82-json php82-iconv php82-pcntl php82-posix php82-zip php82-exif \
	php82-openssl git postgresql-client sudo php82-pecl-xdebug rsync tzdata && \
 echo "**** Link PHP ****" && \
 ln -sf /usr/bin/php82 /usr/bin/php && \
 echo "**** PHP Tweaks ****" && \
 sed -i 's/\(memory_limit =\) 128M/\1 256M/' /etc/php82/php.ini && \
 echo "**** Clone tt-rss Repo ****" && \
 git config --global --add safe.directory /app/www/public && \
 git clone https://git.tt-rss.org/fox/tt-rss.git /app/www/public && \
 echo "**** Cleanup ****" && \
 rm -rf /tmp/* $HOME/.cache

ENV CI_COMMIT_BRANCH=$(git -C /app/www/public rev-parse --abbrev-ref HEAD)
ENV CI_COMMIT_SHA=$(git -C /app/www/public rev-parse HEAD)
ENV CI_COMMIT_SHORT_SHA=$(git -C /app/www/public rev-parse --short HEAD)
ENV CI_COMMIT_TIMESTAMP=$(git -C /app/www/public log -1 --format="%at" | xargs -I{} date -d @{} +%FT%T)

ENV PHP_WORKER_MAX_CHILDREN=5
ENV PHP_WORKER_MEMORY_LIMIT=256M

ENV OWNER_UID=1000
ENV OWNER_GID=1000

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config
