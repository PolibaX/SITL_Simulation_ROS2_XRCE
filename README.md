# WARNING DOCS UNDER DEVELOPMENT AND INCONSISTENT 

PLEASE CONTACT ME IF YOU EXPERIENCE ANY ISSUES

# PX4 SITL ROS 2
This repository contains all the necessary parts to build and run a docker image with SITL simulation on ROS2 leveraging XRCE to communicate with PX4.

## build image

`cd docker_ws` <br>
`./build_SITL_ros2.sh`


## Run container
on the root of the repository folder run:<br>
`./run_SITL_ros2.sh` this run scripts may need additional volumes to be mapped in the long run.


## Run simulation
Inside the container run:<br>
`./scripts/start_sim_depth.sh` <br>
In another terminal inside the container opened using **exec_SITL_ros2.sh** run XRCE:<br>
`./scripts/start_dds.sh` <br>

## Run bridges (camera, depth camera, point cloud, tfs)

Inside the container go to ws_bridge folder, build with colcon build, source install/setup.bash and then run: <br>
`ros2 launch gz_bridge_utilities custom_bridge.launch.py` <br>

## result

These steps will give you a running simulation with px4 and X500v2 + depth camera + point clouds bridged on ros2