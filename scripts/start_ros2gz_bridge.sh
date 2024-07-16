#!/bin/bash

source /opt/ros/humble/setup.bash
# ros2 run ros_gz_image image_bridge /topic1 /topic2 / topic3 ....

ros2 run ros_gz_image image_bridge /camera /depth_camera