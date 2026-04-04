---
title: Data Submission
layout: default
nav_order: 6
parent: Contributing
permalink: /upload/
---


Data contribution to the projects can be made by submitting the data using our upload scripts to HuggingFace.
As long as your data matches the required [format](/format) and you have a
HuggingFace access token, you can use these tools to contribute — regardless of robot
platform, data collection setup, or institution.

If your data is not yet in the required format, see [Data Conversion](/conversion) first.

---

## Folder contents

| File | Purpose |
|---|---|
| `upload.py` | Validate → upload pipeline for already formatted episodes |
| `validate.py` | Standalone validator + gap analysis tool |


## Step 1 — Get a HuggingFace token

1. To get an access token to the dataset org, you have to [register your lab](/contributing) and follow the provided instructions.

---

## Step 2 — Validate your episode

Run validation to confirm your data matches the required format:

```bash
python robotic_failure_data/scripts/validate_and_upload/validate.py \
  --session /path/to/session
```

A passing run looks like:

```
Running tests: [████████████████████] 4/4 (100%)
✓ All validation tests passed for episode 000000
```

If validation passes, proceed directly to **Step 3 — Upload**.

If it fails, the error message will tell you exactly what is missing or malformed.
See [If your data needs conversion](#if-your-data-needs-conversion) below.

---

## Step 3 — Upload to HuggingFace

```bash
python upload.py \
  --output_dir /path/to/formatted_data \
  --episode_id 000000 \
  --token      $HF_TOKEN
```

The script will:
1. Check and install dependencies
2. Log in to HuggingFace
3. Validate the episode
4. Create the dataset repo if it doesn't exist
5. Upload all files

> Uploads are **additive** — existing episodes in the repo are not deleted.
> Each run adds or updates only the files you push.

### All upload.py flags

| Flag | Default | Description |
|---|---|---|
| `--output_dir` / `-o` | `formatted_data/` | Base directory containing formatted episode files |
| `--episode_id` / `-e` | `000000` | Episode to validate and upload |
| `--repo` / `-r` | `UT-Robotics-Failure-Dataset/AR-ALOHA-Bin-Pick-and-Stack` | HF dataset repo |
| `--token` | `$HF_TOKEN` env var | HuggingFace API token |
| `--skip_validate` | off | Skip validation before upload |
| `--skip_upload` | off | Validate only, do not upload |

---

## Troubleshooting

| Error | Fix |
|---|---|
| `H5 file does not exist` | Check `--base_path` and `--episode_id`; file must be named `<episode_id>_trajectory.h5` |
| `Missing top-level key: X` | Re-run your converter, or manually add the missing field |
| `MP4 file does not exist` | Video paths inside the HDF5 are relative to `base_path`; check they exist |
| `Image size too large` | Source frames exceed 1080px — `convert_ar_aloha_data.py` resizes automatically |
| `Video duration too short/long` | Episode is outside 2–300 second range; check frame count and FPS |
| `Not logged in` | Set `export HF_TOKEN=hf_...` or pass `--token` explicitly |
