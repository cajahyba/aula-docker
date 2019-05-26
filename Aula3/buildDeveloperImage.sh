#!/bin/bash

echo "Building base docker image..."

if ! docker build \
              --build-arg HOST_UID=$(id -u) \
              --build-arg HOST_GID=$(id -g) \
              -t developer:base .; then
    echo "ERROR: failed building base docker image"
    exit 1
fi

# docker commit $(docker ps -l -q) developer:base
# docker commit --change "Final Developer Image" $(docker ps -l -q) developer:sdk