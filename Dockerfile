FROM lsiobase/nginx:3.14

# set version label
LABEL build_version="master"
LABEL maintainer="tchilderhose"

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache --upgrade \
	curl \
	git \
	grep \
	php8 \
	php8-ctype \
	php8-curl \
	php8-dom \
	php8-fileinfo \
	php8-fpm \
	php8-gd \
	php8-iconv \
	php8-intl \
	php8-mbstring \
	php8-mysqlnd \
	php8-opcache \
	php8-openssl \
	php8-pcntl \
	php8-pdo_mysql \
	php8-pdo_pgsql \
	php8-pgsql \
	php8-posix \
	php8-session \
	php8-tokenizer \
	php8-xsl \
	tar && \
 echo "**** link php7 to php ****" && \
 ln -sf /usr/bin/php7 /usr/bin/php && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/*

RUN git clone https://git.tt-rss.org/fox/tt-rss.git /var/www/html

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config
