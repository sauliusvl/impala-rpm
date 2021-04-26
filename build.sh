#!/bin/bash

BUILDER_IMAGE=impala-builder:$(git rev-parse --short HEAD)

docker build -t ${BUILDER_IMAGE} buildenv/

rm -rf target/*
cp -R rpm target/

docker run --net host --ulimit nofile=64000 --rm --name impala-rpm-builder -it \
 -v $(pwd)/impala:/impala \
 -v $(pwd)/target:/target \
 -v /tmp/m2_cache:/root/.m2 \
 ${BUILDER_IMAGE} bash /target/rpm/build.sh

