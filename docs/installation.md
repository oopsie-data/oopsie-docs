---
title: Installation
layout: default
nav_order: 10
parent: Oopsie ToolKit
permalink: /installation/
---

# Installation

The toolkit is published on PyPI as
[`oopsie-data-tools`](https://pypi.org/project/oopsie-data-tools/). You can install it directly via `pip`.

### Using venv/pip
```bash
# Create your environment and activate it!

pip install oopsie-data-tools
```

### Using uv

```bash
uv add oopsie-data-tools              # into an existing uv project
uv tool install oopsie-data-tools     # or standalone, just for the oopsie-data command
```

We have tested all of our tooling with python versions 3.8 and 3.12. In principle, other python versions should also work, please open an issue if you run into issues.


Optionally, we provide extras for using the droid example scripts. However, these are only used for the droid inference example scripts, so you will most likely not need them if you use the tool on its own.

```bash
uv add "oopsie-data-tools[droid]"   # In-the-loop rollout annotation for droid
```

### From a checkout

You only need a clone if you want to modify the toolkit itself, or want the bundled example
scripts and robot profiles at hand:

```bash
git clone https://github.com/oopsie-data/oopsie-data-tools
cd oopsie-data-tools

pip install -e .            # or: pip install -e ".[droid]"
# or, with uv:
uv sync                     # or: uv sync --extra droid
```

## The `oopsie-data` command

Installing the package puts an `oopsie-data` command on your `PATH`. The main commands for setup and usage are:

```bash
oopsie-data init                                 # first-time setup (lab id + HF token)
oopsie-data new-profile                           # creates a new robot profile
oopsie-data annotate --samples-dir ./samples     # launch the web annotation UI
oopsie-data validate --path ./samples            # check episodes against the schema
oopsie-data upload   --path ./samples            # validate, then upload to HuggingFace
```

`oopsie-data --help` lists every command, including the troubleshooting ones
(`submissions`, `inspect`, `restructure`), and `oopsie-data <command> --help` documents one
command's flags with worked examples.

If you installed into a uv project, prefix the commands with `uv run` (`uv run oopsie-data ...`)
or activate the environment first.

## Config locations

Using the oopsie-data tool requires two configs: your lab contributor config, which registers
all information you need to submit the data to our repository, and the robot profile, which
documents important details about your physical setup and is used to format and validate the data.
The robot profile is described in detail [on its own page]({% link robot-profile.md %}).

### Your credentials

`contributor_config.yaml` holds your lab ID and HuggingFace token.  You will receive these after registering
as a project contributor. It belongs to you and your lab and is
shared by every lab project, so it is looked up in this order:

1. `$OOPSIE_CONFIG_DIR`, if set
2. `~/.config/oopsie-data` (or `$XDG_CONFIG_HOME/oopsie-data`)
3. the `configs/` directory of an `oopsie-data-tools` checkout

Use `oospie-data init` to set up a clean config and follow the prompts.

Every command also accepts `--config-dir` to override the location for a single run:

```bash
oopsie-data --config-dir /path/to/oopsie-config upload --path ./samples
```

### Checking what configs are used

`oopsie-data show-config` prints the paths that are currently used to look up the configs
, marks the location actually being used,
and shows the lab id and HuggingFace token in effect (the token masked unless you pass
`--show-token`). It is read-only — use `init` to change anything.


## Known issues

### FFMPEG / Python 3.8
When using python version 3.8, ffmpeg is not automatically installed together with the python package. A system-wide ffmpeg needs to be installed via your system package manager.
