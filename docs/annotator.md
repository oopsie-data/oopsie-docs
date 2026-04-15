---
title: Annotation Tool
layout: default
nav_order: 3
parent: Oopsie ToolKit
permalink: /annotation/
---

# Annotation tool

The annotation tool is the primary interface for labeling robotic rollout episodes as successes or failures. After each rollout, an operator reviews video footage from one or more cameras and answers a structured questionnaire. Annotations are written to a shared JSON file and optionally embedded back into the HDF5 episode file.

Two backends are provided: a **browser-based web UI** for interactive sessions with video playback, and a **CLI interface** for headless or SSH environments.

---

## Launching the tool

### Standalone (Web UI)

The simplest way to annotate a batch of pre-recorded episodes:

```bash
./scripts/launch_annotator.sh --samples-dir ./samples --port 5001
# or directly:
uv run python -m robotic_failure_data.annotation_tool.annotator \
    --samples-dir ./samples --port 5001
```

Open `http://localhost:5001` in a browser. The tool scans `samples-dir` for HDF5 files and MP4 videos, and presents them one at a time for annotation.

### In-the-loop (Web UI or CLI)

For instructions on launching the web tool for in-the-loop annotation, see our [data collection instructions](/data-collection).

---

## Web UI

### Overview

The main view has the following components:

<img src="{{ '/assets/images/full_annotator.png' | relative_url }}" alt="Annotation tool overview" style="float: right; width: 50%; margin: 0 0 1rem 1.5rem;" />

The interface is divided into three panels:

- **Left**: video playback controls and camera selection
- **Center**: the episode video player
- **Right**: the annotation questionnaire and metadata fields

<div style="clear: both;"></div>

### Video Panel

<img src="{{ '/assets/images/view_panel.png' | relative_url }}" alt="Video panel" style="float: right; width: 50%; margin: 0 0 1rem 1.5rem;" />

The video panel displays synchronized MP4 footage from all cameras recorded during the episode. Use the playback controls to review the rollout before annotating. For multi-camera setups, tabs or a dropdown switch between views.

Each episode entry shows:
- Language instruction given to the policy
- Policy name and ID
- Number of timesteps recorded
- Timestamp of the rollout

<div style="clear: both;"></div>

### Policy & Robot Metadata

<img src="{{ '/assets/images/metadata.png' | relative_url }}" alt="Metadata" style="float: right; width: 50%; margin: 0 0 1rem 1.5rem;" />

Before the first rollout of a session, the web UI prompts for session-level metadata:

- **Annotator name** — stored with every annotation in the session
- **Robot embodiment** — selected from `annotation_tool/robot_embodiments.txt`
- **Policy** — selected from `annotation_tool/policies.txt`
- **Camera names** — which cameras are active in this session

This information is written into the HDF5 `episode_annotations` group for every episode annotated in the session.

If the web annotation tool is launched independently, the metadata can be added manually.
To simplify bulk annotation, the tool provides a quick way to apply a given annotation to all hdf5 files in one sub-directory.

It is therefore practical to group episode rollout files by robot embodiment and policy to simplify and speed up the annotation.

---

## Questionnaire

<img src="{{ '/assets/images/questionnaire.png' | relative_url }}" alt="Questionnaire" style="float: right; width: 50%; margin: 0 0 1rem 1.5rem;" />

After reviewing the video, the operator fills in the annotation questionnaire. The schema is defined in `annotation_tool/questionnaire.yaml` and can be customized without changing any Python code.

<div style="clear: both;"></div>

### Questions

| Question | Type | Required | Notes |
|:---------|:-----|:---------|:------|
| **Did the robot succeed?** | Radio | Yes | `Success` or `Failure` |
| **Failure categories** | Checkbox | Yes (on failure) | Select all that apply — skipped on success |
| **Describe what went wrong** | Text area | Yes (on failure) | Free-text description — skipped on success |
| **How severe is this failure?** | Radio | No | Three severity levels |
| **Additional notes** | Text | No | Free-form field for any extra context |

### Failure categories

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

Multiple categories can be selected simultaneously.

### Severity

For failures, an optional severity rating helps downstream filtering:

- **Low** — no damage, can be immediately reset and reattempted
- **Medium** — some damage or significant reset required, but reattemptable
- **Catastrophic** — significant damage or risk; cannot be reattempted without repair

---

## CLI

You can run the CLI for annotating the data during collection in the loop, but we currently do not offer an option for running the CLI annotator on pre-collected episodes.
The CLI annotator prompts for annotator name once at startup, then for each rollout prints the questionnaire questions with numbered options. Failure-only questions are automatically skipped when the episode is marked as a success.

---

## Data output

After each annotated rollout, the annotations are saved back in the original HDF5 file for each episode.
