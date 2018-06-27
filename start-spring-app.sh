#!/usr/bin/env bash

CF=./docker-compose.yml

docker-compose -f $CF up -d $1
while :; do
  docker-compose -f $CF logs $1 | grep Started && break
  sleep 1
done
