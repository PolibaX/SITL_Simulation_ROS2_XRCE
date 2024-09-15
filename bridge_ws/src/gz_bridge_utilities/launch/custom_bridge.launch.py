from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='ros_gz_bridge',
            namespace='',
            executable='parameter_bridge',
            name='sim',
            arguments=[
                "/world/default/pose/info@geometry_msgs/msg/PoseArray[gz.msgs.Pose_V",
                "--ros-args -r /world/default/pose/info:=/gazebo/model/state",
            ],
        ),
        # Node(
        #     package='turtlesim',
        #     executable='mimic',
        #     name='mimic',
        #     remappings=[
        #         ('/input/pose', '/turtlesim1/turtle1/pose'),
        #         ('/output/cmd_vel', '/turtlesim2/turtle1/cmd_vel'),
        #     ]
        # )
    ])