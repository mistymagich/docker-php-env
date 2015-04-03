FROM php:fpm

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev

RUN docker-php-ext-install pdo pdo_mysql gd mysqli mcrypt mbstring iconv

ADD date.ini /usr/local/etc/php/conf.d/date.ini

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash"]
CMD ["/entrypoint.sh"]
