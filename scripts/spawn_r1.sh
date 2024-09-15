gz service -s /world/default/create \
    --reqtype gz.msgs.EntityFactory \
    --reptype gz.msgs.Boolean \
    --timeout 1000 \
    --req 'sdf_filename: "/root/PX4-Autopilot/Tools/simulation/gz/models/r1_rover/model.sdf", name: "lucifero7",
    pose: { position: { x: 3, y: 3, z: 9 }, orientation: { x: 0, y: 0, z: 1, w: 0 } }' 