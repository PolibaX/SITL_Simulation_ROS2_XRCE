CONTAINER_IMAGE := sitl_ros2:v1.15
CONTAINER_NAME := sitl-px4
PERCENT := %
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
WORK_DIR := /root/

.PHONY: run

default: run

run:
	@echo "Launching PX4 SITL simulation in Docker container..."
	@xhost +
	@docker run --rm -it --privileged --ipc host \
		--net host \
		--runtime nvidia --gpus all \
		-v $(ROOT_DIR)/scripts:/root/scripts \
		-v $(ROOT_DIR)/bridge_ws:/root/bridge_ws \
		-v $(ROOT_DIR)/ros2_offboard_ws:/root/ros2_offboard \
		-v $(ROOT_DIR)/PX4-sim-patches/r1_rover:/root/PX4-Autopilot/Tools/simulation/gz/models/r1_rover/ \
		-v $(ROOT_DIR)/PX4-sim-patches/x500_depth_model.sdf:/root/PX4-Autopilot/Tools/simulation/gz/models/x500_depth/model.sdf \
		-v $(ROOT_DIR)/PX4-sim-patches/default_world_arena.sdf:/root/PX4-Autopilot/Tools/simulation/gz/worlds/default.sdf \
		-v $(ROOT_DIR)/fastDDS_config:/root/fastDDS_config \
		-v /dev:/dev \
		-v /tmp/.X11-unix/:/tmp/.X11-unix \
		-v ~/.Xauthority:/root/.Xauthority \
		-e XAUTHORITY=/root/.Xauthority \
		-e DISPLAY=$(DISPLAY) \
		-w $(WORK_DIR)/scripts \
		--name $(CONTAINER_NAME) \
		$(CONTAINER_IMAGE) \
		bash -ci "make all"

run-dev:
	@echo "Launching PX4 SITL simulation in Docker container..."
	@xhost +
	@docker run --rm -it --privileged --ipc host \
		--net host \
		--runtime nvidia --gpus all \
		-v $(ROOT_DIR)/scripts:/root/scripts \
		-v $(ROOT_DIR)/bridge_ws:/root/bridge_ws \
		-v $(ROOT_DIR)/ros2_offboard_ws:/root/ros2_offboard \
		-v $(ROOT_DIR)/PX4-sim-patches/r1_rover:/root/PX4-Autopilot/Tools/simulation/gz/models/r1_rover/ \
		-v $(ROOT_DIR)/PX4-sim-patches/x500_depth_model.sdf:/root/PX4-Autopilot/Tools/simulation/gz/models/x500_depth/model.sdf \
		-v $(ROOT_DIR)/PX4-sim-patches/default_world_arena.sdf:/root/PX4-Autopilot/Tools/simulation/gz/worlds/default.sdf \
		-v $(ROOT_DIR)/fastDDS_config:/root/fastDDS_config \
		-v /dev:/dev \
		-v /tmp/.X11-unix/:/tmp/.X11-unix \
		-v ~/.Xauthority:/root/.Xauthority \
		-e XAUTHORITY=/root/.Xauthority \
		-e DISPLAY=$(DISPLAY) \
		-w $(WORK_DIR)/scripts \
		--name $(CONTAINER_NAME) \
		$(CONTAINER_IMAGE) \
		bash

run-experimental-nunzio:
	@echo "Launching PX4 SITL simulation in Docker container with experimental model patch..."
	@xhost +
	@docker run --rm -it --privileged --ipc host \
		--net host \
		--runtime nvidia --gpus all \
		-v $(ROOT_DIR)/scripts:/root/scripts \
		-v $(ROOT_DIR)/bridge_ws:/root/bridge_ws \
		-v $(ROOT_DIR)/ros2_offboard_ws:/root/ros2_offboard \
		-v $(ROOT_DIR)/PX4-sim-patches/r1_rover:/root/PX4-Autopilot/Tools/simulation/gz/models/r1_rover/ \
		-v $(ROOT_DIR)/PX4-sim-patches/ours/matte.sdf:/root/PX4-Autopilot/Tools/simulation/gz/models/x500_depth/model.sdf \
		-v $(ROOT_DIR)/PX4-sim-patches/default_world_arena.sdf:/root/PX4-Autopilot/Tools/simulation/gz/worlds/default.sdf \
		-v $(ROOT_DIR)/fastDDS_config:/root/fastDDS_config \
		-v /dev:/dev \
		-v /tmp/.X11-unix/:/tmp/.X11-unix \
		-v ~/.Xauthority:/root/.Xauthority \
		-e XAUTHORITY=/root/.Xauthority \
		-e DISPLAY=$(DISPLAY) \
		-w $(WORK_DIR)/scripts \
		--name $(CONTAINER_NAME) \
		$(CONTAINER_IMAGE) \
		bash