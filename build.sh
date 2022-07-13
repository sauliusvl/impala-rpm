#!/bin/bash

set -euo pipefail

BUILDER_IMAGE=impala-builder:$(git rev-parse --short HEAD)

docker build -t ${BUILDER_IMAGE} buildenv/

docker run --ulimit nofile=64000 --rm --name impala-rpm-builder -it \
 -v $(pwd)/impala:/impala \
 -v $(pwd)/rpm:/rpm \
 -v $(pwd)/target:/target \
 -v /tmp/m2_cache:/root/.m2 \
 ${BUILDER_IMAGE} bash /rpm/build.sh
