#ros2 run ros_gz_bridge parameter_bridge /x500_0/pose@tf2_msgs/msg/TFMessage[gz.msgs.Pose_V  --ros-args -r /x500_0/pose:=/tf

ros2 run ros_gz_bridge parameter_bridge /x500_0/pose@tf2_msgs/msg/TFMessage[gz.msgs.Pose_V  --ros-args -r /x500_0/pose:=/tf


# command to bridge tf between gazebo and ros2
#ros2 run ros_gz_bridge parameter_bridge /world/default/pose/info@tf2_msgs/msg/TFMessage[gz.msgs.Pose_V  --ros-args -r /world/default/pose/info:=/tf