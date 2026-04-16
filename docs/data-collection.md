---
title: Data Collection
layout: default
nav_order: 2
parent: Oopsie ToolKit
permalink: /data-collection/
---

{: .warning }
> ### 🚧 Under Construction
> This section is currently being updated. Some links or information may be missing.

# Data Collection Workflow

For this project, we are interested in collecting in-the-wild evaluation trajectories, both successes and failures.
Every lab evaluates trained policies routinely during their day-to-day development process, but this data is rarely saved for future use.
The core goal of this project is to make collection, annotation, and sharing of this data easy.

For this, we provide several tools.
The envisioned workflow follows a standard data collection and annotation pipeline. On this page
we explain the different ways in which you can gather the data and launch the annotation tool.
On the [next page]({% link annotator.md %}), we present the interface of the annotation tool and the annotation process in more detail.

We support three workflows:
1. **In-the-loop collection and annotation**: You can integrate our tool directly in your evaluation loop. The tool will open a browser or CLI prompt and ask you to directly annotate the episode with success/failure information after the robot completes an episode.
2. **Bulk collection and annotation**: If annotating in the loop does not fit your work style, you can also simply save your data using our EpisodeRecorder and launch the annotation tool as a stand-alone script after you are done with your evaluation runs on the robot.
3. **Custom collection and bulk annotation**: If your setup is incompatible with our EpisodeRecorder, you can still save your data in the format outlined in our [data formatting]({% link format.md %}) guidelines. The web annotator tool can work with any dataset that is saved in the specified format. We keep a growing list of scripts to convert common data formats such as RLDS in our [github repository](https://github.com/cvoelcker/robotic_failure_data/tree/main/scripts/dataset_conversion).

---

## Recording data with our toolkit

### 1. In-the-loop collection and annotation

#### 1a. Web UI
For interactive annotation after each rollout using the browser UI:

```python
from robotic_failure_data.annotation_tool.rollout_annotator import WebRolloutAnnotator
from pathlib import Path

annotator = WebRolloutAnnotator(
    samples_dir=Path("./samples"),
    policy_name="my_policy",
    camera_names=["wrist", "overhead"],
)
annotator.start()  # opens browser

# policy initialization code
# ...

for _ in range(num_eval_episodes):
    # policy reset code
    # ...

    instruction = annotator.wait_for_task() # instruction is a str provided by the user via the interface
    annotator.start_rollout()

    for obs, action in run_policy(env, policy, instruction):
        # step policy and robot environment
        # ...

        annotator.record_step(observation=obs, action=action)

    success = annotator.finish_rollout(
        instruction=instruction,
        videos={},   # auto-extracted from record_step / only override if necessary
        t_step=len(trajectory),
    )
    # success is saved automatically in the hdf5 file, we return it for further processing by the user script
```

#### 1b. CLI
If you have trouble using the web ui, or simply prefer a CLI utility, we also offer an in-the-loop option using the CLI:

```python
from robotic_failure_data.annotation_tool.rollout_annotator import CLIRolloutAnnotator
from pathlib import Path

annotator = CLIRolloutAnnotator(
    policy_name="my_policy",
    data_dir=Path("./episode_data"),
    camera_names=["wrist"],
)
# policy initialization code
# ...

for _ in range(num_eval_episodes):
    # policy reset code
    # ...

    instruction = annotator.prompt_instruction() # instruction is a str provided by the user via the CLI directly
    annotator.start_rollout()

    for obs, action in run_policy(env, policy, instruction):
        # step policy and robot environment
        # ...

        annotator.record_step(observation=obs, action=action)

    success = annotator.finish_rollout(
        instruction=instruction,
        videos={},   # auto-extracted from record_step / only override if necessary
        t_step=len(trajectory),
    )
    # success is saved automatically in the hdf5 file, we return it for further processing by the user script
```


### 2. Bulk collection and annotation

```python
from robotic_failure_data.annotation_tool.episode_recorder import EpisodeRecorder

rec = EpisodeRecorder(
    output_dir="./episode_data",
    policy_name="my_policy",
    policy_id="my_policy_v2",
    camera_names=["wrist", "overhead"],
    robot_id="franka_01",
    control_freq="10",
)

# policy initialization code
# ...

for _ in range(num_eval_episodes):
    # policy reset code
    # ...
    for obs, action in rollout:
        # step policy and robot environment
        # ...
        rec.record_step(observation=obs, action=action)

    rec.save({
        "language_instruction": your_task_instruction,
        "episode_annotations": {
            "operator_name": your_name,
        },
    })
```

See the [annotation explanation](/annotation) for instructions on how to launch and use the annotation tool.

---

## ToolKit API

### `WebRolloutAnnotator`

```python
WebRolloutAnnotator(
    robot_profile: RobotSetup,
    samples_dir: Path,
    operator_name: str,
    port: int = 5001,
    annotator_name: str | None = None,
    wait_for_annotation: bool = True,
    open_browser: bool = True,
    resume_session_name: str | None = None,
)
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `robot_profile` | `RobotSetup` | — | Robot and policy metadata (see [Robot Setup](#robot-setup)) |
| `samples_dir` | `Path` | — | Directory where episode HDF5 and video files are written |
| `operator_name` | `str` | — | Name of the person running the evaluation |
| `port` | `int` | `5001` | Port for the local Flask annotation server |
| `annotator_name` | `str | None` | None | Name of the person performing annotations (if it is different from the operator name) |
| `wait_for_annotation` | `bool` | `True` | Block `finish_rollout()` until a human annotation is submitted |
| `open_browser` | `bool` | `True` | Automatically open the annotation UI in the default browser |
| `resume_session_name` | `str | None` | `None` | Resume a previous session by name instead of starting a new one |

### `record_step(observation, action)`

Append one rollout timestep to the in-memory buffers. No data is written to disk; all buffered data is only persisted later by calling `save()`.

#### Parameters

**`observation: dict[str, Any]`**

Top-level observation payload for a single timestep. Must contain:

| Key | Type | Description |
|---|---|---|
| `"robot_state"` | `dict` | Proprioceptive state of the robot (see sub-keys below) |
| `"image_observation"` | `dict` | Per-camera frame data (see sub-keys below) |

**`observation["robot_state"]`** — required keys are determined by `robot_profile.robot_state_keys`:

| Key | Type | Description |
|---|---|---|
| `"cartesian_position"` | array-like | End-effector pose as `[x, y, z, <rotation>]` (single-arm) or doubled (bimanual). Rotation is converted to a quaternion format automatically based on the information in `robot_profile.robot_state_keys`. |
| `"gripper_position"` | array-like | Current gripper opening width |
| `"joint_position"` | array-like | Per-joint angular positions |

**`observation["image_observation"]`** — required keys are determined by `robot_profile.camera_names`. For each camera `cam`, the frame is looked up under any of the following candidate keys (first match wins):

| Candidate key | Example |
|---|---|
| `cam` | `"wrist"` |
| `"image_{cam}"` | `"image_wrist"` |
| `"{cam}_image"` | `"wrist_image"` |

Frames must be `uint8` RGB arrays of shape `(H, W, 3)`.

---

**`action: dict[str, np.ndarray]`**

Dictionary of actions commanded at this timestep. All keys are optional; missing keys default to `None` and are stored as empty HDF5 datasets.

At least one of `["eef_cartesian_position", "eef_cartesian_velocity", "joint_position", "joint_velocity"]` must be provided. In addition, one of `[:gripper_position", "gripper_velocity"]` must also be provided. This ensures that at least one command for the arm and one for the gripper is provided.  The base commands are optional and only required for wheeled mobile manipulation platforms. 

| Key | Shape | Description |
|---|---|---|
| `"eef_cartesian_position"` | `(3 + ROT)` or `(2 x [3 + ROT])` | Target end-effector pose. If a rotation converter is configured on the `RobotSetup`, the orientation component is converted to quaternion before storage. |
| `"eef_cartesian_velocity"` | `(6,)` or `(12,)` | End-effector Cartesian velocity |
| `"joint_position"` | `(N,)` | Target joint angles |
| `"joint_velocity"` | `(N,)` | Target joint velocities |
| `"base_position"` | `(3,)` | Mobile base position command |
| `"base_velocity"` | `(3,)` | Mobile base velocity command |
| `"gripper_position"` | `(1,)` | Continuous gripper position target |
| `"gripper_velocity"` | `(1,)` | Gripper velocity command |
| `"gripper_binary"` | `(1,)` | Binary open/close gripper command |

---

#### Raises

- `ValueError` — if `observation` is not a dict, required observation keys are missing, `robot_state` is missing profile-required keys, `image_observation` is missing expected camera keys, or all action values are `None`.
- `ValueError` — if `eef_cartesian_position` is present but not shaped `(7,)` or `(14,)` (after rotation conversion).

---

## Robot Setup

To collect important robot and policy specific metadata, the `EpisodeRecorder` and `WebRolloutAnnotator` accept a `RobotSetup` config loaded from a JSON file.

We provide example files for robot setup files for several common embodiments and policy setups, and we encourage you to use those and adapt them to your usecase. 

### Required fields

| Field | Type | Description |
|-------|------|-------------|
| `policy_name` | `str` | Name of the policy being evaluated |
| `robot_name` | `str` | Identifier for the robot platform |
| `gripper_name` | `str` | Identifier for the gripper |
| `control_freq` | `int` | Control frequency in Hz |
| `camera_names` | `list[str]` | Names of cameras to record |
| `observation_keys` | `list[str]` | Observations recorded per step. Options: `joint_position`, `cartesian_position`, `gripper_position` |
| `action_space` | `str` | Action representation. Options: `joint_velocity`, `joint_position`, `eef_cartesian_position`, `eef_cartesian_velocity` |

### Optional fields

| Field | Type | Description |
|-------|------|-------------|
| `controller` | `str` | Controller type, e.g. `OSC controller`, `joint position controller`, `joint velocity controller` |
| `observation_joint_names` | `list[str]` | Joint names corresponding to indices in `observation["joint_position"]` |
| `action_joint_names` | `list[str]` | Joint names for joint-space action spaces (include `gripper` as last entry) |
| `orientation_representation` | `str` | Required when `action_space` is `eef_cartesian_position`. Options: `euler_{format}` (e.g. `euler_xyz`, shape `(3,)`), `quat` (scalar-last, shape `(4,)`), `matrix` (shape `(3,3)`), `rot6d` (shape `(6,)`, used by openpi), `rotvec` (axis-angle, shape `(3,)`) |

Note that the `observation_representation` key is mandatory if the action or observation spaces contain the endeffector cartesian positions.


### Example

```yaml
policy_name: my_policy
robot_name: franka
gripper_name: franka_hand
control_freq: 10
camera_names:
  - wrist
  - overhead
observation_keys:
  - joint_position
  - cartesian_position
  - gripper_position
observation_joint_names:
  - joint_1
  - ...
action_space: joint_velocity
action_joint_names:
  - joint_1
  - ...
orientation_representation: rot6d
```

---

## Possible Issues

If you are running your policy evaluation script inside a docker or singularity container, and you want to use the WebAnnotator tool, please make sure that you have forwarded the relevant ports to your main machine.