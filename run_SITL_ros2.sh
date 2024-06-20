#!/bin/bash
xhost +
docker run --rm -it --privileged --ipc host \
    --net host\
	--runtime nvidia --gpus all \
    -v ./scripts:/root/scripts \
    -v ./ros2_offboard:/root/ros2_offboard \
    -v ./px4_autopilot_ws:/root/px4_autopilot_ws \
	-v /dev:/dev \
	-v /tmp/.X11-unix/:/tmp/.X11-unix \
	-v ~/.Xauthority:/root/.Xauthority \
    -e XAUTHORITY=/root/.Xauthority \
    -e DISPLAY=$DISPLAY \
    -w /root \
    --name ros2_sitl \
    sitl_ros2:fuori bash 