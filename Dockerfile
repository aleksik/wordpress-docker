FROM php:7.2-fpm
MAINTAINER Aleksi Kaistinen <aleksi.kaistinen@digia.com>

RUN set -ex; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
	    cron \
	    nginx \
	    curl \
	    mysql-client \
	    supervisor \
		libjpeg-dev \
		libpng-dev \
	; \
	\
	docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
	docker-php-ext-install gd mysqli opcache zip; \
	\
	rm -rf /var/lib/apt/lists/*

# WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copy project source
COPY ./app/ /var/www/html/
VOLUME /var/www/html
WORKDIR /var/www/html

# Copy config files
COPY ./services/wordpress/conf.d/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY ./services/wordpress/conf.d/nginx.conf /etc/nginx/nginx.conf
COPY ./services/wordpress/conf.d/vhost.conf /etc/nginx/conf.d/vhost.conf

# Supervisor
RUN mkdir -p /var/log/supervisor
COPY ./services/wordpress/conf.d/supervisord.conf /etc/supervisord.conf
COPY ./services/wordpress/stop-supervisor.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/stop-supervisor.sh

CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]
