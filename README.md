# PX4 SITL ROS 2
This repository contains all the necessary parts to build and run a docker image with SITL simulation on ROS2 leveraging XRCE to communicate with PX4. <br>
The repository contains also a ROS2 node for the offboard control, clone this repositoiry using --recursive option

## build image

`cd docker_ws` <br>
`./build_SITL_ros2.sh`


## Run container
on the root of the repository folder run:<br>
`./run_SITL_ros2.sh` this run scripts may need additional volumes to be mapped in the long run.


## Run simulation
Inside the repo in px4_autopilot_ws in the container run:<br>
`../../scripts/start_sim.sh`
In another terminal inside the container opened using **exec_SITL_ros2.sh** run XRCE:<br>
`/root/scripts/start_dds.sh`
## Offboard mode
### Build packages
Inside the container in the /root/ros2_offboard folder there is a ros2 workspace, build it:
`source /opt/ros/humble/setup.bash`<br>
`colcon build --symlink-install`<br>

### Go Offboard
Open Qground Control in your host machine (necessary to use the drone as it wants a connection to the ground control station)<br>
Source the ros2 workspace:<br>
`cd /root/ros2_offboard`<br>
`source install/setup.bash`<br>
Go OffBoard:<br>
`ros2 run px4_ros_com offboard_control`<br>

## Multi agent

will document this part as soon as a stable release is reached