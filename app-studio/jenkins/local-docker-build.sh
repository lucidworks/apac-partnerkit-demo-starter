#!/bin/bash
# Create a docker image and use it to build the project
set -exuo pipefail

TOP_DIR=$( cd "$(dirname "${BASH_SOURCE-$0}")/.."; /bin/pwd )
BUILDER_IMAGE=${1:-lucidworks-as-ee-builder}

cd "$TOP_DIR/jenkins"
docker build -t "$BUILDER_IMAGE" -f Dockerfile .
docker image list -q --no-trunc "$BUILDER_IMAGE"

cd "$TOP_DIR"
docker run -it --rm -v $PWD:$PWD -w $PWD \
  "$BUILDER_IMAGE" jenkins/build-inner.sh
