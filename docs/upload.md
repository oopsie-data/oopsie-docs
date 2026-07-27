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

Before uploading, create a local contributor config in your `oopsie-data-tools` checkout at
`configs/contributor_config.yaml`:

```yaml
lab_id: <EXACT_LAB_ID>
huggingface_token: <HF_TOKEN>
```

This file will tell the upload script which HuggingFace dataset repo to upload your data to, and authenticate the push. Your episodes are pushed to `OopsieData-Submissions/<lab_id>`, so the `lab_id` must match the one you were given exactly, including capitalization.
Keep it private and do not commit it.

{: .note }
> If `HF_TOKEN` is set in your environment, it takes precedence over `huggingface_token` from the config. The config is only read when actually uploading, so validation and `--skip_upload` work on a fresh checkout without it.

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
1. Check the folder size, aborting if any directory exceeds 10,000 files (see below)
2. Validate the episode(s), aborting on the first failure
3. Check task and annotation diversity (advisory, unless `--strict-diversity`)
4. Log in to HuggingFace and create the dataset repo if it doesn't exist
5. Upload all files

> Uploads are **additive** — existing episodes in the repo are not deleted.
> Each run adds or updates only the files you push.

### All upload.py flags

| Flag | Default | Description |
|---|---|---|
| `--path` / `-o` | required | Base directory containing formatted episode files |
| `--episode_id` / `-e` | none | Episode to validate and upload; if omitted, all *.h5 files in `path` are processed |
| `--skip_validate` | false | Skip validation before uploading |
| `--skip_upload` | false | Run validation only and do not upload |
| `--log-path` / `-l` | none | Write the validation log to this file in addition to the console |
| `--strict-diversity` | false | Treat low task/annotation diversity warnings as a hard error |

Both scripts exit `0` when everything passed and `1` otherwise, so they can be chained in a shell pipeline.

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
| `Missing root attr: X` | Re-run your converter, or manually add the missing field |
| `MP4 file does not exist` | Video paths inside the HDF5 are relative to the HDF5 file; check they exist |
| `Video too large` | Frames exceed 1280 px on a side — `convert_ar_aloha_data.py` resizes automatically |
| `Video too small` | Frames are under 180 px on a side |
| `Episode length ... outside` | Episode is outside the 1–300 second range; check trajectory length and `control_freq` |
| `Frame count / trajectory mismatch` | The video has a different number of frames than the recorded trajectory |
| `lab_id has not been changed from the placeholder value` | Fill in the real `lab_id` in `configs/contributor_config.yaml` |
| `Not logged in` | Add a valid `huggingface_token` to `configs/contributor_config.yaml`, or set `HF_TOKEN` |

### Very large folders

`upload.py` aborts before uploading if any directory holds more than 10,000 files, which is the HuggingFace Hub per-directory limit. Run `python scripts/validate_and_upload/restructure_large_folder.py --source <dir>` first: it **copies** episodes into numbered subfolders (leaving the source untouched) and rewrites the video paths stored inside each HDF5 to match.

### Inspecting an episode

To dump the contents of a single HDF5 episode — attributes, groups, dataset shapes and annotations — use `python scripts/inspect_h5.py <file.h5>`. This is the quickest way to see what a validation error is referring to.
