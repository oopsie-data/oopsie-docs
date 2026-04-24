---
title: Validation and Upload
layout: default
nav_order: 50
parent: Oopsie ToolKit
permalink: /upload/
---

# Validation and Upload

Data contribution to the projects can be made by submitting the data using our upload scripts to HuggingFace.
As long as your data matches the required [format]({% link format.md %}) and you have a
HuggingFace access token, you can use these tools to contribute.

**Overview of Provided Scripts**

| File | Purpose |
|---|---|
| `scripts/validate_and_upload/upload.py` | Validate → upload pipeline for already formatted episodes |
| `scripts/validate_and_upload/validate.py` | Standalone validator + gap analysis tool |

## Upload Workflow

To upload your data, simply execute 

```bash
# Upload all episodes in a directory
python scripts/validate_and_upload/upload.py \
  --samples_dir /path/to/formatted_data \
  --token      $HF_TOKEN

# Upload a single episode
python scripts/validate_and_upload/upload.py \
  --samples_dir /path/to/formatted_data \
  --episode_id 000000 \
  --token      $HF_TOKEN
```

The script will:
1. Log in to HuggingFace
2. Validate the episode(s)
3. Create the dataset repo if it doesn't exist
4. Upload all files

> Uploads are **additive** — existing episodes in the repo are not deleted.
> Each run adds or updates only the files you push.

### All upload.py flags

| Flag | Default | Description |
|---|---|---|
| `--samples_dir` / `-o` | required | Base directory containing formatted episode files |
| `--episode_id` / `-e` | none | Episode to validate and upload; if omitted, all *.h5 files in `samples_dir` are processed |

### Validation without upload

Run validation to confirm your data matches the required format:

```bash
# Validate all episodes in a directory
python scripts/validate_and_upload/validate.py \
  --samples_dir /path/to/formatted_data

# Validate a single episode
python scripts/validate_and_upload/validate.py \
  --samples_dir /path/to/formatted_data \
  --episode_id 000000
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


## If your data needs conversion

If validation fails because your source data is in a different format, convert it first.
See the [Data Conversion](/conversion/) page for ready-made converters (ACT/ALOHA, RLDS/DROID) and instructions on writing your own.

After conversion, re-run validation and upload as normal.


---


## Troubleshooting

| Error | Fix |
|---|---|
| `H5 file does not exist` | Check `--samples_dir` and `--episode_id`; file must be named `<episode_id>_trajectory.h5` |
| `Missing top-level key: X` | Re-run your converter, or manually add the missing field |
| `MP4 file does not exist` | Video paths inside the HDF5 are relative to `samples_dir`; check they exist |
| `Image size too large` | Source frames exceed 1080px — `convert_ar_aloha_data.py` resizes automatically |
| `Video duration too short/long` | Episode is outside 2–300 second range; check frame count and FPS |
| `Not logged in` | Set `export HF_TOKEN=hf_...` or pass `--token` explicitly |
