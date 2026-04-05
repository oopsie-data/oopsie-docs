---
title: Dataset Contribution Guide
layout: default
nav_order: 8
permalink: /upload/
---


Data contribution to the projects can be made by submitting the data using our upload scripts to HuggingFace.
As long as your data matches the required [format]({% link format.md %}) and you have a
HuggingFace access token, you can use these tools to contribute — regardless of robot
platform, data collection setup, or institution.

If you have not used our utilities to collect and annotate data, you can still provide it to the repository.
An example converter (`convert_ar_aloha_data.py`) is included and tested, which was collected on an **Agilex bimanual robot** running the **ACT/ALOHA**
policy. The source data is in the standard ACT/ALOHA HDF5 format (14-DoF joint actions,
raw image frames at 1280×720, 1500 timesteps at 30 fps). This converter can serve as a
reference implementation for contributors working with similar robot setups or data formats.

---

## Folder contents

| File | Purpose |
|---|---|
| `scripts/validate_and_upload/upload.py` | Validate → upload pipeline for already formatted episodes |
| `scripts/validate_and_upload/validate.py` | Standalone validator + gap analysis tool |
| `scripts/dataset_conversion/convert_ar_aloha_data.py` | Example converter: ACT/ALOHA format → required dataset format |


## Step 1 — Get a HuggingFace token

1. To get an access token to the dataset org, you have to [register your lab]({% link contributing.md %}) and follow the provided instructions.

---

## Step 2 — Validate your episode

Run validation to confirm your data matches the required format:

```bash
# Validate all episodes in a directory
python scripts/validate_and_upload/validate.py \
  --output_dir /path/to/formatted_data

# Validate a single episode
python scripts/validate_and_upload/validate.py \
  --output_dir /path/to/formatted_data \
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

## Step 3 — Upload to HuggingFace

```bash
# Upload all episodes in a directory
python scripts/validate_and_upload/upload.py \
  --output_dir /path/to/formatted_data \
  --token      $HF_TOKEN

# Upload a single episode
python scripts/validate_and_upload/upload.py \
  --output_dir /path/to/formatted_data \
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
| `--output_dir` / `-o` | required | Base directory containing formatted episode files |
| `--episode_id` / `-e` | none | Episode to validate and upload; if omitted, all *.h5 files in `output_dir` are processed |
| `--repo` / `-r` | `UT-Robotics-Failure-Dataset/ROBIN` | HF dataset repo |
| `--token` | `$HF_TOKEN` env var | HuggingFace API token |
| `--skip_validate` | off | Skip validation before upload |
| `--skip_upload` | off | Validate only, do not upload |

---

## If your data needs conversion

If validation fails because your source data is in a different format, you need to write
a converter that transforms it into the required structure.

`convert_ar_aloha_data.py` is provided as a reference — it converts ACT/ALOHA format HDF5
files and can be used as a template.

### Using the existing ACT/ALOHA converter

```bash
python scripts/dataset_conversion/convert_ar_aloha_data.py \
  --source     /path/to/episode_0.hdf5 \
  --output_dir /path/to/formatted_data \
  --episode_id 000000 \
  --success    1.0 \
  --language_instruction "your task description here"
```

Then re-run validation and upload as normal.

### Writing a converter for a new format

1. Create `convert_<format_name>.py` in `scripts/dataset_conversion/`
2. Implement the following function signature:
   ```python
   def convert(
       source_h5: str,
       output_dir: str,
       episode_id: str,
       fps: int,
       success: float,
       language_instruction: str,
   ) -> str:
       """Returns path to the output HDF5 file."""
       ...
   ```
3. Run your converter first, then validate and upload:
   ```bash
   python scripts/dataset_conversion/convert_your_format.py \
     --source /path/to/data.hdf5 \
     --output_dir /path/to/formatted_data \
     --episode_id 000000

   python scripts/validate_and_upload/upload.py \
     --output_dir /path/to/formatted_data \
     --episode_id 000000
   ```

---

## Troubleshooting

| Error | Fix |
|---|---|
| `H5 file does not exist` | Check `--output_dir` and `--episode_id`; file must be named `<episode_id>_trajectory.h5` |
| `Missing top-level key: X` | Re-run your converter, or manually add the missing field |
| `MP4 file does not exist` | Video paths inside the HDF5 are relative to `output_dir`; check they exist |
| `Image size too large` | Source frames exceed 1080px — `convert_ar_aloha_data.py` resizes automatically |
| `Video duration too short/long` | Episode is outside 2–300 second range; check frame count and FPS |
| `Not logged in` | Set `export HF_TOKEN=hf_...` or pass `--token` explicitly |
