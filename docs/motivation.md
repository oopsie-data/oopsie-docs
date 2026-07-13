---
title: Project Motivation
layout: default
nav_order: 3
permalink: /motivation/
---

# Why collect suboptimal and failure data

## The gap in robot learning

Large-scale datasets have transformed robot learning by enabling behavior cloning at scale. [BridgeData V2](https://rail-berkeley.github.io/bridgedata/) showed that a single policy could generalize across tasks and scenes; [Open X-Embodiment](https://robotics-transformer-x.github.io/) pooled data across labs and robot embodiments; [DROID](https://droid-dataset.github.io/) brought in the scene diversity that lead to the emergence of open-world generalization. But these datasets share a common trait: **they only contain successful teleoperated demonstrations.**

A policy learns what to do from them, but never what *not* to do. It cannot tell where a task is unforgiving, because it has never seen the thin margin at a grasp or an insertion actually violated, and it cannot learn to avoid a failure it has never been shown. That ignorance compounds: clean demonstrations trace a narrow corridor through state space, so the first slipped grasp or nudged object puts the policy somewhere it has never been, with no example of how to recover.

## What failure data unlocks

- **Offline RL.** Value functions need to know what a bad state is worth, and that requires penalty signal and counterfactual actions — the branches the policy could have taken and what happened when it did. Success-only data has neither: every action is optimal, so there is nothing to compare against.
- **Reward modeling.** Reward models are learned from contrast, and real failures and near-misses supply the negative half that is currently synthesized with noise or relabelling.
- **Failure prediction and policy steering.** Failure data helps train classifiers on when failures occur, and unlocks the ability to steer policies away from known failure modes during execution time.
- **World modeling.** Action-conditioned dynamics prediction relies on broad coverage of the state and action spaces. Failures and subotpimal data contains contact events and object configurations that clean teleoperation never visits.
- **Intervention systems.** Once you can predict failure, you can act on it: hand control back to a human, or trigger a recovery behavior, before the rollout is lost.

## Why now?

Over the past 1-2 years, the community has built the training and inference infrastructure for generalist robot policies (OpenVLA, openpi, and others). As a result, labs everywhere are running policy inference on real robots far more than they were a few years ago.

Those rollouts are the data. **Every one of them is a real robot acting under a real policy, succeeding and failing in exactly the ways we need to capture** — and almost all of them are deleted the moment the success rate is written down. The bottleneck is not collection anymore. It is that nobody is keeping what is already being collected.

That is the gap this project fills, and it needs **your** help.
