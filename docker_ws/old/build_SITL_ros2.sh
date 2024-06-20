#!/bin/bash

# clone the PX4 repo (there is a reason why this is not in the Dockerfile - login required)

git clone https://github.com/PX4/PX4-Autopilot.git --recursive

docker build --rm -t sitl_ros2:latest -f Dockerfile.ros2 .