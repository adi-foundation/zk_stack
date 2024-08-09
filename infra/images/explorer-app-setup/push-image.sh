#!/bin/sh

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <TAG> <REGISTRY>"
    exit 1
fi

TAG=$1
REGISTRY=$2

REPO_URL=https://github.com/matter-labs/block-explorer.git
BRANCH=main

docker build \
    --build-arg REPO_URL=$REPO_URL \
    --build-arg BRANCH=$BRANCH \
    --platform linux/amd64 \
    --tag $REGISTRY/block-explorer-app:$TAG . -f ./Dockerfile

docker push $REGISTRY/block-explorer-app:$TAG
