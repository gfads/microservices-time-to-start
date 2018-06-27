#!/usr/bin/env bash

# Carts.
./single.sh carts "Started" carts-db

# Orders.
./single.sh orders "Started" orders-db

# Payment.
./single.sh payment "port=80"
