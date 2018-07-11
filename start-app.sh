#!/usr/bin/env bash

set -e

if [ -z ${CF+x} ]; then
  echo ERROR: envar CF must be set to compose file path
  exit 1
fi

# MicroService.
MS=$1
# String Check.
SC=$2

docker-compose -f $CF up -d $MS
while :; do
  docker-compose -f $CF logs $MS | grep $SC && break
  sleep 1
done
