import rclpy
from rclpy.node import Node
from rclpy.publisher import Publisher
from rclpy.time import Time
from tf2_ros import StaticTransformBroadcaster, TransformStamped, TFMessage
from tf2_ros.buffer import Buffer
from tf2_ros.transform_listener import TransformListener
import numpy as np
from scipy.spatial.transform import Rotation as R

class TFBridgeNode(Node):
    def __init__(self, tf_pub_rate=100.):
        super().__init__('tf_bridge_node')
        
        """
            Takes the place of the ZED SDK node on the xavier.
        """

        self.namespace = 'matte'
        self.world_frame = 'default'
        self.odom_frame = self.namespace + '/odom'
        self.FRD_px4_odom_frame = self.namespace + '/FRD_px4_odom'
        self.baselink_frame = 'x500_depth_0/base_link'

        self.tf_pub_rate = tf_pub_rate
        self.baselink_pose = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0]  # Will be updated with the latest pose from the TF messages
        self.odom_to_baselink_tf_msg = TransformStamped()
        self.odom_to_baselink_tf_msg.header.frame_id = self.odom_frame
        self.odom_to_baselink_tf_msg.child_frame_id = self.baselink_frame
        self.world_to_odom_init_offset = [0.0, 0.0, 0.0]  # Initial offset for world to odom transform
        self.tf_message = TFMessage()
        
        self.tf_buffer = Buffer()
        self.tf_listener = TransformListener(self.tf_buffer, self)
        self.tf_static_broadcaster = StaticTransformBroadcaster(self)
        self.tf_broadcaster = self.create_publisher(TFMessage, '/tf', 10)
        
        self.create_timer(1.0 / self.tf_pub_rate, self.publish_tf)
        
        """
            Not putting the next static transform in the launch file because we might
            want to change it a runtime later.
        """
        world_to_odom_init_transform = TransformStamped()
        world_to_odom_init_transform.header.stamp = self.get_clock().now().to_msg()
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
                self.get_logger().info(f"Updated {self.baselink_frame} pose with {self.baselink_pose}.")
                break
    
    def publish_tf(self):
        """
            Publish the latest baselink pose as a dynamic transform.
        """
        # lookup transform from default to baselink
        try:
            transform = self.tf_buffer.lookup_transform(
                self.world_frame, 
                self.baselink_frame, 
                rclpy.time.Time()
            )
        except Exception as e:
            self.get_logger().error(f"Failed to lookup transform: {e}")
            return
        self.odom_to_baselink_tf_msg.header.stamp = self.get_clock().now().to_msg()
        self.odom_to_baselink_tf_msg.transform.translation.x = transform.transform.translation.x
        self.odom_to_baselink_tf_msg.transform.translation.y = transform.transform.translation.y
        self.odom_to_baselink_tf_msg.transform.translation.z = transform.transform.translation.z
        self.odom_to_baselink_tf_msg.transform.rotation.x = transform.transform.rotation.x
        self.odom_to_baselink_tf_msg.transform.rotation.y = transform.transform.rotation.y
        self.odom_to_baselink_tf_msg.transform.rotation.z = transform.transform.rotation.z
        self.odom_to_baselink_tf_msg.transform.rotation.w = transform.transform.rotation.w
        # Publish the transform
        self.tf_message.transforms.clear()  # Clear previous transforms
        self.tf_message.transforms.append(self.odom_to_baselink_tf_msg)
        self.tf_broadcaster.publish(self.tf_message)

def main(args=None) -> None:
    rclpy.init(args=args)
    node = TFBridgeNode()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()
        print("TF Bridge Node has been shut down.")