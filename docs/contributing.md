---
title: Contributing
layout: default
nav_order: 3
has_children: true
permalink: /contributing/
---

# Contributing

![We want you]({{ '/assets/images/we_want_you.png' | relative_url }})

## TL;DR

1. **Join the effort:** [Sign up](https://forms.gle/9arwZHAvRjvbozoT7) to get upload credentials
2. **Review the data format:** See [Dataset Format]({% link format.md %})
3. **Collect data and annotate data:** Run your normal evaluations with the `EpisodeRecorder` and `WebAnnotator` tools.
4. **Upload** — Share failures instead of deleting them

---

## Contributing Data

The Oopsie Dataset is a community effort. We are collecting failure data from diverse robots, tasks, and environments.

Our core focus for the first iteration of the project is on single-arm and bi-arm manipulation settings.
To ensure that the data is broadly useful across different labs, we are especially interested in data from standardized setups, such as the Franka-arm setup used in the Droid project, or the Aloha arms distributed by Trossen Robotics.
However, if you have other systems that you believe will be useful for the community, please submit your data!
Failure data on non-standard systems is still very useful for many research projects, such as building reliable failure detection or reward models.

---

## Steps to contribute

1. **Sign up:** To coordinate data submission, we ask that all contributing groups sign up via our [sign up form](https://forms.gle/9arwZHAvRjvbozoT7). We will review all sign-ups, clarify any questions, and then provide you with an API key to submit your data to our huggingface project.
2. **Collect data:** To collect data, we simply ask you to run policy evaluation as you normally would for your projects. Feel free to use the evaluation sessions you are running for on-going projects, for example CoRL submissions, to collect data. By using evaluation and data gathering sessions that you are running anyways, we hope that the additional effort necessary to contribute data is very low, and that we will get a diverse cross-section of tasks, policies, and setups. We are interested in policies that produce **a mix of failures and successes**, so we ask you to contribute examples of both.
3. **Annotate data:** We provide tools to annotate your data in our toolkit. We found that the easiest way to annotate the data is to integrate the tool directly into your inference script, where it will prompt you to annotate each episode after the robot has concluded it. However, since evaluation setups can be very diverse, we also provide tools for bulk annotating already collected data.
4. **Validation and upload:** To submit your data, we provide lightweight scripts that first validate the data format, and handle the huggingface upload. To get access to our huggingface organization, you will need to register so that we can provide you with an API key. Note that you retain full access to the data after upload, so you will be able to pull, edit, or even delete trajectories.
5. **Postprocessing and early release:** As we gather more data, we will regularly provide post-processed data from our project to all contributing labs for early testing.

---

## Who can contribute?

Anyone running robot manipulation experiments!

If you are evaluating policies, you are already generating the data we need.
Furthermore we want it to be as easy as possible for labs around the world to contribute.
If you find that your workflow is currently not well-supported by the provided software, let us know.
We will make sure to help you share your evaluation data.

Finally, please contact us for any suggestions! We want to make this data useful for **you and your research**.

### Why should your lab contribute?

First and foremost, because open-data and cross-lab collaboration has proven to be one of the best ways for academics to collaborate on ambitious robotics projects.

More specifically, all labs that are involved will get several benefits. First of all, we want to make this data useful for your projects, so we are happy to discuss adaptations that make our tool and data useful for your specific lab use-case. If you help us, you get a say in how the data is processed and what utilities we provide.

Second, we will regularly share pre-release versions of the dataset with all contributors so that they can prototype and test ideas with the data. We are tentatively aiming for an alpha release by the CoRL deadline, until then you can use our data exclusively if you contribute. In addition, having your own robot in a major dataset can make future projects that build on this data much easier to deploy, as you have already provided lab-specific fine-tuning data. 

Finally, we are happy to invite all volunteers who collect data and provide feedback as co-authors on our public release. 
Volunteering for data gathering is laborious and we acknowledge that by celebrating everybody who contribute significant time and effort to the project.

---

## What data do we need, specifically?

### Do include

We want data from policy executions that make a reasonable attempt at the task.
We also specifically ask you to **upload successes** as well as failures.

- Failed grasps
- Dropped objects
- Collisions (minor to moderate)
- Misaligned placements
- Recovery attempts (successful or not)

### Don't include

We only want data from rollouts where the policy has a chance of succeeding:

- Hardware malfunctions unrelated to policy
- Setup failures (missing task-relevant objects)
- Corrupted sensor data
- Episodes with missing frames
- E-stop triggers from external causes
