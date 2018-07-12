#!/usr/bin/env bash

#
# Usage
#
#     $ SCENARIO=scenario ./single.sh microservice stringcheck [database]
#

if [ -z ${SCENARIO+x} ]; then
  echo ERROR: envar SCENARIO must be set to rbinder or instrumented
  exit 1
fi

# MicroService.
MS=$1
# String Check.
SC=$2
# Database Service
DS=$3
# Compose File.
export CF=./docker-compose.${SCENARIO}.yml
# Log File.
LF="${SCENARIO}-$1-start-time.log"
# Sample Size.
SS=30

mkdir -p logs

#
# Start db service.
#
if [ -n "$DS" ]; then
  docker-compose -f $CF up -d $DS
  while :; do
    docker-compose -f $CF logs $DS | grep "waiting for connections" && break
    sleep 1
  done
fi

#
# Measure time to start.
#
while [ $SS -gt 0 ]; do
  let SS=SS-1

  /usr/bin/time -a -o ./logs/$LF -f "%e" ./start-app.sh $MS $SC

  if [ $SS -gt 0 ]; then
    docker-compose -f $CF up -d --scale $MS=0 $MS
    sleep $(Rscript ./generate-random-number.r | awk {'print $2'})
  fi
done

#
# Teardown.
#
./stopall.sh $CF
