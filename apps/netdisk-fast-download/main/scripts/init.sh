#!/bin/bash

TEMP_CONTAINER_NAME="$(docker create ghcr.io/qaiu/netdisk-fast-download:main)"
if [ $? -ne 0 ]; then
  echo "Failed to create container"
  exit 1
fi

docker cp $TEMP_CONTAINER_NAME:/app/resources ./data
docker rm $TEMP_CONTAINER_NAME
