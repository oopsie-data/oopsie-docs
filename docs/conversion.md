---
title: Data Conversion
layout: default
nav_order: 1
parent: Dataset Format
grand_parent: Contributing
permalink: /conversion/
---

# Data Conversion

If your data was not collected with our `EpisodeRecorder`, you can still contribute it by converting your existing format into the [required dataset format](/format). We provide two ready-made converters in `scripts/dataset_conversion/`.

| Script | Source format |
|---|---|
| `convert_ar_aloha_data.py` | ACT/ALOHA HDF5 (14-DoF bimanual, 3 cameras) |
| `convert_rlds_to_hdf5.py` | RLDS/DROID TFDS (any TFDS-compatible dataset) |

Both converters handle video resizing (frames are downscaled to max 1080 px) and write the `robotic_failure_upload_data_format_v1` schema.

---

## ACT/ALOHA converter

Converts a single ACT/ALOHA HDF5 episode (the format used by Agilex/Trossen bimanual robots running ACT) into the required format. Source fields:

- `action` — (T, 14) joint actions, both arms
- `observations/qpos` — (T, 14) joint positions, both arms
- `observations/images/cam_high`, `cam_left_wrist`, `cam_right_wrist` — raw video frames

EEF Cartesian fields are left empty since forward kinematics are not available in this format.

```bash
python scripts/dataset_conversion/convert_ar_aloha_data.py \
  --source     /path/to/episode_0.hdf5 \
  --output-dir /path/to/output \
  --episode-id 000000 \
  --success    1.0 \
  --language-instruction "stack the tote on top of the other totes" \
  --control-freq 30
```

| Flag | Default | Description |
|---|---|---|
| `--source` / `-s` | hardcoded path | Path to source ACT/ALOHA HDF5 file |
| `--output-dir` / `-o` | required | Output directory for converted files |
| `--episode-id` / `-e` | `000000` | Episode ID (zero-padded to 6 digits) |
| `--success` | `1.0` | Episode success label: `1.0` = success, `0.0` = failure |
| `--language-instruction` | hardcoded string | Natural language task description |
| `--control-freq` | `30` | Control frequency in Hz, also used as video FPS |
| `--lab-id` | `""` | Value for `episode_annotations/lab_id` |
| `--operator-name` | `""` | Value for `episode_annotations/operator_name` |
| `--policy-id` | `""` | Value for `episode_annotations/policy_id` |
| `--robot-id` | `""` | Value for `episode_annotations/robot_id` |

---

## RLDS/DROID converter

Converts a full RLDS TFDS dataset (TFRecord shards with a `dataset_info.json`) into per-episode HDF5 files. Requires the `tensorflow_datasets` extra:

```bash
uv sync --extra tfds
```

```bash
python scripts/dataset_conversion/convert_rlds_to_hdf5.py \
  --rlds-version-dir /path/to/dataset/1.0.0 \
  --output-dir       /path/to/output \
  --split            train
```

| Flag | Default | Description |
|---|---|---|
| `--rlds-version-dir` | `1.0.0/` | Path to TFDS version directory (contains `dataset_info.json` and TFRecord shards) |
| `--output-dir` | `trajectory_hdf5/` | Output directory for generated `.h5` files |
| `--split` | `train` | Dataset split to convert |
| `--max-episodes` | none | Optional cap on number of episodes to convert |
| `--control-freq` | `""` | Control frequency in Hz, used as video FPS (default: 15 if unset) |
| `--lab-id` | `""` | Value for `episode_annotations/lab_id` |
| `--operator-name` | `""` | Value for `episode_annotations/operator_name` |
| `--policy-id` | `""` | Value for `episode_annotations/policy_id` |
| `--robot-id` | `""` | Value for `episode_annotations/robot_id` |
| `--compression-level` | `4` | gzip compression level for datasets (0–9) |
| `--no-store-episode-annotations` | off | Skip writing `episode_annotations` group |
| `--overwrite` | off | Overwrite existing output files |

The script maps DROID field names to the required schema via a `CONVERSION_DICT` at the top of the file. If your RLDS dataset uses different field names, edit that dict before running.

---

## Writing a converter for a new format

1. Create `convert_<format_name>.py` in `scripts/dataset_conversion/`
2. Implement the following function signature:
   ```python
   def convert(
       source_h5: str,
       output_dir: str,
       episode_id: str,
       control_freq: str,
       success: float,
       language_instruction: str,
   ) -> Path:
       """Returns path to the output HDF5 file."""
       ...
   ```
3. Run your converter first, then validate and upload:
   ```bash
   python scripts/dataset_conversion/convert_your_format.py \
     --source /path/to/data.hdf5 \
     --output-dir /path/to/formatted_data \
     --episode-id 000000

   python scripts/validate_and_upload/upload.py \
     --output_dir /path/to/formatted_data \
     --episode_id 000000
   ```
