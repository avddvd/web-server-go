#!/bin/bash -xe
cd "$(dirname "$0")"

./build.sh

docker run -ti \
           -p 80:80 \
           -e HTTP_PORT=80 \
           "http-server"
