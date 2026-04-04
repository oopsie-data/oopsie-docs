---
title: Data Conversion
layout: default
nav_order: 3
parent: Contributing
permalink: /conversion/
---

# Data Conversion

If your data was not collected with our `EpisodeRecorder`, you can still contribute it by writing a converter that transforms your existing format into the [required dataset format](/format).

An example converter (`convert_ar_aloha_data.py`) is included and tested on the
[AR-ALOHA-Bin-Pick-and-Stack](https://huggingface.co/datasets/UT-Robotics-Failure-Dataset/AR-ALOHA-Bin-Pick-and-Stack)
dataset, which was collected on an **Agilex bimanual robot** running the **ACT/ALOHA**
policy. The source data is in the standard ACT/ALOHA HDF5 format (14-DoF joint actions,
raw image frames at 1280×720, 1500 timesteps at 30 fps). This converter can serve as a
reference implementation for contributors working with similar robot setups or data formats.

---

## Using the existing ACT/ALOHA converter

```bash
python convert_ar_aloha_data.py \
  --source     /path/to/episode_0.hdf5 \
  --output_dir /path/to/formatted_data \
  --episode_id 000000 \
  --success    1.0 \
  --language_instruction "your task description here"
```

Then run validation and upload as described in [Data Submission](/upload).

---

## Writing a converter for a new format

1. Create `convert_<format_name>.py` in the scripts folder
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
3. Run your converter, then validate and upload:
   ```bash
   python convert_your_format.py \
     --source /path/to/data.hdf5 \
     --output_dir /path/to/formatted_data \
     --episode_id 000000

   python upload.py \
     --output_dir /path/to/formatted_data \
     --episode_id 000000
   ```
