FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.20

LABEL build_version="master"
LABEL maintainer="tchilderhose"

RUN \
  echo "**** Install Packages ****" && \
  apk add --no-cache --upgrade \
	php83 php83-fpm php83-phar php83-sockets php83-pecl-apcu \
	php83-pdo php83-gd php83-pgsql php83-pdo_pgsql php83-xmlwriter php83-opcache \
	php83-mbstring php83-intl php83-xml php83-curl php83-simplexml \
	php83-session php83-tokenizer php83-dom php83-fileinfo php83-ctype \
	php83-json php83-iconv php83-pcntl php83-posix php83-zip php83-exif \
	php83-openssl git postgresql-client sudo php83-pecl-xdebug rsync tzdata && \ 
	echo "**** Link PHP ****" && \
 	ln -sf /usr/bin/php83 /usr/bin/php && \ 
 	echo "**** PHP Tweaks ****" && \
 	sed -i "s/^\(memory_limit\) = \(.*\)/\1 = 256M/" /etc/php83/php.ini && \
 	sed -i "s/^\(pm.max_children\) = \(.*\)/\1 = 5/" /etc/php83/php.ini && \ 
	echo "**** Clone tt-rss Repo ****" && \
	git config --global --add safe.directory /app/www/public && \
	git clone https://git.tt-rss.org/fox/tt-rss.git /app/www/public && \ 
	echo "**** Cleanup ****" && \
	rm -rf /tmp/* $HOME/.cache

ENV PUID=1000
ENV PGID=1000

# copy local files
COPY root/ /
RUN chmod +x /etc/cont-init.d/*
RUN chmod +x /etc/services.d/update-feeds/*

# ports and volumes
EXPOSE 80
VOLUME /config
