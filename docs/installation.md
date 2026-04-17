---
title: Installation
layout: default
nav_order: 1
parent: Oopsie ToolKit
permalink: /installation/
---

# Installation

To install our data collection and annotation tooling, you can use the following commands. We provide support for installing our tooling with both pip and uv.

We have tested all of our tooling with python versions 3.8 and 3.12. In principle, other python versions should also work, please open an issue if you run into issues.

### Using venv/conda/pip

```bash
# Create your environment and activate it!

# Clone and install base dependencies
git clone https://github.com/oopsie-data/oopsie-tools
cd robotic_failure_data

pip install -e .
```

Optional extras for using the droid example scripts:

```bash
pip install -e ".[droid]"   # In-the-loop rollout annotation for droid
```

### Using uv
```bash
# Clone and install base dependencies
git clone https://github.com/oopsie-data/oopsie-tools
cd robotic_failure_data
uv sync
```

Optional extras for using the droid example scripts:

```bash
uv sync --extra droid   # In-the-loop rollout annotation for droid
```
