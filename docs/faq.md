---
title: Frequently Asked Questions
layout: default
nav_order: 5
permalink: /faq/
---

# FAQ & Debugging Help

## Data Format

### What do I do if my policy provides a different action encoding?
If possible, please provide **absolute cartesian endeffector actions** or another [accepted action representation]({% link format.md %}). For some embodiments, such as the DROID Franka arm, we are aiming to provide utilities to translate actions.

If your policy currently does not support any of the supported action representations, and you have no way of computing them from the generated actions, please let us know. We are open to expand the action representations supported by this project. However, expanding the set of supported action representation requires some consideration to ensure that the data remains interoperable between different labs.

### We already collected data. Can we just upload that?

If you already have a large set of collected failures, you can follow the [guidelines]({% link conversion.md %}) on writing a conversion script. As each lab collects data in a different format, and conversion might be non-trivial, we are also very happy to help with your specific setup. Please just send us an [email]({% link team.md %}) and we will work with you to make your data submission ready in no time.

---

## Annotation Tool

### The data annotation tool shows a MIME type error?

MP4 videos can be saved in different formats. To properly use the web viewer, you need to save the video in a browser compatible encoding. The episode recorder has utilities for this.

### The camera name is displayed, but the video is not?

This is likely because the path provided in the HDF5 file does not correspond to the video file path. Video file paths are encoded *relative* to the HDF5 file location, so if you moved the files, make sure that the relative positions are still correct. Common issues include having the video placed in the parent directory of the HDF5 file originally (as indicated by a leading `../`).


---

## Data Labelling, Quality, and Upload

### What should we count as a failure?

One issue with robotics evaluation is that the exact line between success and failure is blurry. However, instead of attempting to delineate clear cut criteria, which would not fit most use cases, the dataset captures human robot operators' definitions of success and failure. This means it is up to the individual operator who sets the task to decide whether it was completed successfully.

This reflects a data-centric philosophy, which will enable AI approaches to learn how humans perceive and describe failures, instead of attempting to impose a hard definition of failure a priori.

### We have bulk data that was gathered in the past, and we can't annotate it. Can we still submit it?

The minimum labels we need are success and failure per trajectory. If you have bulk data for which filling out the whole questionnaire is too cumbersome, please let us know. We will find a good way for you to contribute the data.

### Can we use AI tools to annotate the data?

For now, we only accept _human-written_ annotations.
If you believe that you have a robust and reliable AI toolchain to label data, please let us know. We are currently evaluating open source tooling for this task, but have not found available models to be precise enough to describe failure modes.

If you are interested in conducting further research on this topic, we would love to coordinate efforts. Simply send us a mail on how we can best support your efforts.


---

## Robot Embodiments and Policies

### We want to contribute data on a different robot embodiment. How can we do that?

In general, we are happy to take data from a large variety of embodiments. 
However, we restrict the current version of the dataset to one or two-arm manipulation setups. We have some support for mobile manipulation platforms, however our failure annotation taxonomy is focused on manipulation failures specifically and does not address other issues such as navigation or human-robot interaction. If you have questions about supporting a specific robot arm or embodiment, feel free reach out to us or open an issue on GitHub.

In the future, we are interested in broadening the categories of failures we consider, so get in touch with us if you work on a different aspect o0f robotics (social navigation, off-road navigation, agile locomotion, etc.).
