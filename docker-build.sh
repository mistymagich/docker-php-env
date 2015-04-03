#!/bin/bash

set -eu

DOCKER=docker
CURDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

${DOCKER} build --rm -t php:fpm-custom ${CURDIR}/php-fpm
${DOCKER} build --rm -t nginx:custom ${CURDIR}/nginx

