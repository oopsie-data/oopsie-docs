---
title: Annotation Tool
layout: default
nav_order: 40
parent: Oopsie ToolKit
permalink: /annotation/
---

# Annotation tool

The annotation tool is the primary interface for labeling robotic rollout episodes as successes or failures. An operator reviews video footage from one or more cameras and answers a structured questionnaire. Annotations are embedded back into the HDF5 episode file.

---

## Launching the tool

### Standalone (Web UI)

The simplest way to annotate a batch of pre-recorded episodes:

```bash
python -m oopsie_data_tools.annotation_tool.annotator_server \
    --samples-dir <DIR> --port <PORT> --annotator-name <YOUR_NAME>
```

`samples_dir` should be the top level directory where your samples were recorded, `port` specifies on which port the webserver can be accessed (navigate to `localhost:<port>` to see the web interface) and `annotator_name` records who provided the annotation. Open `http://localhost:<PORT>` in a browser. The tool scans `samples-dir` for HDF5 files and MP4 videos, and presents them one at a time for annotation. 

| Flag | Default | Description |
|:-----|:--------|:------------|
| `--samples-dir` | `samples` | Directory containing the HDF5 episodes and MP4s to annotate |
| `--annotator-name` | required | Name stamped into every annotation you save |
| `--port` | `5001` | Port for the local web server |
| `--no-browser` | off | Do not open a browser window automatically |
| `--with-rollouts` | off | Also serve the in-the-loop rollout pages. Not needed for annotating pre-recorded data |

### In-the-loop (Web UI)

For instructions on launching the web tool for in-the-loop annotation, see our [data collection instructions](/data-collection).

---

## Web UI

### Overview

<img src="{{ '/assets/images/annotator/overview-colored.png' | relative_url }}" alt="Annotation tool overview" style="float: right; width: 100%; margin: 0 0 1rem 1.5rem;" />

The main view has the following components:
- **<span style="color:#FF0000">(1)</span> Video Panel**: Video playback controls
- **<span style="color:#66CC00">(2)</span> Navigation Panel**: Controls for navigating between episodes
- **<span style="color:#00FFFF">(3)</span> Annotation Panel**: Annotation questionnaire
- **<span style="color:#FF8000">(4)</span> Info Panel**: Information on the current trajectory

The info panel summarizes the episode as it was recorded: the task instruction, the robot profile, and the logged state and action fields with their shapes. Fields that were not recorded are marked as empty, which makes it easy to spot a mis-configured robot profile before you upload. The task instruction can be corrected in place if it was recorded wrongly.

The interface follows your system light/dark preference and can be toggled manually at any time.

<div style="clear: both;"></div>

---

### **<span style="color:#FF0000">(1)</span> Video Panel**

<img src="{{ '/assets/images/annotator/videos.png' | relative_url }}" alt="Video panel" style="float: right; width: 50%; margin: 0 0 1rem 1.5rem;" />

The video panel displays MP4 footage from all cameras recorded during the episode. Use the playback controls to review the rollout before annotating.

For multi-camera episodes, the panel offers:

- **Grid layout** — choose how many videos are shown per row.
- **Playback speed** — slow a rollout down to catch a brief failure, or speed through a long one.
- **Sync videos** — seek, play or pause one camera and the others follow, so all views stay on the same timestep.

These settings persist across episodes and sessions.

<div style="clear: both;"></div>

---

### **<span style="color:#66CC00">(2)</span> Navigation Panel**

<img src="{{ '/assets/images/annotator/navigation.png' | relative_url }}" alt="Metadata" style="float: right; width: 50%; margin: 0 0 1rem 1.5rem;" />

The navigation panels allows for navigation between different episodes. The files are arranged according to the directory structure of your samples directory. If you are using the data recording tools, they are arranged by session.

Each fully annotated episode is marked with a small &#x2713; . An episode that a *different* annotator has already labelled is flagged separately — this is expected, since we collect multiple independent annotations per episode to measure inter-annotator disagreement.

To work through a large session efficiently:

- **← / →** step to the previous and next episode.
- **Next unannotated** jumps straight to the next episode that isn't fully annotated, skipping everything you have already done.
- **Hide annotated** removes fully annotated episodes from the list entirely.
- **Auto-advance** moves to the next episode automatically after each save.
- The **search box** filters the episode tree by filename.

<div style="clear: both;"></div>

---

### **<span style="color:#00FFFF">(3)</span> Annotation Panel**

