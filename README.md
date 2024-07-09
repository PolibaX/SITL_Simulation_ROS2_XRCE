# PX4 SITL ROS 2
This repository contains all the necessary parts to build and run a docker image with SITL simulation on ROS2 leveraging XRCE to communicate with PX4. <br>
The repository contains also a ROS2 node for the offboard control

## build image

`cd docker_ws`
`./build_SITL_ros2.sh`

## build PX4 (necessary on the first time)
In the first launch px4 needs to be built.

### Run container
on the root of the repository folder run:<br>
`./run_SITL_ros2.sh`

### Inside the container
Go in px4_autopilot_ws:<br>
`cd px_autopilot_ws`<br>
Clone the repository:<br>
`git clone https://github.com/PX4/PX4-Autopilot.git --recursive`<br>
Go in the repo and build SITL:<br>
`cd PX4-Autopilot`<br>
`make px4_sitl`<br>

## Run simulation
Inside the repo in px4_autopilot_ws in the container run:<br>
`../../scripts/start_sim.sh`
In another terminal inside the container opened using **exec_SITL_ros2.sh** run XRCE:<br>
`/root/scripts/start_dds.sh`
## Offboard mode

### Go Offboard
Open Qground Control (necessary to use the drone as it wants a connection to the ground control station)<br>
Source the ros2 workspace:<br>
`cd /root/ros2_offboard`<br>
`source install/setup.bash`<br>
Go OffBoard:<br>
`ros2 run px4_ros_com offboard_control`<br>

