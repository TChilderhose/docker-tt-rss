FROM lsiobase/nginx:3.18

# set version label
LABEL build_version="master"
LABEL maintainer="tchilderhose"

RUN apk add --no-cache dcron php82 php82-fpm php82-phar php82-sockets php82-pecl-apcu \
	php82-pdo php82-gd php82-pgsql php82-pdo_pgsql php82-xmlwriter php82-opcache \
	php82-mbstring php82-intl php82-xml php82-curl php82-simplexml \
	php82-session php82-tokenizer php82-dom php82-fileinfo php82-ctype \
	php82-json php82-iconv php82-pcntl php82-posix php82-zip php82-exif \
	php82-openssl git postgresql-client sudo php82-pecl-xdebug rsync tzdata && \
 sed -i 's/\(memory_limit =\) 128M/\1 256M/' /etc/php82/php.ini && \
 sed -i -e 's/^listen = 127.0.0.1:9000/listen = 9000/' \
		-e 's/;\(clear_env\) = .*/\1 = no/i' \
		-e 's/;\(php_admin_value\[error_log\]\) = .*/\1 = \/tmp\/error.log/' \
		-e 's/;\(php_admin_flag\[log_errors\]\) = .*/\1 = on/' \
			/etc/php82/php-fpm.d/www.conf && \
 ln -sf /usr/bin/php82 /usr/bin/php && \
 rm -rf /tmp/*

RUN git clone https://git.tt-rss.org/fox/tt-rss.git /app/www/public

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config

ENV PHP_WORKER_MAX_CHILDREN=5
ENV PHP_WORKER_MEMORY_LIMIT=256M
