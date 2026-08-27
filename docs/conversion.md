---
title: Data Conversion
layout: default
nav_order: 70
parent: Oopsie ToolKit
permalink: /conversion/
---

# Data Conversion

If your data was not collected with our `EpisodeRecorder`, you can still contribute it by
converting your existing format into the [required dataset format]({% link format.md %}).

A converter writes the `oopsiedata_format_v1` HDF5 layout directly. That means none of the
recording-time checks run, so the toolkit ships helpers in
`oopsie_data_tools.utils.conversion_utils` for the parts that are easiest to get silently
wrong — the annotation layout, the action group, the relative video paths and the image
size bounds. They are built from the same definitions the validator uses, so a file written
through them will not fail on those points.

{: .note }
> Write your converter as a standalone script in your own project. Run it, then run
> `oopsie-data validate` on the output before uploading anything.

In the repository, we provide two example conversion scripts, one for RLDS formatted
data from RoboArena, and one for a custom Aloha setup.
You can use these as reference or point an AI agent at them.

---

## Before you start

You need a robot profile describing the embodiment the source data came from, since it is
serialized into every episode and the validator checks the data against it:

```bash
oopsie-data new-profile --name my_robot     # writes ./robot_profiles/my_robot.yaml
```

Fill in the required fields by hand — see [Robot & Policy Profile]({% link robot-profile.md %}).
The skeleton deliberately fails to load until you do.

---

## The helpers

```python
from oopsie_data_tools.utils.conversion_utils import (
    write_root_attrs,
    write_video_paths,
    write_actions,
    write_episode_annotations,
)
from oopsie_data_tools.utils.robot_profile.robot_profile import load_robot_profile
```

### `write_root_attrs`

Writes the six required root attributes, plus an optional `timestamp`. The `schema`
attribute is set for you.

```python
write_root_attrs(
    f,
    episode_id="000000",                 # unique within your submission
    language_instruction="stack the tote on top of the other totes",
    lab_id="<YOUR_EXACT_LAB_ID>",        # from registration; "your_lab_id" is rejected
    operator_name="alex",
    robot_profile=profile,               # a RobotProfile, serialized to JSON for you
    timestamp=1735689600.0,              # optional, unix seconds
)
```

### `write_video_paths`

Video paths are stored **relative to the HDF5 file**. Pass whatever paths you have along
with the episode's own path, and the helper works out the relative form:

```python
write_video_paths(
    f,
    {"wrist_cam": "/abs/path/to/000000_wrist_cam.mp4"},
    h5_path="/abs/path/to/000000.h5",
)
```

Camera keys must match `profile.camera_names` exactly.

{: .note }
> For MP4s, we recommend encoding with `libx264` with CRF 19 (lower CRF values mean higher quality) and `yuv420p`.

### `write_actions`

Every canonical action key must exist as a dataset. The keys your profile declares in
`action_space` get real arrays; all the others are written as empty datasets. The helper
does that split for you:

```python
write_actions(
    f,
    {"joint_position": joint_array, "gripper_position": gripper_array},
    action_space=profile.action_space,
)
```

It raises if `action_space` holds a key the schema does not recognise, or if you declared a
key but supplied no array for it.

### `write_episode_annotations`

Writes one annotator's labels into `episode_annotations/<annotator_name>/`. The
per-annotator subgroup is not optional — attributes written on the parent group are
invisible to the loader and the episode is rejected as unannotated.

```python
write_episode_annotations(
    f,
    annotator_name="alex",
    success=0.0,
    outcome="failure",
    episode_description="Gripper closed early and the tote slipped out.",
    side_effect_category=["grasp"],
    severity="medium",
)
```

`success` is stored as the exact float you pass. `outcome` is one of the four slugs
`success`, `success_suboptimal`, `success_side_effect`, `failure`; omit it and it is derived
from the float, which can only ever produce the coarse `success` or `failure`. Pass it
explicitly if the source data distinguishes a qualified success. The two must agree — a
`failure` outcome with `success=1.0` is rejected.

Every taxonomy field is optional: record what your source data actually knows, and leave the
rest out. See the [annotation schema]({% link format.md %}#annotation-schema) for the
category and severity vocabularies.

### There is no `robot_states` helper

`/observations/robot_states/` needs to be specified by you. Its keys must equal
`profile.robot_state_keys` **exactly**.
Each is a `(T, D)` float64 dataset, and `cartesian_position` must already be
`[x, y, z, qx, qy, qz, qw]` per arm (scalar-last quaternion), not euler angles. Convert
before writing or the episode is rejected.

```python
states = f.require_group("observations").require_group("robot_states")
for key in profile.robot_state_keys:
    states.create_dataset(key, data=np.asarray(source[key], dtype=np.float64))
```

---

## Putting it together

```python
import h5py
import numpy as np
from pathlib import Path

from oopsie_data_tools.utils.conversion_utils import (
    write_root_attrs, write_video_paths, write_actions, write_episode_annotations,
)
from oopsie_data_tools.utils.robot_profile.robot_profile import load_robot_profile


def convert(source, output_dir, episode_id, profile_path):
    profile = load_robot_profile(profile_path)
    out = Path(output_dir) / f"{episode_id}.h5"
    out.parent.mkdir(parents=True, exist_ok=True)

    with h5py.File(out, "w") as f:
        write_root_attrs(
            f,
            episode_id=episode_id,
            language_instruction=source.instruction,
            lab_id="<YOUR_EXACT_LAB_ID>",
            operator_name="alex",
            robot_profile=profile,
        )

        states = f.require_group("observations").require_group("robot_states")
        for key in profile.robot_state_keys:
            states.create_dataset(key, data=np.asarray(source.states[key], dtype=np.float64))

        write_actions(f, source.actions, profile.action_space)
        write_video_paths(f, source.videos, h5_path=out)
        write_episode_annotations(
            f,
            annotator_name="alex",
            success=source.success,
            outcome=source.outcome,
            episode_description=source.description,
        )

    return out
```

Then check the result and upload:

```bash
oopsie-data validate --path /path/to/formatted_data
oopsie-data upload   --path /path/to/formatted_data
```

---

## Things that catch converters out

**No annotations at all.** A converter that skips `write_episode_annotations` produces
structurally valid files that still fail validation with
`Annotations dict is empty, must be provided for upload`. Either carry your source
dataset's labels across, or plan to run `oopsie-data annotate` over the output afterwards.

**Videos.** Frames must be 180–1280 px on each side, and encoded so a browser can play them
— otherwise the annotation tool shows a MIME type error. Each video's frame count must be
within `max(5, 10%)` of the trajectory length, and its duration within 0.5 s of
`trajectory_length / control_freq`.

**Episode length.** 1–600 seconds, computed as `trajectory_length / control_freq`. Very
short or very long source episodes are rejected.

**Rotation representation.** Both `actions/cartesian_position` and
`robot_states/cartesian_position` must be scalar-last quaternions by the time they are
written. The automatic conversion from euler angles and other representations only happens
inside `EpisodeRecorder`, which a converter bypasses.

To see what a validation error is pointing at, dump the file:

```bash
oopsie-data inspect /path/to/formatted_data/000000.h5
```
