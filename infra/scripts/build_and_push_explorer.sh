#!/bin/sh
# wip, right now it only works if the script is run inside the explorer repo

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <TAG>"
    exit 1
fi

TAG=$1

docker build --platform linux/amd64 --tag us-central1-docker.pkg.dev/zksync-413615/zksync/block-explorer-worker:$TAG . -f ./packages/worker/Dockerfile

docker build --platform linux/amd64 --tag us-central1-docker.pkg.dev/zksync-413615/zksync/block-explorer-api:$TAG . -f  ./packages/api/Dockerfile

docker build --platform linux/amd64 --tag us-central1-docker.pkg.dev/zksync-413615/zksync/block-explorer-app:$TAG . -f  ./packages/app/Dockerfile

docker build --platform linux/amd64 --tag us-central1-docker.pkg.dev/zksync-413615/zksync/block-explorer-data-fetcher:$TAG . -f  ./packages/data-fetcher/Dockerfile

docker push us-central1-docker.pkg.dev/zksync-413615/zksync/block-explorer-data-fetcher:$TAG
docker push us-central1-docker.pkg.dev/zksync-413615/zksync/block-explorer-worker:$TAG
docker push us-central1-docker.pkg.dev/zksync-413615/zksync/block-explorer-app:$TAG
docker push us-central1-docker.pkg.dev/zksync-413615/zksync/block-explorer-api:$TAG
