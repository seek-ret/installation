#! /bin/bash

TARGET_CONTAINER=$1
ENV_FILE=$2
CLOUD_PROVIDER=$3

SNIFFER_CONTAINER="gcr.io/seekret/sniffer:2"

function get_image_for_container {
    container=$1
    image=$(docker ps | grep ${container} | stdbuf -o0 awk -F " " '{print $2}' | awk -F ":" '{print $1}')
    echo ${image}
}

if [ -z ${TARGET_CONTAINER} ]; then 
    echo "Must specify target container to sniff"
    exit 1
fi

if [ -z ${ENV_FILE} ]; then 
    echo "Must specify env file"
    exit 2
fi

if [ "${CLOUD_PROVIDER}" == "aws" ]; then
    SNIFFER_CONTAINER="${CONTAINER}-${CLOUD_PROVIDER}"
fi

DOCKER_IMAGE="$(get_image_for_container ${TARGET_CONTAINER})"


docker run -d --rm \
    --net container:${TARGET_CONTAINER} \
    --env-file ${ENV_FILE} \
    -e "PREFIX=service-${DOCKER_IMAGE}_" \
    --log-driver json-file \
    --log-opt max-size=10m \
    --log-opt max-file=5 \
    ${SNIFFER_CONTAINER}

