---
title: Robot & Policy Profile
layout: default
nav_order: 20
parent: Oopsie ToolKit
permalink: /robot-profile/
---
# Robot & Policy Profile

The robot profile captures important metadata about the robot embodiment. It is also used to validate the data at collection time, by checking whether the passed information matches the fields specified in the robot profile.

You only need to set up a robot profile once for each robot + policy configuration you evaluate. The reason that both robot and policy metadata are captured here is because some information, such as the available action space, depend on both.

---

## Creating a Robot Profile


We provide example files for robot setup files for several common embodiments and policy setups in [config/robot_profiles](https://github.com/oopsie-data/oopsie-data-tools/tree/main/configs/robot_profiles). We encourage you to use those and adapt them to your use-case.  We are also happy to accept pull requests for additional common robot configurations!

### Required fields

For each field with several options, you can provide one or more options.

| Field | Type | Description |
|-------|------|-------------|
| `policy_name` | `str` | Name of the policy being evaluated |
| `robot_name` | `str` | Identifier for the robot platform |
| `gripper_name` | `str` | Identifier for the gripper |
| `is_biarm` | `bool` | Whether the setup has two arms |
| `uses_mobile_base` | `bool` | Whether the platform has a mobile base. If `true`, `action_space` must include a base command |
| `control_freq` | `int` | Control frequency in Hz |
| `camera_names` | `list[str]` | Names of cameras to record |
| `robot_state_keys` | `list[str]` | Observations recorded per step. `gripper_position` is always required, `joint_position` is required for joint control, `cartesian_position` is required for end-effector control. |
| `robot_state_joint_names` | `list[str]` | Joint names corresponding to indices in `robot_state["joint_position"]` |
| `action_space` | `list[str]` | Action representation. Options: `"cartesian_position"`, `"cartesian_velocity"`, `"joint_position"`, `"joint_velocity"`, `"gripper_position"`, `"gripper_velocity"`, `"gripper_binary"`, `"base_velocity"`, `"base_position"`|

#### Valid action spaces

At least one arm command from `["cartesian_position", "cartesian_velocity", "joint_position", "joint_velocity"]` must be provided, and at least one gripper command from `["gripper_position", "gripper_velocity", "gripper_binary"]`. This ensures that at least one command for the arm and one for the gripper is provided. At most one base command (`"base_position"` or `"base_velocity"`) may be given; base commands are only required for wheeled mobile manipulation platforms (`uses_mobile_base: true`). No other keys are accepted.

### Optional fields

| Field | Type | Description |
|-------|------|-------------|
| `controller` | `str` | Controller type, e.g. `OSC`, `joint_position`, `joint_velocity` |
| `action_joint_names` | `list[str]` | Joint names for joint-space action spaces (include `gripper` as last entry). **Required** when `action_space` contains `joint_position` or `joint_velocity` |
| `orientation_representation` | `str` | Required when `action_space` contains `cartesian_position`. Options: `euler_{format}` (e.g. `euler_xyz`, shape `(3,)`), `quat` (scalar-last, shape `(4,)`), `matrix` (shape `(3,3)`), `rot6d` (shape `(6,)`, used by openpi), `rotvec` (axis-angle, shape `(3,)`) |
| `robot_state_orientation_representation` | `str` | Same options as above. Required when `robot_state_keys` contains `cartesian_position` |
| `gains` | `dict` | Nested dictionary mapping the active `controller` to its respective gain values. Structure depends on the controller used: for `joint_position` provide `kp` and `kd` arrays; for `joint_velocity` provide `kv` array; for `osc` provide `kp_pos`, `kd_pos`, `kp_ori`, and `kd_ori` arrays. |
| `intrinsic_calibration_matrix` | `dict[str, list[list[float]]]` | Dictionary mapping camera names to their $3 \times 3$ intrinsic camera matrices. |
| `extrinsic_calibration_matrix` | `dict[str, list[list[float]]]` | Dictionary mapping camera names to their $4 \times 4$ extrinsic camera matrices. |

Note that the orientation representation is set by two separate keys: `orientation_representation` covers `action_space`, and `robot_state_orientation_representation` covers `robot_state_keys`. Set whichever applies when the corresponding space contains `cartesian_position`.


### Example

```yaml
policy_name: my_policy
robot_name: franka
gripper_name: franka_hand
is_biarm: false
uses_mobile_base: false
control_freq: 10
camera_names:
  - wrist
robot_state_keys:
  - joint_position
  - cartesian_position
  - gripper_position
robot_state_joint_names:
  - joint_1
  - ...
robot_state_orientation_representation: euler_xyz
action_space: 
  - joint_velocity
  - gripper_position
action_joint_names:
  - joint_1
  - ...

controller: "joint_position"
gains:
  joint_position:
    kp: [100, 100, 100, 100, 100, 100, 100]
    kd: [10, 10, 10, 10, 10, 10, 10]

intrinsic_calibration_matrix: 
  wrist:
    - [1, 0, 0]
    - [0, 1, 0]
    - [0, 0, 1]

extrinsic_calibration_matrix:
  wrist:
    - [1, 0, 0, 0]
    - [0, 1, 0, 0]
    - [0, 0, 1, 0]
    - [0, 0, 0, 1]
```
