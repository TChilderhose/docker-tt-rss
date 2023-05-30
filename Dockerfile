FROM lsiobase/nginx:3.18

# set version label
LABEL build_version="master"
LABEL maintainer="tchilderhose"

RUN \
 echo "**** Install Packages ****" && \
 apk add --no-cache --upgrade \
	curl \
	git \
	grep \
	php82 \
	php82-ctype \
	php82-curl \
	php82-dom \
	php82-exif \
	php82-fileinfo \
	php82-fpm \
	php82-gd \
	php82-iconv \
	php82-intl \
	php82-json \
	php82-mbstring \
	php82-mysqlnd \
	php82-opcache \
	php82-openssl \
	php82-pcntl \
	php82-pdo \
	php82-pdo_mysql \
	php82-pdo_pgsql \
	php82-pecl-apcu \
	php82-pecl-xdebug \
	php82-pgsql \
	php82-phar \
	php82-posix \
	php82-session \
	php82-simplexml \
	php82-sockets \
	php82-tokenizer \
	php82-xml \
	php82-xmlwriter \
	php82-xsl \
	php82-zip \	
	tar && \
 echo "**** Link php8 to php ****" && \
 ln -sf /usr/bin/php82 /usr/bin/php && \
 echo "**** Cleanup ****" && \
 rm -rf \
	/tmp/*

RUN git clone https://git.tt-rss.org/fox/tt-rss.git /var/www/html

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config
