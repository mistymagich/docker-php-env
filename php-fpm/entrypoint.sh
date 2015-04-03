#!/bin/bash

echo "env[MYSQL_ENV_MYSQL_ROOT_PASSWORD] = ${MYSQL_ENV_MYSQL_ROOT_PASSWORD}" >> /usr/local/etc/php-fpm.conf
php-fpm
