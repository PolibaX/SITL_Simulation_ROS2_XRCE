from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    
    namespace = '/matte'
    
    return LaunchDescription([
 
        Node(
            package="ros_gz_bridge",
            namespace='',
            executable="parameter_bridge",
            name='clock_bridge',
            parameters=[
                {"bridge_names": ["clock_bridge"]},
                {"bridges.clock_bridge.ros_topic_name": "/clock"},
                {"bridges.clock_bridge.gz_topic_name": "/clock"},
                {"bridges.clock_bridge.ros_type_name": "rosgraph_msgs/msg/Clock"},
                {"bridges.clock_bridge.gz_type_name": "gz.msgs.Clock"},
                {"bridges.clock_bridge.direction": "GZ_TO_ROS"},
                {"bridges.clock_bridge.lazy": False},
                {"bridges.clock_bridge.qos_profile": "CLOCK"},
                {"use_sim_time": True}
            ],
        ),
 
        Node(
            package='ros_gz_image',
            namespace='',
            executable='image_bridge',
            name='bridge_images',
            parameters=[{"use_sim_time": True}],
            arguments=[namespace + "/camera",
                       namespace + "/depth_camera",]

        ),
        
        Node(
            package='ros_gz_bridge',
            namespace='',
            executable='parameter_bridge',
            name='bridge_from_yaml',
            parameters=[{"use_sim_time": True,
                         "config_file": "/root/bridge_ws/src/gz_bridge_utilities/config/param_bridge.yaml"}],
        ),

        # Node(
        #     package='ros_gz_bridge',
        #     namespace='',
        #     executable='parameter_bridge',
        #     name='bridge_poses',
        #     parameters=[{"use_sim_time": True}],
        #     arguments=["/model/x500_depth_0/pose@geometry_msgs/msg/PoseArray[gz.msgs.Pose_V","--ros-args",
        #                   "-r", "/model/x500_depth_0/pose:=/gazebo/model/state",]
        # ),

        # Node(
        #     package='ros_gz_bridge',
        #     namespace='',
        #     executable='parameter_bridge',
        #     name='bridge_camera_info',
        #     parameters=[{"use_sim_time": True}],
        #     arguments=[namespace+"/camera_info@sensor_msgs/msg/CameraInfo[gz.msgs.CameraInfo","--ros-args"]
        # ),




        # Node(
        #     package='ros_gz_bridge',
        #     namespace='',
        #     executable='parameter_bridge',
        #     name='bridge_points',
        #     parameters=[{"use_sim_time": True}],
        #     arguments=[namespace+"/depth_camera/points@sensor_msgs/msg/PointCloud2[gz.msgs.PointCloudPacked",
        #                "--ros-args",
        #                   "-r", namespace+"/depth_camera/points:=" + namespace+"/depth_camera/points",]
        # ),

        # Node(
        #     package='ros_gz_bridge',
        #     namespace='',
        #     executable='parameter_bridge',
        #     name='bridge_tfs',
        #     parameters=[{"use_sim_time": True}],
        #     arguments=["/model/x500_depth_0/pose@tf2_msgs/msg/TFMessage[gz.msgs.Pose_V","--ros-args",
        #                   "-r", "/model/x500_depth_0/pose:=/tf"]
        # ),

        Node(
            package='tf2_ros',
            namespace = '',
            executable='static_transform_publisher',
            parameters=[{"use_sim_time": True}],
            arguments= ["--x", "0.01233", "--y", "-0.03", "--z", "0.01878", 
                        "--yaw", "0", "--pitch", "0", "--roll", "0", 
                        "--frame-id", "x500_depth_0/camera_link", "--child-frame-id", "x500_depth_0/camera_link/StereoOV7251"]
        ),
        
        # Node( --> removed because it is done by relay_simulation
        #     package='tf2_ros',
        #     namespace = '',
        #     executable='static_transform_publisher',
        #     parameters=[{"use_sim_time": True}],
        #     arguments= [
        #         "--x", "0.", "--y", "0.", "--z", "0.", 
        #         "--yaw", "0.", "--pitch", "0.", "--roll", "3.14159", 
        #         "--frame-id", "default", "--child-frame-id", namespace+"/odom_px4_FRD"]
        # ),

        # Node(
        #     package='gz_bridge_utilities',
        #     namespace='',
        #     executable='bridge_node',
        #     name='tf_bridge_node',
        #     parameters=[{"use_sim_time": True}],
        #     # remappings=[
        #     #     ('/tf', '/matte/tf'),
        #     #     ('/gazebo/model/state', '/model/x500_depth_0/pose')
        #     # ]
        # ),
        
        # Node(
        #     package='tf2_ros',
        #     namespace = 'scan_to_map',
        #     executable='static_transform_publisher',
        #     arguments= ["0", "0", "0", "0", "0", "0", "camera_point_cloud", "x500_depth_0/OakD-Lite/base_link/StereoOV7251"]
        # ),

        # Node(
        #     package='tf2_ros',
        #     namespace = 'attach_point_cloud',
        #     executable='static_transform_publisher',
        #     arguments= ["0.15", "0", "-0.15", "0", "0.349", "0", "x500_depth_0/OakD-Lite/base_link", "camera_point_cloud"]
        # ),

        # Node(
        #     package='depth_image_proc',
        #     #plugin='depth_image_proc::PointCloudXyzNode',
        #     executable='point_cloud_xyz_node',
        #     name='point_cloud_xyz',
        #     remappings=[('image_rect', '/depth_camera'),
        #                 ('camera_info', '/camera_info'),
        #                  ('/points', '/im_proc/points'),
        #                 ]
        # )
        
    ])
