#!/bin/bash
export PX4_UXRCE_DDS_NS=matte
export PX4_GZ_MODEL_POSE="2. 5. 0.15 0. 0. 0."
export PX4_GZ_WORLD=map
# PX4_GZ_WORLD=<custom world in PX4-Autopilot/Tools/simulation/gz/worlds> make px4_sitl gz_x500_depth
# PX4_GZ_MODEL_POSE="5. 2. 0. 0. 0. 0." 

cd /root/PX4-Autopilot
make px4_sitl gz_x500_depth
