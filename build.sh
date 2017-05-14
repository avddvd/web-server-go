#!/bin/bash -x


. ./common.sh
# create the image to use to do the compiling:
echo "Creating the build container."
bash -x ./builder/builder.sh
PWD=`pwd`
# build the code:
echo "Compiling."
docker run \
    -v $PWD:"/go" \
    -w="/go/src/main" \
    builder bash -cx \
        "go build -o /go/bin/web-server-go" || exit 1

echo "Building $image"
docker build -t "$image" . || exit 1
#rm -rf ./bin/web-server-go
echo "Done."
