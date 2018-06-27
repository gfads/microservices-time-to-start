#!/usr/bin/env bash

CF=./docker-compose.yml

#
# Start carts-db.
#
docker-compose -f $CF up -d carts-db
while :; do
  docker-compose -f $CF logs carts-db | grep "waiting for connections" && break
  sleep 1
done

#
# Measure time to start.
#
for i in {1..10}; do
  /usr/bin/time -a -o instrumented-carts-start-time.log -f "%e" ./start-spring-app.sh carts
  docker-compose -f $CF up -d --scale carts=0 carts
  sleep $(Rscript ./generate-random-number.r | awk {'print $2'})
done

#
# Teardown.
#
./stopall.sh
