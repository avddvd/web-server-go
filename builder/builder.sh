#!/bin/bash

cd $(dirname $0)

# build container 
docker build -t builder . 
