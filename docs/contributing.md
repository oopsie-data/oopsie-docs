---
title: Contributing
layout: default
nav_order: 3
has_children: true
permalink: /contributing/
---

# Contributing

![We want you]({{ '/assets/images/we_want_you.png' | relative_url }})


The Oopsie Dataset is a **community effort**. We are collecting failure data from diverse robots, tasks, and environments.

Currently, we focus on **single-arm and bi-arm manipulator robots**. To ensure the collected data is broadly useful across different labs, we are especially interested in data from standardized setups, such as the **DROID Franka** setup, the **SERL Franka** setup, the **Trossen Aloha** setup, the **Trossen WidowX Bridgev2** setup, **YAM** or **ARX** bimanual setups, etc.
However, if you have other systems that you believe will be useful for the community, please also submit your data!
Failure data on non-standard systems is still very useful for many research directions.

---

## Who can contribute?

**Anyone who rolls out a policy on a real robot.** If the robot is moving under a policy, you are already generating the data we need:

- **Policy evaluation.** Every eval run produces exactly the mix of successes and failures we are after.
- **RL experiments.** Online training rollouts are full of the suboptimal behavior that is missing from every other dataset.
- **Play data collection.** Unscripted interaction, including the parts that go wrong.

You do not necessarily have to run anything extra; you just have to keep what you would otherwise throw away.

---

## Why should **YOU** contribute?

Open data and cross-lab collaboration are how academics take on ambitious robotics projects. Beyond that, contributing labs get:

- **A say in the dataset.** Take part in shaping the dataset and adapting the tooling, the data format, and the utilities we build around it for your use-case.
- **Early access.** Contributors get pre-release versions of the dataset for their research. Having your own robot in the dataset also means future work built on it comes with lab-specific fine-tuning data for free.
- **Co-authorship.** Everyone who collects a substantial amount of data and gives us feedback is invited as a co-author on the public release.


---

## Contribution Requirements

We welcome all levels of contribution from the community. For significant contributors, we will recognize you as a co-author on the public release and paper. Formal requirements coming soon!