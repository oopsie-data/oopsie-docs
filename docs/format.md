---
title: Dataset Format
layout: default
nav_order: 2
parent: Contributing
has_children: true
permalink: /format/
---

# Dataset Format

Episodes are stored as **HDF5 files** (`.h5`), one file per episode. This is the native format written by `EpisodeRecorder` and read by the annotation tool. For dataset distribution, episodes will be exported to RLDS-compatible format.
We chose to use a file-per-episode format to make the annotation tool more flexible, as it allows us to group and bulk annotate episodes flexibly. For more details, see the [explanation of the data annotation tool]({% link annotator.md %}).

---

## HDF5 Episode Schema

Each HDF5 file follows the `robotic_failure_upload_data_format_v1` schema:

```
episode.h5
├── [attr] schema = "robotic_failure_upload_data_format_v1"
├── [attr] language_instruction    (str)
│
├── episode_annotations/           (group)
│   ├── [attr] episode_id          (str)        # unique in submission group
│   ├── [attr] lab_id              (str)        # assigned at sign_up
│   ├── [attr] operator_name       (str)        # can be pseudonymized
│   ├── [attr] policy_id           (str)        # drop-down options provided in web tool
│   ├── [attr] robot_id            (str)        # drop-down options provided in web tool
│   ├── [attr] control_freq        (int)
│   ├── [attr] success             (bool)
│   └── [attr] failure_annotation  (str)        # json of annotation questionnaire replies
│
├── image_observations/          (group)
│   └── <camera_name>            (dataset, str) # relative path to .mp4 file
│       └── [attr] format = "mp4_filepath"
│
├── observation/                 (group)
│   ├── gripper_position         (dataset, float64, shape [N, 1])
│   ├── eef_cartesian_position   (dataset, float64, shape [N, 7])
│   └── joint_position           (dataset, float64, shape [N, D])
│
└── action_dict/                 (group)
    ├── joint_position           (dataset, float64, shape [N, D])
    ├── joint_velocity           (dataset, float64, shape [N, D])
    ├── eef_cartesian_position   (dataset, float64, shape [N, 8/16])
    └── eef_cartesian_velocity   (dataset, float64, shape [N, 8/16])
```

`N` is the number of recorded timesteps and `D` is the degrees of freedom for the robot.
For bi-arm setups, please simply concatenate the actions of the left and right arm.

We assume that many data collection setups will not make it possible to collect all action formats. 
We therefore only require **one** entry in the `action_dict` to be a valid tensor dataset, and the others can be set to none.
Please ensure to provide unnormalized and absolute actions as this will make using the actions easier and reduce the amount of conversions.
We furthermore assume that cartesian positions are encoded as as rotation quaternions.
Tooling for converting most common representations into quaternions are provided in the episode recorder.

The final action dimensions should be a binary 0/1 for the gripper.
Note that we currently only support two-finger gripper setups.

---

## Field Reference

### Episode Annotations

| Field | Type | Required | Description |
|:------|:-----|:---------|:------------|
| `episode_id` | str attr | Yes | Unique disambiguation ID per episode |
| `lab_id` | str attr | Yes | Lab identifier for multi-lab tracking |
| `operator_name` | str attr | No | Name of the operator who annotated the data |
| `policy_id` | str attr | Yes | String identifying the evaluated policy |
| `robot_id` | str attr | Yes | Robot platform identifier |
| `control_freq` | int attr | Yes | Controller frequency (e.g., `"10"` for 10 Hz) |
| `success` | bool attr | Yes | Success label |
| `failure_annotation` | str | No | Questionnaire answers (JSON string) |

The annotation tool provides a simple interface for editing these fields per episode, or in bulk across a group of episodes.

### Image Observations

Camera video files are stored as **relative paths** to MP4 files co-located with the HDF5 file. Camera names are user-defined; use descriptive names for consistency:

```
wrist_cam          # Wrist-mounted camera
overhead_cam       # Top-down view
left_shoulder_cam  # Left over-shoulder view
right_shoulder_cam # Right over-shoulder view
front_cam          # Frontal view
```

Keeping the videos in separate files as opposed to storing the raw pixel observations in the HDF5 file allows us to display and store high resolution videos without massive storage inflation during annotation.
These files will be post-processed for the dataset release.

### Observations (per timestep)

| Field | Type | Shape | Description |
|:------|:-----|:------|:------------|
| `gripper_position` | float64 | (N, 1) | Gripper position state |
| `eef_cartesian_position` | float64 | (N, 6) | End-effector Cartesian pose |
| `joint_position` | float64 | (N, 7) | Joint position state |

### Actions (per timestep)

| Field | Type | Shape | Description |
|:------|:-----|:------|:------------|
| `eef_cartesian_position` | float64 | (N, 6) | Commanded end-effector Cartesian position |
| `gripper_position` | float64 | (N, 1) | Commanded gripper position |
| `eef_cartesian_velocity` | float64 | (N, 6) | Commanded end-effector Cartesian velocity (optional) |
| `gripper_velocity` | float64 | (N, 1) | Commanded gripper velocity (optional) |

To make the dataset usable across embodiments, we ask that you save absolute end-effector position commands. 
However, we acknowledge that the best action space encoding can vary from policy to policy. For common embodiments, such as the Franka arm used in the standard Droid setup, and the Aloha bi-arm manipulator, we provide utilities to convert between joint and eef space representations.

If you want to contribute data on a different embodiment, and your policy does not allow you to output eef positions, please let us know.

---

## Failure Annotation Schema

The `failure_annotation/question` dataset contains a JSON string with questionnaire answers. The questionnaire is defined in `robotic_failure_data/annotation_tool/questionnaire.yaml` and can be filled out using the [annotation tool]({% link annotator.md %}).

---

## Directory layout

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

## Additional data format constraints
Video constraints (enforced by `validate.py`):
- Resolution: 180–1280 px on each side
- Duration: 2–300 seconds

