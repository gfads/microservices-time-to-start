#!/usr/bin/env bash

set -e

for scenario in rbinder instrumented; do
  # Carts.
  SCENARIO=$scenario ./single.sh carts "Started" carts-db

  # Orders.
  SCENARIO=$scenario ./single.sh orders "Started" orders-db

  # Payment.
  SCENARIO=$scenario ./single.sh payment "port=80"

  # Shipping.
  SCENARIO=$scenario ./single.sh shipping Started

  # User.
  SCENARIO=$scenario ./single.sh user "port=80" user-db
done
