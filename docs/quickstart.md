---
title: Quickstart
layout: default
nav_order: 2
permalink: /quickstart/
---

# Quickstart Guide

To contribute data to the Oopsie Dataset, we ask that you collect recordings of your robot policy rollouts (e.g. policy evaluation, play data collection, online RL training), successes and failures. Our toolkit provides utilities for formatting such robot data in a consistent manner across different manipulator setups. Finally, use our annotation tool to quickly provide a brief description of each failed trajectory and upload your labeled data to the project repository.

This page provides a brief overview of all the necessary steps to contribute to the project using our tooling:
1. [Registration](#1-registration)
2. [Installation and setup](#2-installation-and-setup)
3. [Data recording and annotation](#3-data-recording-and-annotation)
4. [Data submission](#4-data-submission)

For each step, we provide a quick overview below; more detailed instructions and code examples are provided in the [Oopsie Toolkit]({% link oopsie-tools.md %}) section of this website. If you run into any issues, please reference it for any additional information and check the [FAQ]({% link faq.md %}) as well. If you still have questions, do not hesitate to open an issue on [github](https://github.com/oopsie-data/oopsie-tools) or contact the [team]({% link team.md %}).

{: .note }
> **Using a coding agent?** Point Claude Code, Codex, or Cursor at [`AI_CONTEXT.md`](https://github.com/oopsie-data/oopsie-tools/blob/main/AI_CONTEXT.md) and it can integrate the Oopsie toolkit into your existing rollout code for you.

---

## 1. Registration

To submit data to the official Oopsie Data Project, you need to register your lab. We will review the registration and send you the lab-specific ID and huggingface token which are used to submit data to the central repository. Only your lab will have access to this data until the public release, and we will notify all contributors before their data gets released!

To register, please use the [registration form](https://forms.gle/9arwZHAvRjvbozoT7). We only need one registration per lab. If your lab is already registered, please contact your lab contact to get the submission token.

---

## 2. Installation and setup

### 2.1 Installation
[(Full instructions)]({% link installation.md %})

To install our data collection and annotation tooling, we recommend using `uv` or `pip`. We tested our toolkit with python versions 3.8 and 3.12, please contact us if you run into trouble with another version.

To download and install the `oopsie-tools` package, simply activate your environment and run

```
git clone https://github.com/oopsie-data/oopsie-tools
cd oopsie_tools

pip install -e .
```

### 2.2 Creating a robot profile
[(Full instructions)]({% link robot-profile.md %})

Oopsie-data is a cross-embodiment dataset, and we use a robot profile to detail the specific robot and controller setup used from each contribution.
The robot profile also captures the policy used for the rollout, since some keys, such as the action space, can be different for different policies on the same robot embodiment. This means you should overwrite the policy field or create a separate profile for policies with different action spaces.

A template and example robot profiles can be found in [config/robot_profiles](https://github.com/oopsie-data/oopsie-tools/tree/main/configs/robot_profiles). 
Start by modifying the template (or the closest existing profile) to reflect your robot and controller setup. For details on the robot profile format, please refer to the full instructions.

### 2.3 Setting up the contributor config
To contribute data, you will need to put the lab id and huggingface token you received after registration in `configs/contributor_config.yaml`. Please make sure that you use the exact provided lab id (including capitalization) otherwise you cannot access the lab-specific repository.

```yaml
lab_id: <EXACT_LAB_ID>
huggingface_token: <HF_TOKEN>
```

---

## 3. Data recording and annotation

### 3.1 Data collection
[Full instructions]({% link data-collection.md %})

If you are using a standard framework for policy execution and evaluation, check the examples provided in [`examples/inference_examples`](https://github.com/oopsie-data/oopsie-tools/tree/main/examples/inference_examples) for a growing list of ready-to-use scripts.

Oopsie-tools supports three workflows for data collection and annotation:
1. **In-the-loop collection and annotation**: As the policy rollout each episode on the robot, collect the data and annotate as each episode finishes. For a minimal code example, see option 1 [here]({% link data-collection.md %}#1-in-the-loop-collection-and-annotation).
2. **Bulk collection and annotation**: Use the tool to record many rollout episodes data at once, then annotate the data in a separate step after all rollout data is collected. For a minimal code example, see option 2 [here]({% link data-collection.md %}#2-bulk-collection).
3. **Custom collection and bulk annotation**: If your setup is incompatible with our EpisodeRecorder, or if you have already collected data and simply want to format it into the Oopsie Data format for annotation and submission, see option 3 [here]({% link data-collection.md %}#3-custom-collection-and-bulk-annotation).

### 3.2 Annotation
[(Full instructions)]({% link annotator.md %})

We provide a web-based annotation tool that allows you to quickly annotate your data with information about the suboptimalities or failures that occurred during the rollout.
<!-- At minimum, each episode needs to be marked as a `success` or `failure` and the `Describe what went wrong` field needs to be filled. In addition, we allow each annotator to fill out a short failure questionnaire. -->

<!-- To launch the tool in your browser after collecting data, simply run

```
python -m oopsie_tools.annotation_tool.annotator \
    --samples-dir <DIR> --port <PORT> --annotator-name <YOUR_NAME>
```

The `samples_dir` should be the top level directory where your samples were recorded, the `port` specifies on which port the webserver can be accessed (navigate to `localhost:<port>` to see the web interface) and `annotator_name` records who provided the annotation. -->

---

## 4. Data submission
[Full instructions]({% link upload.md %})

To submit your data, you need to ensure that you have provided the lab_id and huggingface token, and that your data is properly annotated.
After doing this, you can simply run
```
python scripts/validate_and_upload/upload.py \
  --path /path/to/formatted_data \
```
