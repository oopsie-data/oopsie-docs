---
title: Quickstart
layout: default
nav_order: 2
permalink: /quickstart/
---

# Quickstart Guide

This page provides a brief overview of all the necessary steps to contribute to the project:
1. [Registration]({% link quickstart.md %}/#registration)
2. [Installation and setup]({% link quickstart.md %}/#installation-and-setup)
3. [Data recording and annotation]({% link quickstart.md %}/#data-recording-and-annotation)
4. [Data submission]({% link quickstart.md %}/#data-submission)

For each step, we provide more detailed instructions on the code and API documentation in the [Oopsie Toolkit]({% link oopsie-tools.md %}) section of this website. If you run into any trouble, please reference it for any additional information and check the [FAQ]({% link faq.md %}) as well. If you still have questions, do not hesitate to open an issue on [github](https://github.com/oopsie-data/oopsie-tools) or contact the [team]({% link team.md %}).

---

## Registration

To submit data to the official Oopsie Data Project, you need to register your lab. We will review the registration and send you the lab-specific ID and huggingface token which are used to submit data to the central repository. Only your lab will have access to this data until the public release, and we will notify all contributors before their data gets released!

To register, please use the [registration form](https://forms.gle/9arwZHAvRjvbozoT7). We only need one registration per lab. If your lab is already registered, please contact your lab contact to get the submission token.

---

## Installation and setup

### Installation
[Full instructions]({% link installation.md %})

To install our data collection and annotation tooling, we recommend using `uv` or `pip`. We tested our toolkit with python versions 3.8 and 3.12, please contact us if you run into trouble with another version.

To download and install the `oopsie-tools` package, simply activate your environment and run

```
git clone https://github.com/oopsie-data/oopsie-tools
cd oopsie_tools

pip install -e .
```

### Creating a robot profile
[Full instructions]({% link robot-profile.md %})

To record robot and policy metadata, we use a setup-specific yaml file, the robot profile. A template and example robot profiles can be found in `config/robot_profiles`. To start use the template or the closest existing profile and modify it with your specific information. For a full list of keys and detailed information, please refer to the full instructions.

### Setting up the contributor config
To contribute data, you will need to put the lab id and huggingface token you received after registration in `config/contributor_config.yaml`. Please make sure that you use the exact provided lab id (including capitalization) otherwise you cannot access the lab-specific repository.

---

## Data recording and annotation

### Data collection
[Full instructions]({% link data-collection.md %})

We provide several tools to collect data and save it in the required format for annotation and submission. If you are using a standard framework for policy execution and evaluation, check the examples provided in `examples/inference_examples` for a growing list of ready-to-use scripts.

We envision three possible workflows for data collection:
1. **In-the-loop collection and annotation**: If you want to collect data and annotate each episode with success and failure and the failure description immediately, we provide an all-in-one tool that automatically saves your evaluation data and launches a browser tool for annotation. For a minimal code example, see [here]({% link data-collection.md %}#1-in-the-loop-collection-and-annotation).
2. **Bulk collection**: If you only want to record the data, and annotate each episode later, we provide a stand-alone tool for recording. For a minimal code example, see [here]({% link data-collection.md %}#2-bulk-collection)

If you have already collected data and simply want to format it into the Oopsie Data format for annotation and submission, please see the detailed information on [data formatting]({% link format.md %}) and [data conversion]({% link conversion.md %}).

### Annotation
[Full instructions]({% link annotator.md %})

To make the data useful for downstream projects, we require that each episode is annotate with failure information. At minimum, each episode needs to be marked as a `success` or `failure`.  In addition, we allow each annotator to fill out a short failure questionnaire and provide a free-text description of the failure.

To launch the tool in your browser after collecting data, simply run

```
python -m oopsie_tools.annotation_tool.annotator \
    --samples-dir <DIR> --port <PORT> --annotator-name <YOUR_NAME>
```

The `samples_dir` should be the top level directory where your samples were recorded, the `port` specifies on which port the webserver can be accessed (navigate to `localhost:<port>` to see the web interface) and `annotator_name` records who provided the annotation.

---

## Data submission
[Full instructions]({% link upload.md %})

To submit your data, you need to ensure that you have provided the lab_id and huggingface token, and that your data is properly annotated.
After doing this, you can simply run
```
python scripts/validate_and_upload/upload.py \
  --samples_dir /path/to/formatted_data \
```