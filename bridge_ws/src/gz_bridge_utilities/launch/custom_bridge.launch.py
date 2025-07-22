from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    
    namespace = '/matte'
    
    return LaunchDescription([
 
        Node(
            package='ros_gz_image',
            namespace='',
            executable='image_bridge',
            name='bridge_images',
            arguments=[namespace + "/camera",
                       namespace + "/depth_camera",]

        ),

        Node(
            package='ros_gz_bridge',
            namespace='',
            executable='parameter_bridge',
            name='bridge_poses',
            arguments=["/model/x500_depth_0/pose@geometry_msgs/msg/PoseArray[gz.msgs.Pose_V","--ros-args",
                          "-r", "/model/x500_depth_0/pose:=/gazebo/model/state",]
        ),

        Node(
            package='ros_gz_bridge',
            namespace='',
            executable='parameter_bridge',
            name='bridge_camera_info',
            arguments=[namespace+"/camera_info@sensor_msgs/msg/CameraInfo[gz.msgs.CameraInfo","--ros-args"]
        ),




        Node(
            package='ros_gz_bridge',
            namespace='',
            executable='parameter_bridge',
            name='bridge_points',
            arguments=[namespace+"/depth_camera/points@sensor_msgs/msg/PointCloud2[gz.msgs.PointCloudPacked",
                       "--ros-args",
                          "-r", namespace+"/depth_camera/points:=" + namespace+"/depth_camera/points",]
        ),

        Node(
            package='ros_gz_bridge',
            namespace='',
            executable='parameter_bridge',
            name='bridge_tfs',
            arguments=["/model/x500_depth_0/pose@tf2_msgs/msg/TFMessage[gz.msgs.Pose_V","--ros-args",
                          "-r", "/model/x500_depth_0/pose:=/tf"]
        ),

        Node(
            package='tf2_ros',
            namespace = '',
            executable='static_transform_publisher',
            arguments= ["0.01233", "-0.03", "0.01878", "0", "0", "0", "x500_depth_0/camera_link", "x500_depth_0/camera_link/StereoOV7251"]
        ),

        Node(
            package='gz_bridge_utilities',
            namespace='',
            executable='bridge_node',
            name='tf_bridge_node',
            # parameters=[{'tf_pub_rate': 100.0}],
            # remappings=[
            #     ('/tf', '/matte/tf'),
            #     ('/gazebo/model/state', '/model/x500_depth_0/pose')
            # ]
        ),
        
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
