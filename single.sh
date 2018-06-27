#!/usr/bin/env bash

# MicroService.
MS=$1
# Database Service
DS=$2
# Compose File.
CF=./docker-compose.yml
# Log File.
LF="instrumented-$1-start-time.log"

#
# Start db service.
#
if [ -n $DS ]; then
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
  /usr/bin/time -a -o $LF -f "%e" ./start-spring-app.sh $MS
  docker-compose -f $CF up -d --scale $MS=0 $MS
  sleep $(Rscript ./generate-random-number.r | awk {'print $2'})
done

#
# Teardown.
#
./stopall.sh
