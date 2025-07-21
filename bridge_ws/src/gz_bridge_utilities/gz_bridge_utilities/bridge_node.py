import rclpy
from rclpy.node import Node
from rclpy.publisher import Publisher
from rclpy.time import Time
from tf2_ros import StaticTransformBroadcaster, TransformStamped
import numpy as np
from scipy.spatial.transform import Rotation as R

class TFBridgeNode(Node):
    def __init__(self, tf_pub_rate=100.):
        super().__init__('tf_bridge_node')
        
        """
            Takes the place of the ZED SDK node on the xavier.
        """

        self.tf_pub_rate = tf_pub_rate
        self.baselink_frame = 'x500_depth_0/OakD-Lite/base_link'
        self.baselink_pose = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]  # Will be updated with the latest pose from the TF messages
        self.odom_to_baselink_tf_msg = TransformStamped()
        self.world_to_odom_init_offset = [5.0, 2.0, 0.0]  # Initial offset for world to odom transform

        self.namespace = 'matte'
        self.world_frame = 'map'
        self.odom_frame = self.namespace + '/odom'
        self.FRD_px4_odom_frame = self.namespace + '/FRD_px4_odom'
        
        self.create_subscription(
            TransformStamped,
            self.namespace + '/tf',
            self.handle_tfs,
            10
        )
        
        self.create_timer(1.0 / self.tf_pub_rate, self.publish_tf)
        
        self.tf_static_broadcaster = StaticTransformBroadcaster(self)
        self.tf_broadcaster = self.create_publisher(TransformStamped, self.namespace + '/tf', 10)
        
        """
            Not putting the next static transform in the launch file because we might
            want to change it a runtime later.
        """
        world_to_odom_init_transform = TransformStamped()
        world_to_odom_init_transform.header.frame_id = self.world_frame
        world_to_odom_init_transform.child_frame_id = self.odom_frame
        world_to_odom_init_transform.transform.translation.x = self.world_to_odom_init_offset[0]
        world_to_odom_init_transform.transform.translation.y = self.world_to_odom_init_offset[1]
        world_to_odom_init_transform.transform.translation.z = self.world_to_odom_init_offset[2]
        # Convert the rotation from world to odom
        tmp = R.from_euler('xyz', [0., 0., 0.]).as_quat()
        world_to_odom_init_transform.transform.rotation.x = tmp[0]
        world_to_odom_init_transform.transform.rotation.y = tmp[1]
        world_to_odom_init_transform.transform.rotation.z = tmp[2]
        world_to_odom_init_transform.transform.rotation.w = tmp[3]

        # Publish a static transform from the baselink FLU to baselink FRD
        odom_to_FRD_transform = TransformStamped()
        odom_to_FRD_transform.header.stamp = self.get_clock().now().to_msg()
        odom_to_FRD_transform.header.frame_id = self.odom_frame
        odom_to_FRD_transform.child_frame_id = self.FRD_px4_odom_frame
        odom_to_FRD_transform.transform.translation.x = 0.0
        odom_to_FRD_transform.transform.translation.y = 0.0
        odom_to_FRD_transform.transform.translation.z = 0.0
        # Convert the rotation from FLU to FRD
        tmp = R.from_euler('xyz', [np.pi, 0., 0.]).as_quat()
        odom_to_FRD_transform.transform.rotation.x = tmp[0]
        odom_to_FRD_transform.transform.rotation.y = tmp[1]
        odom_to_FRD_transform.transform.rotation.z = tmp[2]
        odom_to_FRD_transform.transform.rotation.w = tmp[3]
        
        self.tf_static_broadcaster.sendTransform(world_to_odom_init_transform)
        self.tf_static_broadcaster.sendTransform(odom_to_FRD_transform)
        
    def handle_tfs(self, msg):
        """
        Handle incoming transforms to update pose data.
        """
        
        # look for the baselink frame in the incoming transforms
        for transform in msg.transforms:
            if transform.child_frame_id == self.baselink_frame:
                # Update the baselink pose
                self.baselink_pose = [transform.transform.translation.x,
                                      transform.transform.translation.y,
                                      transform.transform.translation.z,
                                      transform.transform.rotation.x,
                                      transform.transform.rotation.y,
                                      transform.transform.rotation.z,
                                      transform.transform.rotation.w]
                # self.get_logger().info(f"Updated {self.baselink_frame} pose.")
                break
    
    def publish_tf(self):
        """
        Publish the latest baselink pose as a dynamic transform.
        self."""
        self.odom_to_baselink_tf_msg.header.stamp = self.get_clock().now().to_msg()
        self.odom_to_baselink_tf_msg.header.frame_id = self.odom_frame
        self.odom_to_baselink_tf_msg.child_frame_id = self.baselink_frame
        self.odom_to_baselink_tf_msg.transform.translation.x = self.baselink_pose[0]
        self.odom_to_baselink_tf_msg.transform.translation.y = self.baselink_pose[1]
        self.odom_to_baselink_tf_msg.transform.translation.z = self.baselink_pose[2]
        self.odom_to_baselink_tf_msg.transform.rotation.x = self.baselink_pose[3]
        self.odom_to_baselink_tf_msg.transform.rotation.y = self.baselink_pose[4]
        self.odom_to_baselink_tf_msg.transform.rotation.z = self.baselink_pose[5]
        self.odom_to_baselink_tf_msg.transform.rotation.w = self.baselink_pose[6]
        self.tf_broadcaster.publish(self.odom_to_baselink_tf_msg)