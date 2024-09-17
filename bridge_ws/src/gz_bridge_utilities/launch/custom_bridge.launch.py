from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
 
        # Node(
        #     package='ros_gz_image',
        #     namespace='',
        #     executable='image_bridge',
        #     name='bridge_images',
        #     arguments=["/camera",
        #             #    "/camera_info",
        #                "/depth_camera",]

        # ),

        Node(
            package='ros_gz_bridge',
            namespace='',
            executable='parameter_bridge',
            name='bridge_poses',
            arguments=["/world/default/pose/info@geometry_msgs/msg/PoseArray[gz.msgs.Pose_V","--ros-args",
                          "-r", "/world/default/pose/info:=/gazebo/model/state",]
        ),

        # Node(
        #     package='ros_gz_bridge',
        #     namespace='',
        #     executable='parameter_bridge',
        #     name='bridge_camera_info',
        #     arguments=["/depth_camera/points@sensor_msgs/msg/PointCloud2[gz.msgs.PointCloudPacked",
        #                "--ros-args",
        #                   "-r", "/depth_camera/points:=/points",]
        # ),

        # Node(
        #     package='ros_gz_bridge',
        #     namespace='',
        #     executable='parameter_bridge',
        #     name='bridge_tfs',
        #     arguments=["/model/x500_depth_0/pose@tf2_msgs/msg/TFMessage[gz.msgs.Pose_V","--ros-args",
        #                   "-r", "/model/x500_depth_0/pose:=/tf",]
        # ),

        # Node(
        #     package='depth_image_proc',
        #     #plugin='depth_image_proc::PointCloudXyzNode',
        #     executable='point_cloud_xyz_node',
        #     name='point_cloud_xyz',
        #     remappings=[('image_rect', '/depth_camera'),
        #                 ('camera_info', '/camera_info'),
        #                 # ('image', '/depth_camera')
        #                 ]
        # )
        
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