#!/usr/bin/env bash

# Compose File.
CF=./docker-compose.yml
# MicroService.
MS=$1
# String Check.
SC=$2

docker-compose -f $CF up -d $MS
while :; do
  docker-compose -f $CF logs $MS | grep $SC && break
  sleep 1
done
