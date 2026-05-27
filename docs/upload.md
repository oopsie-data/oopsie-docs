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

Before uploading, create a local contributor config in your `oopsie-tools` checkout at
`configs/contributor_config.yaml`:

```yaml
lab_id: <EXACT_LAB_ID>
huggingface_token: <HF_TOKEN>
```

This file will tell the upload script which HuggingFace dataset repo to upload your data to, and authenticate the push.  
Keep it private and do not commit it.

To upload your data, simply execute 

```bash
# Upload all episodes in a directory
python scripts/validate_and_upload/upload.py \
  --path /path/to/formatted_data

# Upload a single episode
python scripts/validate_and_upload/upload.py \
  --path /path/to/formatted_data \
  --episode_id 000000
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
| `--path` / `-o` | required | Base directory containing formatted episode files |
| `--episode_id` / `-e` | none | Episode to validate and upload; if omitted, all *.h5 files in `path` are processed |
| `--skip_validate` | false | Skip validation before uploading |
| `--skip_upload` | false | Run validation only and do not upload |

### Validation without upload

Run validation to confirm your data matches the required format:

```bash
# Validate all episodes in a directory
python scripts/validate_and_upload/validate.py \
  --path /path/to/formatted_data

# Validate a single episode
python scripts/validate_and_upload/validate.py \
  --path /path/to/formatted_data/000000.h5
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
| `H5 file does not exist` | Check `--path` and `--episode_id`; single-episode uploads look for `<episode_id>.h5` |
| `Missing top-level key: X` | Re-run your converter, or manually add the missing field |
| `MP4 file does not exist` | Video paths inside the HDF5 are relative to `path`; check they exist |
| `Image size too large` | Source frames exceed 1080px — `convert_ar_aloha_data.py` resizes automatically |
| `Video duration too short/long` | Episode is outside 2–300 second range; check frame count and FPS |
| `Not logged in` | Add a valid `huggingface_token` to `configs/contributor_config.yaml` |
