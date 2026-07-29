---
title: Home
layout: home
nav_order: 1
permalink: /
---

<h1 class="home-title" id="oopsie-data">
  <img src="{{ '/assets/images/logo.png' | relative_url }}" alt="" aria-hidden="true">
  <span>Oopsie Data</span>
</h1>

> All successful robots are alike; each unsuccessful robot is unsuccessful in its own way.
>
> <cite>L30 Tolstoy, Anna Kareni-Bot</cite>

<figure class="home-teaser">
  <img
    src="{{ '/assets/images/teaser_image.jpg' | relative_url }}"
    alt="Overview of robot rollout examples—failures, suboptimal outcomes, and successes—flowing into the Oopsie Data dataset and its research applications."
  >
</figure>

**Oopsie is a multi-lab effort to build the first large-scale dataset of *real* robot manipulation failures.**

Today's robotics datasets contain only successes. But a policy that has only seen things go right never learns what a bad grasp looks like and how to avoid failures. The failures scenarios that would teach it this are produced constantly, during policy rollouts in every lab, but are ignored and thrown away.

We want to stop throwing them away. Real failures and suboptimal behavior are the missing ingredient for reinforcement learning, reward modeling, failure prediction, and world modeling, and no amount of synthetic noise injection substitutes for them. Getting there takes data spanning many robots, tasks, and setups, which is more than any single lab can collect.

**So here is our ask: next time you rollout a policy on the real robot (e.g. policy evaluation, play data collection, online RL training, etc.), keep the rollouts and send them to us, failures and successes alike.** We provide a [quickstart]({% link quickstart.md %}) to get going as soon as you sign up, and contributing labs get early access to the dataset and co-authorship on the public release.

---


## An example of a common evaluation failure
<div class="example-box">
  <p style="margin: 0 0 1rem; font-size: 0.95rem;">
    Below are two example episodes from the initial dataset: one successful grasp and one failure on an Aloha robot using a diffusion policy. Recorded under similar conditions with the same policy, they highlight the fine-grained differences the dataset is designed to capture.</p><p>
    Even in a simple ball-grasping task, a slight gripper offset can cause failure.
    Capturing these nuances (and other common failure modes) is a core goal of this project.
  </p>
  <div style="display: flex; gap: 1.25rem; flex-wrap: wrap;">
    <div style="flex: 1; min-width: 220px; text-align: center;">
      <video controls muted loop style="width: 100%; border-radius: 6px; border: 1px solid var(--border-color, #ddd);">
        <source src="{{ '/assets/videos/success_0.mp4' | relative_url }}" type="video/mp4">
      </video>
      <p style="margin: 0.5rem 0 0; font-size: 0.85rem; font-weight: 600; color: #3e801e;">
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
      <p style="margin: 0.5rem 0 0; font-size: 0.85rem; font-weight: 600; color: #aa1910;">
        Failure episode
      </p>
      <p style="margin: 0.2rem 0 0; font-size: 0.8rem; color: var(--body-text-color, #555);">
        The robot fails to grasp the ball and instead pushes it to roll off the table.
      </p>
    </div>
  </div>
</div>
