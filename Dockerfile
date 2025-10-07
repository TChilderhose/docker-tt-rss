FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.22

LABEL build_version="master"
LABEL maintainer="tchilderhose"

ENV PHP_SUFFIX=84

RUN \
  echo "**** Install Packages ****" && \
  apk add --no-cache ca-certificates dcron git postgresql-client rsync sudo tzdata \	
	php${PHP_SUFFIX} \
		$(for p in ctype curl dom exif fileinfo fpm gd iconv intl json mbstring opcache \
			openssl pcntl pdo pdo_pgsql pecl-apcu pecl-xdebug phar posix session simplexml sockets sodium tokenizer xml xmlwriter zip; do \
			php_pkgs="$php_pkgs php${PHP_SUFFIX}-$p"; \
		done; \
		echo $php_pkgs) && \
	echo "**** Link PHP ****" && \
 	ln -sf /usr/bin/php${PHP_SUFFIX} /usr/bin/php && \ 
 	echo "**** PHP Tweaks ****" && \
 	sed -i "s/^\(memory_limit\) = \(.*\)/\1 = 256M/" /etc/php${PHP_SUFFIX}/php.ini && \
 	sed -i "s/^\(pm.max_children\) = \(.*\)/\1 = 5/" /etc/php${PHP_SUFFIX}/php.ini && \ 
	echo "**** Clone tt-rss Repo ****" && \
	git clone https://github.com/tt-rss/tt-rss.git /app/www/public && \ 
	echo "**** Cleanup ****" && \
	rm -rf /tmp/* $HOME/.cache

ENV PUID=1000
ENV PGID=1000

ENV PHP_WORKER_MAX_CHILDREN=5
ENV PHP_WORKER_MEMORY_LIMIT=256M

# copy local files
COPY root/ /
RUN chmod +x /custom-cont-init.d/*
RUN chmod +x /custom-services.d/*

# ports and volumes
EXPOSE 80
VOLUME /config
