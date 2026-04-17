---
title: Motivation
layout: default
nav_order: 2
permalink: /motivation/
---

# Why collect failure data

## The gap in robot learning

Large-scale robotics datasets have transformed the field. Projects like [DROID](https://droid-dataset.github.io/) contain **76,000 demonstration trajectories** across 564 scenes, enabling behavior cloning at unprecedented scale.

But these datasets share a common trait: **they only contain successes.**

### Why Success-Only Data Falls Short

When robots learn only from successful demonstrations, they miss information about how much precision a task requires.
Many manipulation tasks depend on bottleneck states such as grasps, where the margin of error is thin;
and without failures those critical moments are difficult for a policy to recognize.

In addition, existing works using failures often rely on post-hoc synthetic techniques such as corrupting demonstration actions with noise or relabelling episodes with different task commands than those actually achieved.
While useful as data augmentation, these approaches lack signal on the types of failures which **real robot policies actually make**.

### What is missing 

## Benefits of Failure Data

### Immediate Applications

1. **Offline Reinforcement Learning** 
   Train policies that understand both reward and penalty signals from real-world data.

2. **Policy Steering**
   Guide pretrained VLAs away from known failure modes without full retraining.

3. **Failure Prediction**
   Build classifiers that detect impending failures before they occur.

4. **Early Intervention Systems**
   Trigger human takeover or recovery behaviors when failure is likely.

5. **Reward model training**
   Reward models have recently become prominent, but they often need to rely on synthetic data to generate negative examples.

### Research Directions

- What visual features predict manipulation failure?
- Can failure data improve sample efficiency in online RL?
- How do different failure types (drops, collisions, stalls) cluster?
- Can models learn recovery strategies from failure-with-recovery data?

## Why Now?

Large open-source datasets are one of the major factors contributing to massive advancements in robotics at the moment. 
And every robotics lab already generates failure data. They just throw it away.

- **Policy evaluation** generates failed rollouts constantly.
- **Teleoperation sessions** include mistakes.
- **Real-world deployment** encounters edge cases.

The infrastructure for training on large scale data exists (see OpenVLA, OpenPi, etc.). We just need to feed it more diverse data. This project fills this gap, and it needs **your** help!
