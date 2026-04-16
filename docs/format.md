---
title: Dataset Format
layout: default
nav_order: 5
parent: Oopsie ToolKit
has_children: true
permalink: /format/
---

{: .warning }
> ### 🚧 Under Construction
> This section is currently being updated. Some links or information may be missing.

# Dataset Format

Episodes are stored as **HDF5 files** (`.h5`), one file per episode. This is the native format written by `EpisodeRecorder` and read by the annotation tool. For dataset distribution, episodes will be exported to training-ready formats, such as RLDS and LeRobot. If you use the provided toolkit, you will not have to worry about the data format, but if you write a separate converter, or if you simply want to know how the data looks under the hood, we explain it in detail here.

We chose to use a file-per-episode format to make the annotation tool more flexible, as it allows us to group and bulk annotate episodes flexibly. For more details, see the [explanation of the data annotation tool]({% link annotator.md %}).

Note that we save far more metadata than other projects such as the DROID dataset. This is on purpose, as our dataset is designed to make cross-embodiment training easier. For example, we explicitly collect information about joint names and rotation representation. For details, see the [Robot Setup]({% link data-collection.md %}#robot-setup).

---

## HDF5 Episode Schema

Each HDF5 file follows the `oopsiedata_format_v1` schema:

```
episode.h5
├── [attr] schema = "oopsiedata_format_v1"
├── [attr] language_instruction    (str)
├── [attr] episode_id              (str)        # unique in submission group
├── [attr] lab_id                  (str)        # assigned at sign_up
├── [attr] operator_name           (str)        # can be pseudonymized
├── [attr] robot_profile           (str)        # json-serialized RobotSetup profile
├── [attr] timestamp               (float)      # unix timestamp of episode start
│
├── episode_annotations/           (group)      # written by annotation tool after rollout
│   └── <annotator_name>/          (group)      # one subgroup per annotator
│       ├── [attr] source              (str)    # e.g. "human"
│       ├── [attr] timestamp           (str)    # ISO timestamp of annotation
│       ├── [attr] success             (float)  # 1.0 = success, 0.0 = failure
│       ├── [attr] failure_description (str)
│       ├── [attr] taxonomy            (str)    # json: {failure_category, severity}
│       └── [attr] additional_notes    (str)
│
├── observations/                  (group)
│   ├── video_paths/               (group)
│   │   └── <camera_name>          (dataset, str) # relative path to .mp4 file
│   └── robot_states/              (group)
│       ├── gripper_position       (dataset, float64, shape [N, 1])
│       ├── eef_cartesian_position (dataset, float64, shape [N, D])
│       └── joint_position         (dataset, float64, shape [N, D])
│
└── actions/                       (group)
    ├── joint_position             (dataset, float64, shape [N, D])
    ├── joint_velocity             (dataset, float64, shape [N, D])
    ├── gripper_binary             (dataset, float64, shape [N, 1])
    ├── gripper_position           (dataset, float64, shape [N, 1])
    ├── gripper_velocity           (dataset, float64, shape [N, 1])
    ├── base_position              (dataset, float64, shape [N, 3])
    ├── base_velocity              (dataset, float64, shape [N, 3])
    ├── eef_cartesian_position     (dataset, float64, shape [N, 7/14])
    └── eef_cartesian_velocity     (dataset, float64, shape [N, 6/12])
```

`N` is the number of recorded timesteps and `D` is the degrees of freedom for the robot.
For bi-arm setups, please simply concatenate the actions of the left and right arm.

**Important Points**
- We assume that many data collection setups will not make it possible to collect all action formats. We therefore only require **one** entry in `actions/` to be a valid tensor dataset; the others are stored as empty HDF5 datasets.
- Please ensure to provide unnormalized and absolute actions as this will make using the actions easier and reduce the amount of conversions.
- We furthermore assume that the rotation component of cartesian position action space are encoded as quaternions. Tooling for converting most common representations into quaternions are provided in the episode recorder.
- The gripper action should be set in one of the three keys: gripper_binary, gripper_position or gripper_velocity. Note that we currently only support two-finger gripper setups.

---

## Field Reference

### Root Attributes

| Field | Type | Required | Description |
|:------|:-----|:---------|:------------|
| `schema` | str attr | Yes | `"oopsiedata_format_v1"` |
| `language_instruction` | str attr | Yes | Natural language task description |
| `episode_id` | str attr | Yes | Unique disambiguation ID per episode |
| `lab_id` | str attr | Yes | Lab identifier for multi-lab tracking |
| `operator_name` | str attr | No | Name of the operator running the rollout |
| `robot_profile` | str attr | Yes | JSON-serialized `RobotSetup` profile (includes robot_id, control_freq, joint names, camera names, etc.) |
| `timestamp` | float attr | Yes | Unix timestamp of episode start |

### Episode Annotations

The `episode_annotations/` group is written by the annotation tool after rollout, not during recording. It contains one subgroup per annotator:

| Field | Type | Description |
|:------|:-----|:------------|
| `source` | str attr | Annotation source, e.g. `"human"` |
| `timestamp` | str attr | ISO timestamp of when the annotation was made |
| `success` | float attr | `1.0` = success, `0.0` = failure |
| `failure_description` | str attr | Free-text description of the failure |
| `taxonomy` | str attr | JSON string: `{"failure_category": ..., "severity": ...}` |
| `additional_notes` | str attr | Any other annotator notes |

The annotation tool provides a simple interface for editing these fields per episode, or in bulk across a group of episodes.

### Video Paths

Camera video files are stored under `observations/video_paths/` as **relative paths** to MP4 files co-located with the HDF5 file. Camera names are user-defined; use descriptive names for consistency:

```
wrist_cam          # Wrist-mounted camera
overhead_cam       # Top-down view
left_shoulder_cam  # Left over-shoulder view
right_shoulder_cam # Right over-shoulder view
front_cam          # Frontal view
```

Keeping the videos in separate files as opposed to storing the raw pixel observations in the HDF5 file allows us to display and store high resolution videos without massive storage inflation during annotation.
These files will be post-processed for the dataset release.

### Robot State Observations (per timestep)

Stored under `observations/robot_states/`.

| Field | Type | Shape | Description |
|:------|:-----|:------|:------------|
| `gripper_position` | float64 | (N, 1) | Gripper position state |
| `eef_cartesian_position` | float64 | (N, D) | End-effector Cartesian pose; shape depends on robot profile |
| `joint_position` | float64 | (N, D) | Joint position state |

### Actions (per timestep)

Stored under `actions/`. Unused fields are written as empty HDF5 datasets.

| Field | Type | Shape | Description |
|:------|:-----|:------|:------------|
| `joint_position` | float64 | (N, D) | Commanded joint positions in absolute (unnormalized) space |
| `joint_velocity` | float64 | (N, D) | Commanded joint velocities |
| `eef_cartesian_position` | float64 | (N, 7/14) | Commanded end-effector Cartesian pose (position + quaternion-based rotation) |
| `eef_cartesian_velocity` | float64 | (N, 6/12) | Commanded end-effector Cartesian velocity (first 3 linear + next 3 angular) |
| `gripper_binary` | float64 | (N, 1) | Binary gripper command (open/close) |
| `gripper_position` | float64 | (N, 1) | Commanded gripper position |
| `gripper_velocity` | float64 | (N, 1) | Commanded gripper velocity |
| `base_position` | float64 | (N, 3) | Commanded base position (deltas usually) |
| `base_velocity` | float64 | (N, 3) | Commanded base linear velocity (x, y, yaw) |

To make the dataset usable across embodiments, we ask that you save absolute end-effector position commands.
However, we acknowledge that the best action space encoding can vary from policy to policy. For common embodiments, such as the Franka arm used in the standard Droid setup, and the Aloha bi-arm manipulator, we provide utilities to convert between joint and eef space representations.

If you want to contribute data on a different embodiment, and your policy does not allow you to output eef positions, please let us know.

---

## Failure Annotation Schema

Annotations are written into the `episode_annotations/<annotator_name>/` subgroup by the annotation tool. The `taxonomy` attribute holds a JSON string with structured failure labels:

```json
{
  "failure_category": "<category>",
  "severity": "<severity>"
}
```

The questionnaire driving these fields is defined in `robotic_failure_data/annotation_tool/questionnaire.yaml` and can be filled out using the [annotation tool]({% link annotator.md %}).

---

## Directory Layout

We strongly recommend saving the data in a directory layout structured like this.

```
samples_directory
├── evaluation_session_1
│   ├── episode_1.hdf5
│   ├── episode_1_camera1.mp4
│   ├── episode_1_camera2.mp4
│   ├── episode_2.hdf5
│   ├── episode_2_camera1.mp4
│   ├── episode_2_camera2.mp4
│   └── ...
│
├── evaluation_session_2
│   ├── episode_1.hdf5
│   ├── episode_1_camera1.mp4
│   ├── episode_1_camera2.mp4
│   └── ...
│
└── ...
```
By default, session names and episodes will contain the lab id and timestamp.

Keeping all episodes from one evaluation session in one directory allows you to easily use the bulk annotation utilities in the data annotation tool.
Note that we do not make any assumptions about file names, all of our tools simply look for all hdf5 files in a nested directory structure.
The file paths of associated mp4 camera videos need to be saved in the hdf5 files directly, as described above.

---

## Additional Data Format Constraints
Video constraints (enforced by `validate.py`):
- Resolution: 180–1280 px on each side
- Duration: 2–300 seconds

