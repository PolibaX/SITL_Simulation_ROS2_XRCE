#!/bin/bash
ros2 run ros_gz_bridge parameter_bridge /world/default/pose/info@geometry_msgs/msg/PoseArray[gz.msgs.Pose_V  --ros-args -r /world/default/pose/info:=/gazebo/model/state
#ros2 run ros_gz_bridge parameter_bridge /world/default/pose/info@geometry_msgs/msg/Pose[gz.msgs.Pose_V  --ros-args -r /world/default/pose/info:=/gazebo/model/state