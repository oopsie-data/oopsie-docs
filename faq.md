---
title: Frequently Asked Questions
layout: default
nav_order: 9
permalink: /faq/
---

# FAQ & Debugging Help

## Data format

### What do I do if my policy provides a different action encoding?
If possible, provide **absolute cartesian endeffector actions**. For some embodiments, such as the DROID Franka arm, we provide utilities to translate actions.

If your policy currently does not support cartesian end-effector actions, and you have no way of computing them from the generated actions, please let us know so that we can make sure your data is post-processed correctly. However, please ensure that all actions are still **unnormalized**, as we do not support saving and uploading custom normalization and denormalization schemes.

## Annotation tool

### The data annotation tool shows a MIME type error?

MP4 videos can be saved in different formats. To properly use the web viewer, you need to save the video in a browser compatible encoding. The episode recorder has utilities for this.

### The camera name is displayed, but the video is not?

This is likely because the path provided in the HDF5 file does not correspond to the video file path. Video file paths are encoded *relative* to the HDF5 file location, so if you moved the files, make sure that the relative positions are still correct. Common issues include having the video placed in the parent directory of the HDF5 file originally (as indicated by a leading `../`).

## Data labelling, quality, and upload

### What should we count as a failure?

One issue with robotics evaluation is that the exact line between success and failure is blurry. However, instead of attempting to delineate clear cut criteria, which would not fit most use cases, the dataset captures human robot operators' definitions of success and failure. This means it is up to the individual operator who sets the task to decide whether it was completed successfully.

This reflects a data-centric philosophy, which will enable AI approaches to learn how humans perceive and describe failures, instead of attempting to impose a hard definition of failure a priori.

### We have bulk data that was gathered in the past, and we can't annotate it. Can we still submit it?

The minimum labels we need are success and failure per trajectory. If you have bulk data for which filling out the whole questionnaire is too cumbersome, please let us know. We will find a good way for you to contribute the data.

### Can we use AI tools to annotate the data?

If you believe that you have a robust and reliable AI toolchain to label data, please let us know. We are currently evaluating open source tooling for this task, but have not found available models to be precise enough to describe failure modes.

## Robot embodiments and policies

### We want to contribute data on a different robot embodiment. How can we do that?

In general, we are happy to take data from a large variety of embodiments. 
However, we restrict the current version of the dataset to one or two-arm fixed tabletop setups with pincer grippers. If you have questions about supporting a specific robot arm, feel free reach out to us or open an issue on GitHub.

In future iterations, we will consider encompassing more diverse embodiments such as complicated end-effectors or mobile manipulation platforms. However, since these complicate parts of the project, such as the data format standardization and failure annotation questionnaire, we currently limit data submission to fixed tabletop manipulation setups such as the DROID and Aloha systems.