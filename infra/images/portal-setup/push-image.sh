#!/bin/sh

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <TAG> <REGISTRY>"
    exit 1
fi

TAG=$1
REGISTRY=$2

REPO_URL=https://github.com/lambdaclass/dapp-portal.git
BRANCH=feat_automatic_bt_fetch

docker build \
    --build-arg REPO_URL=$REPO_URL \
    --build-arg BRANCH=$BRANCH \
    --platform linux/amd64 \
    --tag $REGISTRY/portal:$TAG . -f ./Dockerfile

docker push $REGISTRY/portal:$TAG
