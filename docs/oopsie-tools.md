---
title: Oopsie ToolKit
layout: default
nav_order: 4
has_children: true
permalink: /tool/
---

# Oopsie ToolKit

You can download the Oopsie ToolKit from [our github](https://github.com/oopsie-data/oopsie-tools). The toolkit provides utilities for the main workflow:

**[Data Collection]({% link data-collection.md %})**: Recording the data in the expected format

**[Annotation Tool]({% link annotator.md %})**: Annotating recorded data during data collection or after in bulk to capture failure information

**[Upload]({% link upload.md %})**: Uploading it to the project submission server

In addition we provide utilities to reformat pre-gathered data to the format recognized by the annotation tool and the upload server.
To simplify this, we document:

**[Data Format]({% link format.md %})**: The dataset format with all required and optional fields

**[Dataset Conversion]({% link conversion.md %})**: Existing tools for converting common formats into the Oopsie Data annotation and submission format.

## Workflow

Our recommended workflow is to integrate our tools directly into your real-world policy evaluation pipeline. That way the data will be recorded in the correct format and the annotation tool will be automatically prompting you via a browser window to provide relevant information such as a failure description.

Integrating the recorder and annotator is described in detail in the [data collection]({% link data-collection.md  %}) instructions.
