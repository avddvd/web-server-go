#!/bin/bash -xe
cd "$(dirname "$0")"


commit=$( git rev-parse HEAD | cut -c 1-10 )
image="http-server:$commit"
./build.sh

docker run -ti \
           -p 80:80 \
           -e HTTP_PORT=80 \
           "$image"