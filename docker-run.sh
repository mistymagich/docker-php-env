#!/bin/bash

set -eu

DOCKER=docker
CURDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# 起動中のdockerコンテナを停止&削除
echo "Remove Containers."
CONTAINERS=`${DOCKER} ps -a -q`
if [ ! -z "$CONTAINERS" ] ; then
	echo $CONTAINERS | xargs ${DOCKER} stop | xargs ${DOCKER} rm
fi

# MySQL Container
${DOCKER} run -d --name sandbox-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=mysecretpw mysql

# DB import
if [ -e $CURDIR/src/init.sql ]; then
	echo "Waiting MySQL startup."
	sleep 10
	${DOCKER} run --link sandbox-mysql:mysql --rm -v "${CURDIR}/src":/docker mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" < /docker/init.sql'
fi

# App Container
${DOCKER} run -d --name sandbox-php --link sandbox-mysql:mysql -v "${CURDIR}/src":/var/www/app php:fpm-custom

# Web Container
${DOCKER} run -d --name sandbox-nginx -p 80:80 -p 443:443 --link sandbox-php:php -v "${CURDIR}/src":/var/www/app nginx:custom
