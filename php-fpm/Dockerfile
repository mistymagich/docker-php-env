FROM php:fpm

RUN apt-get update

RUN apt-get install -y \
    	libfreetype6-dev \
    	libjpeg62-turbo-dev \
        libpng12-dev
RUN docker-php-ext-install gd

RUN docker-php-ext-install pdo pdo_mysql mysqli 

RUN apt-get install -y libmcrypt-dev
RUN docker-php-ext-install mcrypt

RUN docker-php-ext-install mbstring iconv

# xdebug
RUN curl -L -o /root/xdebug.tgz https://pecl.php.net/get/xdebug-2.3.2.tgz && \
	cd /root && \
	tar -zxvf xdebug.tgz && \
	cd /root/xdebug-2.3.2 && \
	/usr/local/bin/phpize && \
	./configure --enable-xdebug --with-php-config=/usr/local/bin/php-config && \
	make  && \
	make install && \
	cd /root && \
	rm -fr /root/xdebug-2.3.2 && \
	rm -fr /root/xdebug.tgz
ADD xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# datetime
ADD date.ini /usr/local/etc/php/conf.d/date.ini

ADD entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
ENTRYPOINT ["/bin/bash"]
