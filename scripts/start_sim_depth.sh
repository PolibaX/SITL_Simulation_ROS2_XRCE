#!/bin/bash
export PX4_UXRCE_DDS_NS=chotto
cd /root/PX4-Autopilot
# PX4_GZ_WORLD=<custom world in PX4-Autopilot/Tools/simulation/gz/worlds> make px4_sitl gz_x500_depth
# PX4_GZ_MODEL_POSE="5. 2. 0. 0. 0. 0." 
export PX4_GZ_MODEL_POSE="2. 5. 0. 0. 0. 0."
make px4_sitl gz_x500_depth
