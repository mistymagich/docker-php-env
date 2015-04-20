#!/bin/bash

set -eu

DOCKER=docker
CURDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

export COMPOSE_FILE=${CURDIR}/docker-compose.yml
docker-compose up -d
