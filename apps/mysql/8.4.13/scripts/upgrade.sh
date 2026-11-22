#!/bin/bash

CONFIG_FILE="./conf/my.cnf"

if grep -q "skip-host-cache" "$CONFIG_FILE"; then
  sed -i '/skip-host-cache/d' "$CONFIG_FILE"
else
  echo "'skip-host-cache' does not exist in the configuration file."
fi