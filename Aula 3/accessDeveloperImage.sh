#!/bin/bash
# -v /usr/lib/nvidia-${NVIDIA_DRIVER_VERSION}:/usr/lib/nvidia-${NVIDIA_DRIVER_VERSION} \
# -e LD_LIBRARY_PATH=/usr/lib/nvidia-${NVIDIA_DRIVER_VERSION} \

docker run \
        -ti \
        --rm \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v $(pwd):/home/developer \
        --privileged \
        --device /dev/ttyUSB0 \
        --device /dev/ttyUSB1 \
        --device /dev/ttyUSB2 \
        --device /dev/ttyUSB3 \
        --device /dev/ttyUSB4 \
        --device /dev/ttyUSB5 \
        --device /dev/ttyUSB6 \
        --device /dev/ttyUSB7 \
        -v /dev/bus/usb:/dev/bus/usb \
        developer:base bash
