---
title: Home
layout: home
nav_order: 1
permalink: /
---

# Oopsie Data

![Logo]({{ '/assets/images/logo.png' | relative_url }})

**[Oopsie Dataset](https://github.com/cvoelcker/robotic_failure_data) project's software toolkit for collecting, annotating, and managing robotic manipulation failures.**

This website explains the software tools for contributing failure data to the dataset: a multi-lab effort to build a large-scale dataset of robotic manipulation failures for offline RL, policy steering, and failure prediction.

The goal of this project is to enable research into how policy evaluation data, especially failures alongside successes, can improve robot policy training.
Failed demonstrations are routinely collected during testing and evaluation, but immediately discarded as they provide no further use in common imitation learning pipelines.
However, these failures contain crucial information about where current approaches break down, and can be used to train robots to recognize bottleneck states or request intervention from human operators.

To support research into how robotic failures can be used effectively, we need a varied dataset spanning different robot policies, tasks, and setups.
Therefore, we share our tooling for collecting and annotating policy evaluation trajectories together with a **Call for Contributions**.
Share your policy evaluation data with us, successes and failures, so that we can build datasets to enable the robotics community to investigate how to make full use of the data we produce every day.

## What this website provides

This website explains how to collect, annotate, and contribute data to our effort.

[Motivation]({% link motivation.md %}) provides a more in-depth overview of the research vision.

[Contributing]({% link contributing.md %}) describes how to sign up for contributing data, how to upload annotated and collected data, and what benefits are available for contributing labs.

[Dataset Format]({% link format.md %}) describes the format required for data submissions.

[Data Collection]({% link data-collection.md %}) explains the workflow we recommend for collecting evaluation data, and the tools we provide to simplify collection and annotation.

[Annotation]({% link annotator.md %}) explains the interface of the annotation tool and provides detailed information on the annotation questions.

[Frequently Asked Questions]({% link faq.md %}) is a collection of frequent issues and questions that might arise during the use of our workflow. This is being continually expanded, and we invite you to open issues on github for any unanswered questions.

## An example of a common evaluation failure
<div style="background: var(--sidebar-color, #f5f6fa); border: 1px solid var(--border-color, #e1e4e8); border-radius: 8px; padding: 1.5rem 1.5rem 1rem; margin: 1.5rem 0;">
  <p style="margin: 0 0 1rem; font-size: 0.95rem; color: var(--body-text-color, #444);">
    Below are two example episodes from the initial dataset: one successful grasp and one failure on an Aloha robot using a diffusion policy. Recorded under similar conditions with the same policy, they highlight the fine-grained differences the dataset is designed to capture.</p><p>
    Even in a simple ball-grasping task, a slight gripper offset can cause failure.
    Capturing these nuances (and other common failure modes) is a core goal of this project.
  </p>
  <div style="display: flex; gap: 1.25rem; flex-wrap: wrap;">
    <div style="flex: 1; min-width: 220px; text-align: center;">
      <video controls muted loop style="width: 100%; border-radius: 6px; border: 1px solid var(--border-color, #ddd);">
        <source src="{{ '/assets/videos/success_0.mp4' | relative_url }}" type="video/mp4">
      </video>
      <p style="margin: 0.5rem 0 0; font-size: 0.85rem; font-weight: 600; color: #2e7d32;">
        Successful episode
      </p>
      <p style="margin: 0.2rem 0 0; font-size: 0.8rem; color: var(--body-text-color, #555);">
        The robot is able to pick up the ball and place it in the bowl.
      </p>
    </div>
    <div style="flex: 1; min-width: 220px; text-align: center;">
      <video controls muted loop style="width: 100%; border-radius: 6px; border: 1px solid var(--border-color, #ddd);">
        <source src="{{ '/assets/videos/failure_1.mp4' | relative_url }}" type="video/mp4">
      </video>
      <p style="margin: 0.5rem 0 0; font-size: 0.85rem; font-weight: 600; color: #c62828;">
        Failure episode
      </p>
      <p style="margin: 0.2rem 0 0; font-size: 0.8rem; color: var(--body-text-color, #555);">
        The robot fails to grasp the ball and instead pushes it to roll off the table.
      </p>
    </div>
  </div>
</div>

---


## Links

- **GitHub**: [oopsie-data/oopsie-tools](https://github.com/oopsie-data/oopsie-tools)
- **Sign Up Form**: [Google Form](https://forms.gle/9arwZHAvRjvbozoT7)
