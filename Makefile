CONTAINER_IMAGE_SITL := polibax/sitl_px4:v1.15
CONTAINER_NAME_SITL := sitl_px4
CONTAINER_IMAGE_BRIDGE := polibax/sitl_bridge:jazzy
CONTAINER_NAME_BRIDGE := sitl_bridge
CONTAINER_IMAGE_XRCE := polibax/sitl_xrce:jazzy
CONTAINER_NAME_XRCE := sitl_xrce

PERCENT := %
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
WORK_DIR := /root/

.PHONY: run

default: run


run-xrce:
	@echo "Launching PX4 SITL XRCE simulation in Docker container..."
	@xhost +
	@docker run --rm -it --privileged --ipc host \
		--net host \
		--runtime nvidia --gpus all \
		-v /dev:/dev \
		-v /tmp/.X11-unix/:/tmp/.X11-unix \
		-v ~/.Xauthority:/root/.Xauthority \
		-e XAUTHORITY=/root/.Xauthority \
		-e DISPLAY=$(DISPLAY) \
		-w $(WORK_DIR)/scripts \
		--name $(CONTAINER_NAME_XRCE) \
		$(CONTAINER_IMAGE_XRCE) \
		bash -ci "MicroXRCEAgent udp4 -p 8888"



run-dev-bridge:
	@echo "Launching PX4 SITL Bridge simulation in Docker container..."
	@xhost +
	@docker run --rm -it --privileged --ipc host \
		--net host \
		--runtime nvidia --gpus all \
		-v $(ROOT_DIR)/scripts:/root/scripts \
		-v $(ROOT_DIR)/bridge_ws:/root/bridge_ws \
		-v /dev:/dev \
		-v /tmp/.X11-unix/:/tmp/.X11-unix \
		-v ~/.Xauthority:/root/.Xauthority \
		-e XAUTHORITY=/root/.Xauthority \
		-e DISPLAY=$(DISPLAY) \
		-w $(WORK_DIR)/scripts \
		--name $(CONTAINER_NAME_BRIDGE) \
		$(CONTAINER_IMAGE_BRIDGE) \
		bash

run-dev-sitl:
	@echo "Launching PX4 SITL simulation in Docker container..."
	@xhost +
	@docker run --rm -it --privileged --ipc host \
		--net host \
		--runtime nvidia --gpus all \
		-v $(ROOT_DIR)/scripts:/root/scripts \
		-v $(ROOT_DIR)/SITL_ws/PX4-sim-patches/r1_rover:/root/PX4-Autopilot/Tools/simulation/gz/models/r1_rover/ \
		-v $(ROOT_DIR)/SITL_ws/PX4-sim-patches/ours/matte.sdf:/root/PX4-Autopilot/Tools/simulation/gz/models/x500_depth/model.sdf \
		-v $(ROOT_DIR)/SITL_ws/PX4-sim-patches/default_world_arena.sdf:/root/PX4-Autopilot/Tools/simulation/gz/worlds/default.sdf \
		-v /dev:/dev \
		-v /tmp/.X11-unix/:/tmp/.X11-unix \
		-v ~/.Xauthority:/root/.Xauthority \
		-e XAUTHORITY=/root/.Xauthority \
		-e DISPLAY=$(DISPLAY) \
		-w $(WORK_DIR)/scripts \
		--name $(CONTAINER_NAME_SITL) \
		$(CONTAINER_IMAGE_SITL) \
		bash 



run-dev-xrce:
	@echo "Launching PX4 SITL XRCE simulation in Docker container..."
	@xhost +
	@docker run --rm -it --privileged --ipc host \
		--net host \
		--runtime nvidia --gpus all \
		-v $(ROOT_DIR)/scripts:/root/scripts \
		-v /dev:/dev \
		-v /tmp/.X11-unix/:/tmp/.X11-unix \
		-v ~/.Xauthority:/root/.Xauthority \
		-e XAUTHORITY=/root/.Xauthority \
		-e DISPLAY=$(DISPLAY) \
		-w $(WORK_DIR)/scripts \
		--name $(CONTAINER_NAME_XRCE) \
		$(CONTAINER_IMAGE_XRCE) \
		bash 




build-sitl:
	@echo "Building PX4 SITL Docker container..."
	@docker build -t $(CONTAINER_IMAGE_SITL) -f $(ROOT_DIR)/docker_ws/Dockerfile.SITL $(ROOT_DIR)


build-xrce:
	@echo "Building PX4 SITL XRCE Docker container..."
	@docker build -t $(CONTAINER_IMAGE_XRCE) -f $(ROOT_DIR)/docker_ws/Dockerfile.SITL_xrce $(ROOT_DIR)


build-bridge:
	@echo "Building PX4 SITL Bridge Docker container..."
	@docker build -t $(CONTAINER_IMAGE_BRIDGE) -f $(ROOT_DIR)/docker_ws/Dockerfile.SITL_bridge $(ROOT_DIR)


build: build-bridge build-sitl build-xrce
	@echo "All build targets executed successfully."