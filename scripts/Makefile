.PHONY: all simulation dds gazebo_bridge

# SHELL := /bin/bash
# .SHELLFLAGS := -ec

all: simulation dds gazebo_bridge

simulation:
	@echo "Launching simulation..."
	bash ./start_sim_depth.sh &

dds:
	@echo "Starting DDS agent..."
	bash ./start_dds.sh &

gazebo_bridge:
	@echo "Starting ROS2Gazebo bridge..."
	bash -ci "./start_ros2gz_bridge.sh"