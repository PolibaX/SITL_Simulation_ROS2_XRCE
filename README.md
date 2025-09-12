# PX4 SITL ROS 2
This repository contains all the necessary parts to build and run a docker image with SITL simulation on ROS2 leveraging XRCE to communicate with PX4.

## Overview
This repository contains the 3 main components of the simulation:
- PX4 Firmware (with Gazebo SITL)
- XRCE-DDS-Agent to communicate with the simulated PX4
- BRIDGE to communicate the Gazebo simulation topics to ROS2 topics

## Simple workflow

### build images
Build the tree docker images with:
`make build` 

### Run simulation
Run the full simulation with:
`docker compose up`

## Makefile commands (debug and development purposes)
### Build commands
- `make build` : Build all the docker images
- `make build-sitl` : Build the PX4 SITL docker image
- `make build-xrce` : Build the XRCE-DDS-Agent docker image
- `make build-bridge` : Build the ROS2 bridge docker image

### Run commands:
- `make run-sitl` : Run only the PX4 SITL docker container
- `make run-xrce` : Run only the XRCE-DDS-Agent docker container
- `make run-bridge` : Run only the ROS2 bridge docker container
- `make run-dev-sitl` : Run only the PX4 SITL docker container in dev (interactive bash) mode
- `make run-dev-xrce` : Run only the XRCE-DDS-Agent docker container in dev (interactive bash) mode
- `make run-dev-bridge` : Run only the ROS2 bridge docker container in dev (interactive bash) mode

### Stop commands:
- `make stop` : Stop all running containers
- `make stop-sitl` : Stop only the PX4 SITL docker container
- `make stop-xrce` : Stop only the XRCE-DDS-Agent docker container
- `make stop-bridge` : Stop only the ROS2 bridge docker container

### Help command:
- `make help` : Show the help message with all the available commands

## Configurations

### Simulation assets and configuration
TO BE UPDATED

### ROS2 bridge configuration
TO BE UPDATED

### PX4 parameters configuration

## for the developers
Remember to update the makefile help section when adding new commands and keep the readme consistent !!! 