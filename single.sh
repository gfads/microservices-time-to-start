#!/usr/bin/env bash

#
# Usage
#
#     $ ./single.sh microservice stringcheck [database]
#

# MicroService.
MS=$1
# String Check.
SC=$2
# Database Service
DS=$3
# Compose File.
CF=./docker-compose.yml
# Log File.
LF="instrumented-$1-start-time.log"

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
for i in {1..1}; do
  /usr/bin/time -a -o $LF -f "%e" ./start-app.sh $MS $SC
  docker-compose -f $CF up -d --scale $MS=0 $MS
  sleep $(Rscript ./generate-random-number.r | awk {'print $2'})
done

#
# Teardown.
#
./stopall.sh
