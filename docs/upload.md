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
project-issued HuggingFace access token, you can use these tools to contribute.

**Overview of Provided Commands**

| Command | Purpose |
|---|---|
| `oopsie-data upload` | Validate → upload pipeline for already formatted episodes |
| `oopsie-data validate` | Standalone validator + gap analysis tool |
| `oopsie-data submissions` | Show what your lab has already uploaded |


## Upload Workflow

Make sure that your contributor configuration is set. Refer to the [installation]({% link installation.md %}) guide for instructions how to do this.

{: .note }
> If `HF_TOKEN` is set in your environment, it takes precedence over `huggingface_token` from the config. The config is only read when actually uploading, so validation and `--skip-upload` work on a fresh install without it.

To upload your data, simply execute 

```bash
# Upload all episodes in a directory
oopsie-data upload --path /path/to/formatted_data

# Upload a single episode
oopsie-data upload \
  --path /path/to/formatted_data \
  --episode-id 000000
```

The command will:
1. Check the folder size, aborting if any directory exceeds 10,000 files (see below)
2. Validate the episode(s), aborting on the first failure
3. Check task and annotation diversity (advisory, unless `--strict-diversity`)
4. Log in to HuggingFace and check that your lab's submissions repo exists
5. Upload all files

> Uploads are **additive**. Existing episodes in the repo are not deleted, but uploading the same file path twice will override existing data.

### All `oopsie-data upload` flags

| Flag | Default | Description |
|---|---|---|
| `--path` / `-p` / `--samples-dir` | required | Session directory containing formatted episode files |
| `--episode-id` / `-e` | none | Episode to validate and upload; if omitted, all *.h5 files in `path` are processed |
| `--skip-validate` | false | Skip validation before uploading |
| `--skip-upload` | false | Run validation only and do not upload |
| `--with-restructure` | false | If a directory exceeds the HuggingFace file limit, write a restructured copy to `<path>_restructured` and upload that instead of aborting. The original is left untouched, so this needs room for a second copy |
| `--log-path` / `-l` | none | Write the validation log to this file in addition to the console |
| `--strict-diversity` | false | Treat low task/annotation diversity warnings as a hard error |

The underscore spellings (`--episode_id`, `--skip_validate`, `--skip_upload`) are accepted as
aliases, so existing commands keep working.

Both commands exit `0` when everything passed and `1` otherwise, so they can be chained in a shell pipeline.

### Validation without upload

Run validation to confirm your data matches the required format:

```bash
# Validate all episodes in a directory
oopsie-data validate --path /path/to/formatted_data

# Validate a single episode
oopsie-data validate --path /path/to/formatted_data/000000.h5
```

A passing run looks like:

```
Running tests: [████████████████████] 4/4 (100%)
✓ All validation tests passed for episode 000000
```

If validation passes, proceed directly to **Step 3 — Upload**.

If it fails, the error message will tell you exactly what is missing or malformed.
See [If your data needs conversion](#if-your-data-needs-conversion) below.

### Inspecting an episode

To dump the contents of a single HDF5 episode — attributes, groups, dataset shapes and annotations — use `oopsie-data inspect <file.h5>`. The path is positional, and it works even on files that `validate` rejects, so it is the quickest way to see what a validation error is referring to.




---


## If your data needs conversion

If validation fails because your source data is in a different format, convert it first.
See the [Data Conversion](/conversion/) page for the helpers the toolkit provides and a
worked example of writing a converter.

After conversion, re-run validation and upload as normal.


---


## Troubleshooting

| Error | Fix |
|---|---|
| `H5 file does not exist` | Check `--path` and `--episode-id`; single-episode uploads look for `<episode_id>.h5` |
| `Missing root attr: X` | Re-run your converter, or manually add the missing field |
| `Video file does not exist` | Video paths inside the HDF5 are relative to the HDF5 file; check they exist |
| `Video too large` | Frames exceed 1280 px on a side — downscale them in your converter |
| `Video too small` | Frames are under 180 px on a side |
| `episode duration ... out of range` | Episode is outside the 1–600 second range; check trajectory length and `control_freq` |
| `Frame count / trajectory mismatch` | The video has a different number of frames than the recorded trajectory |
| `lab_id has not been changed from the placeholder value` | Fill in the real `lab_id` in `contributor_config.yaml` (the error names the file that was read) |
| `HuggingFace authentication failed` | Add a valid `huggingface_token` to `contributor_config.yaml`, or set `HF_TOKEN` |
| `Submissions repo not found` | The tool never creates the repo. Check `lab_id` matches the one you were issued exactly; if it does, contact the team — the repo has not been provisioned for your lab yet |

### Very large folders

The upload aborts before pushing anything if any directory holds more than 10,000 files, which is the HuggingFace Hub per-directory limit. Run `oopsie-data restructure --source <dir>` first: it **copies** episodes into numbered subfolders (leaving the source untouched) and rewrites the video paths stored inside each HDF5 to match. Pass `--output <dir>` to choose where the copy goes.

To do both in one step, add `--with-restructure` to the upload:

```bash
oopsie-data upload --path /path/to/formatted_data --with-restructure
```

This writes the restructured copy to `<path>_restructured` and uploads that, so make sure
there is room on disk for a second copy.
### Checking what you have already submitted

`oopsie-data submissions` lists what has landed in your lab's HuggingFace repo, so you can
confirm an upload arrived without opening the Hub.
