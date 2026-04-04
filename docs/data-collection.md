---
title: Data Collection
layout: default
nav_order: 4
parent: Contributing
permalink: /data-collection/
---

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

## Recording data with our Toolkit

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