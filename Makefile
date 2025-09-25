ROS_DISTRO := humble
CONTAINER_IMAGE_SITL := polibax/sitl_px4:$(ROS_DISTRO)
CONTAINER_NAME_SITL := sitl_px4
CONTAINER_IMAGE_BRIDGE := polibax/sitl_bridge:$(ROS_DISTRO)
CONTAINER_NAME_BRIDGE := sitl_bridge
CONTAINER_IMAGE_XRCE := polibax/sitl_xrce:$(ROS_DISTRO)
CONTAINER_NAME_XRCE := sitl_xrce
ROS_DOMAIN_ID := 33

PERCENT := %
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
WORK_DIR := /root/

.PHONY: run

default: help

#run: run-sitl run-xrce run-bridge # DEPRECATED

######################## RUN TARGETS #########################

run-sitl:
	@echo "Launching PX4 SITL simulation in Docker container..."
	@xhost +
	@docker run --rm --privileged --ipc host \
		--net host \
		--runtime nvidia --gpus all \
		-v $(ROOT_DIR)/scripts:/root/scripts \
		-v $(ROOT_DIR)/SITL_ws/PX4-sim-patches/r1_rover:/root/PX4-Autopilot/Tools/simulation/gz/models/r1_rover/ \
		-v $(ROOT_DIR)/SITL_ws/PX4-sim-patches/ours/matte.sdf:/root/PX4-Autopilot/Tools/simulation/gz/models/x500_depth/model.sdf \
		-v $(ROOT_DIR)/SITL_ws/PX4-sim-patches/default_world_arena.sdf:/root/PX4-Autopilot/Tools/simulation/gz/worlds/map.sdf \
      	-v $(ROOT_DIR)/SITL_ws/PX4-sim-patches/px4-rc.params:/root/PX4-Autopilot/ROMFS/px4fmu_common/init.d-posix/px4-rc.params \
		-v /dev:/dev \
		-v /tmp/.X11-unix/:/tmp/.X11-unix \
		-v ~/.Xauthority:/root/.Xauthority \
		-e XAUTHORITY=/root/.Xauthority \
		-e DISPLAY=$(DISPLAY) \
		-e ROS_DOMAIN_ID=$(ROS_DOMAIN_ID) \
		-w $(WORK_DIR)/scripts \
		--name $(CONTAINER_NAME_SITL) \
		$(CONTAINER_IMAGE_SITL) \
		bash -ci "./start_sim_depth.sh"

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
		-e ROS_DOMAIN_ID=$(ROS_DOMAIN_ID) \
		-w $(WORK_DIR)/scripts \
		--name $(CONTAINER_NAME_XRCE) \
		$(CONTAINER_IMAGE_XRCE) \
		bash -ci "MicroXRCEAgent udp4 -p 8888"


run-bridge:
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
		-e ROS_DOMAIN_ID=$(ROS_DOMAIN_ID) \
		-w $(WORK_DIR)/scripts \
		--name $(CONTAINER_NAME_BRIDGE) \
		$(CONTAINER_IMAGE_BRIDGE) \
		bash -ci "./start_ros2gz_bridge.sh"

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
		-v $(ROOT_DIR)/SITL_ws/PX4-sim-patches/default_world_arena.sdf:/root/PX4-Autopilot/Tools/simulation/gz/worlds/map.sdf \
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


####################### BUILD TARGETS #########################

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

######################## STOP TARGETS #########################

stop:
	@echo "Stopping all running containers..."
	-docker stop $(CONTAINER_NAME_SITL) || true
	-docker stop $(CONTAINER_NAME_XRCE) || true
	-docker stop $(CONTAINER_NAME_BRIDGE) || true
	@echo "All specified containers have been stopped."


stop-sitl:
	@echo "Stopping SITL container..."
	-docker stop $(CONTAINER_NAME_SITL) || true
	@echo "SITL container stopped."

stop-xrce:
	@echo "Stopping XRCE container..."
	-docker stop $(CONTAINER_NAME_XRCE) || true
	@echo "XRCE container stopped."

stop-bridge:
	@echo "Stopping Bridge container..."
	-docker stop $(CONTAINER_NAME_BRIDGE) || true
	@echo "Bridge container stopped."



######################## HELP TARGET #########################

help:
	@echo "Makefile commands:"
	@echo "--------------------------BUILD TARGETS--------------------------"
	@echo "  make build            Build all docker images (sitl, xrce, bridge)"
	@echo "  make build-sitl       Build only the sitl docker image"
	@echo "  make build-xrce       Build only the xrce docker image"
	@echo "  make build-bridge     Build only the bridge docker image"
	@echo "--------------------------RUN TARGETS--------------------------"
	@echo "  make run-sitl         Run only the sitl container"
	@echo "  make run-xrce         Run only the xrce container"
	@echo "  make run-bridge       Run only the bridge container"
	@echo "  make run-dev-sitl     Run only the sitl container in dev (interactive bash) mode"
	@echo "  make run-dev-xrce     Run only the xrce container in dev (interactive bash) mode"
	@echo "  make run-dev-bridge   Run only the bridge container in dev (interactive bash) mode"
	@echo "--------------------------STOP TARGETS--------------------------"
	@echo "  make stop             Stop all running containers"
	@echo "  make stop-sitl        Stop only the sitl container"
	@echo "  make stop-xrce        Stop only the xrce container"
	@echo "  make stop-bridge      Stop only the bridge container"
	@echo "--------------------------HELP TARGET--------------------------"
	@echo "  make help             Show this help message"
