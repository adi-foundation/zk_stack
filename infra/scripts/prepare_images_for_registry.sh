#!/bin/bash

organization="matterlabs"

prover_images=(
    "witness-vector-generator"
    "witness-generator"
    "prover-gpu-fri"
    "prover-fri-gateway"
    "proof-fri-gpu-compressor"
)
prover_tag="0.24.2-v16.1.0"

server_image="server-v2"
server_tag="v24.12.0"

prefix="us-central1-docker.pkg.dev/zksync-413615/zksync"

register_image_in_our_registry() {
    local image="$1"
    local tag="$2"

    local old_image="${organization}/${image}:${tag}"

    echo "\033[1mPulling image: $old_image\033[0m"
    docker pull "$old_image"

    local new_image="${prefix}/${image}:${tag}"

    echo "\033[1mTagging image: $old_image as $new_image\033[0m"
    docker tag "$old_image" "$new_image"


    echo "\033[1mPushing image: $new_image\033[0m"
    docker push "$new_image"
}

for i in "${!prover_images[@]}"; do
    image="${prover_images[$i]}"
    register_image_in_our_registry "$image" "$prover_tag"
done

register_image_in_our_registry "$server_image" "$server_tag"

echo "\033[1mAll images have been processed.\033[0m"
