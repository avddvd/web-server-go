#!/bin/bash -x

cd "$(dirname "$0")"

commit=$( git rev-parse HEAD | cut -c 1-10 )
image="http-server:$commit"
DIR="/go/src/github.com/avddvd/web-server-go"
# create the image to use to do the compiling:
echo "Creating the build container."
bash -x ./builder/builder.sh

# build the code:
echo "Compiling."
docker run \
    -v `pwd`:"$DIR" \
    -w="${DIR}/src" \
    builder bash -cx \
        "go build \
        -o ${DIR}/bin/http-server \
        github.com/avddvd/web-server-go/src/main" || exit 1

# build the docker image:
echo "Cleaning up."
docker rm -f "$image"
docker rmi -f "$image"
echo "Building $image"
docker build -t "$image" . || exit 1
rm -rf ./bin/http-server
echo "Done."