<img src="{{ '/assets/images/annotator/questionnaire.png' | relative_url }}" alt="Questionnaire" style="float: right; width: 50%; margin: 0 0 1rem 1.5rem;" />

After reviewing the video, use the annotation panel to fill out the annotation questionnaire. 

To display instructions and definitions for the failure categories, you can hover over the small question mark beside each category. 

Please select all failures that appear during a trajectory. For example, if the robot fails to grasp an object, and knocks another object over, it would be appropriate to select both "Grasp failure" and "Collision failure". Sometimes it might also be ambiguous if a failed grasp should be classified as e.g. a reaching or a grasping failure. In these cases, please again mark all categories that could reasonably apply.
Part of our project goal is to obtain data on inter-annotator disagreement on robotic failures, so we expect some variation and disagreement between different annotators.

<div style="clear: both;"></div>

#### Questions

| Question | Type | Shown when | Notes |
|:---------|:-----|:-----------|:------|
| **Did the robot succeed?** | Radio | always | `Success` or `Failure` |
| **Success quality** | Radio | on success | Three categories, see below |
| **Describe what went wrong** | Text area | on failure | Free-text description |
| **Failure categories** | Checkbox | on failure | Select all that apply |
| **Severity** | Radio | always | Failure impact, or the severity of a success's side-effects |
| **Additional notes** | Text | always | Free-form field for any extra context |

Only the success/failure radio is required by the form itself. For an episode to pass upload validation, a failure must have its **description, categories and severity all filled in, or all three left empty** — a half-filled failure is rejected. Successes have no such requirement.

To speed up repetitive labelling, **Copy from a previous annotation** offers your own recent, distinct failure annotations for reuse; picking one fills in its categories, severity and description, which you can then edit.

#### Success quality

Not every success is clean, and the difference matters for training data. When you mark an episode a success you can additionally record:

| Category | Meaning |
|:---------|:--------|
| **Clean success** | Task completed correctly with no notable side-effects or inefficiencies. |
| **Success with side-effects** | Task completed, but with unintended side-effects (e.g. knocked over a nearby object, minor collision) that did not prevent completion. |
| **Suboptimal execution** | Task completed, but inefficiently or awkwardly (e.g. many retries, a very indirect path, near-misses). |

#### Failure categories

The failure taxonomy distinguishes where in the manipulation pipeline the breakdown occurred:

| Category | Meaning |
|:---------|:--------|
| **Reaching failure** (pre-contact) | Robot fails to reach the target; no contact is made. If a grasp barely misses, classify as *grasp failure* instead. |
| **Grasp failure** (at contact) | Robot makes contact but fails to grasp correctly — slips, drops, or grasps incorrectly. |
| **Manipulation failure** (post-contact) | Robot grasps successfully but fails during subsequent manipulation (e.g. grasps a door handle but cannot open the door). |
| **Sequencing or semantic failure** | Wrong action or wrong object — executing a related but incorrect action such as picking the wrong item. |
| **Collision failure** | Failure due to collision with the environment or an obstacle. Can co-occur with other categories. |
| **Hardware/mechanical issue** | Failure caused by robot hardware rather than the policy. |
| **Task not attempted** | Robot makes no discernible attempt — use for stalling episodes. |
| **Other** | Any failure mode not covered above. Please describe it in the free-text field. |

Multiple categories can be selected simultaneously.

#### Severity

The severity rating helps downstream filtering. It applies to failures (how bad the failure was) and to successes (how bad the side-effects were):

- **Low** — no damage, can be immediately reset and reattempted
- **Medium** — some damage or risk of damage, or significant reset required, but reattemptable
- **Catastrophic** — significant damage or risk; cannot be reattempted without repair

---

## In-the-loop annotation

<img src="{{ '/assets/images/annotator/in-the-loop.png' | relative_url }}" alt="Annotation tool overview" style="float: right; width: 100%; margin: 0 0 1rem 1.5rem;" />

If the rollout annotator is started in-the-loop during robot execution as described in the [data collection]({% link data-collection.md %}) instructions, an additional page is displayed before annotation. This page allows a user to input a natural language instruction for the task easily. After submitting the instructions, the page will display a waiting annotation while the robot is operating, and return to the annotation overview page after the rollout is finished.

A new rollout will be automatically started after submitting the annotation, or by clicking the "Start new Rollout" button in the top right corner of the screen. 

---

## Data output

After each annotated rollout, the annotations are saved back in the original HDF5 file for each episode.
