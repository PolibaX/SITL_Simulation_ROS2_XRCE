from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='ros_gz_bridge',
            namespace='',
            executable='parameter_bridge',
            name='bridge_poses',
            arguments=[
                "/world/default/pose/info@geometry_msgs/msg/PoseArray[gz.msgs.Pose_V",
                "--ros-args -r /world/default/pose/info:=/gazebo/model/state",
            ],
        ),
        Node(
            package='ros_gz_bridge',
            namespace='',
            executable='parameter_bridge',
            name='bridge_tfs',
            arguments=[
                "/world/default/pose/info@tf2_msgs/msg/TFMessage[gz.msgs.Pose_V",
                "--ros-args -r /world/default/pose/info:=/tf",
            ],
        ),

        Node(
            package='ros_gz_image',
            namespace='',
            executable='image_bridge',
            name='bridge_images',
            arguments=["/camera",
                       "/depth_camera",]

        )
        
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