FROM lsiobase/nginx:3.18
EXPOSE 80/tcp

LABEL build_version="master"
LABEL maintainer="tchilderhose"

RUN apk add --no-cache --upgrade \
	dcron php82 php82-fpm php82-phar php82-sockets php82-pecl-apcu \
	php82-pdo php82-gd php82-pgsql php82-pdo_pgsql php82-xmlwriter php82-opcache \
	php82-mbstring php82-intl php82-xml php82-curl php82-simplexml \
	php82-session php82-tokenizer php82-dom php82-fileinfo php82-ctype \
	php82-json php82-iconv php82-pcntl php82-posix php82-zip php82-exif \
	php82-openssl git postgresql-client sudo php82-pecl-xdebug rsync tzdata && \
 sed -i 's/\(memory_limit =\) 128M/\1 256M/' /etc/php82/php.ini && \
 ln -sf /usr/bin/php82 /usr/bin/php && \
 rm -rf /tmp/*

RUN git clone https://git.tt-rss.org/fox/tt-rss.git /app/www/public

COPY root/ /

VOLUME /config

ENV PHP_WORKER_MAX_CHILDREN=5
ENV PHP_WORKER_MEMORY_LIMIT=256M
