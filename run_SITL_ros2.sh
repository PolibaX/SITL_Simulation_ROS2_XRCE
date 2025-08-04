#!/bin/bash
xhost +
docker run --rm -it --privileged --ipc host \
    --net host \
	-v /dev:/dev \
    --device /dev/dri:/dev/dri \
	--runtime nvidia --gpus all \
    -v ./scripts:/root/scripts \
    -v ./bridge_ws:/root/bridge_ws \
    -v ./ros2_offboard_ws:/root/ros2_offboard \
    -v ./SITL_ws/PX4-sim-patches/r1_rover:/root/PX4-Autopilot/Tools/simulation/gz/models/r1_rover/ \
    -v ./SITL_ws/PX4-sim-patches/ours/matte.sdf:/root/PX4-Autopilot/Tools/simulation/gz/models/x500_depth/model.sdf \
    -v ./SITL_ws/PX4-sim-patches/default_world_arena.sdf:/root/PX4-Autopilot/Tools/simulation/gz/worlds/map.sdf \
    -v ./SITL_ws/PX4-sim-patches/px4-rc.params:/root/PX4-Autopilot/ROMFS/px4fmu_common/init.d-posix/px4-rc.params \
    -v ./fastDDS_config:/root/fastDDS_config \
	-v /tmp/.X11-unix/:/tmp/.X11-unix \
	-v ~/.Xauthority:/root/.Xauthority \
    -e XAUTHORITY=/root/.Xauthority \
    -e DISPLAY=$DISPLAY \
    -w /root \
    --name ros2_sitlv1.15 \
    polibax/sitl_px4:jazzy bash 

