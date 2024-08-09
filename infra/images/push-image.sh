## Usage:
## sh push-image.sh matterlabs/block-explorer-api testing us-central1-docker.pkg.dev/zksync-413615/zksync
## It will pull matterlabs/block-explorer-api image, then it will rename it to block-explorer-api:testing
## The second argument is the version, and finally, it will push it to the desired registry, specified by the last arg.

#!/bin/sh

if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <SOURCE_IMAGE> <NEW_TAG> <TARGET_REGISTRY>"
    exit 1
fi

SOURCE_IMAGE=$1
NEW_TAG=$2
TARGET_REGISTRY=$3

docker pull $SOURCE_IMAGE

IMAGE_NAME=$(echo $SOURCE_IMAGE | cut -d'/' -f2 | cut -d':' -f1)

docker tag $SOURCE_IMAGE $TARGET_REGISTRY/$IMAGE_NAME:$NEW_TAG

docker push $TARGET_REGISTRY/$IMAGE_NAME:$NEW_TAG

echo "Image $TARGET_REGISTRY/$IMAGE_NAME:$NEW_TAG has been successfully pushed."
