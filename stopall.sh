#!/usr/bin/env bash

set -e

docker-compose -f $1 down
