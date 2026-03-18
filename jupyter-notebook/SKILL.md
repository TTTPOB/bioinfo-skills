---
name: jupyter-notebook
description: Edit Jupyter notebooks through a temporary text representation when the assistant cannot modify .ipynb files directly. Use when you need to inspect, change, review, or patch a notebook by converting it to a readable text notebook with Jupytext, editing that text file, and syncing the changes back into the original .ipynb file while preserving outputs when possible.
---

# Jupyter Notebook Editing via Jupytext

## Overview

Use this skill when the task is "modify a notebook", but direct editing of `.ipynb` is not practical.

Default workflow:

1. Convert the current `.ipynb` notebook into a readable text notebook in a temporary location.
2. Edit the text notebook instead of the `.ipynb`.
3. Sync the edited text back into the original `.ipynb`.

This skill is intentionally narrow. It is not about maintaining paired notebooks long term. It is a bridge for notebook editing.

## Quick Start

### Check tool

Before editing a notebook, verify that `jupytext` is available:

```bash
bash scripts/check_jupytext.sh
```

### Export notebook to text

Convert a notebook into a readable Python text notebook in `py:percent` format.
Always pass an explicit output path, and prefer a temporary file under `TMPDIR`:

```bash
tmp_py="${TMPDIR:-/tmp}/notebook.edit.py"
bash scripts/export_text_notebook.sh notebook.ipynb "$tmp_py"
```

### Sync text back to notebook

After editing the text notebook, update the original `.ipynb`:

```bash
bash scripts/update_ipynb_from_text.sh "$tmp_py" notebook.ipynb
```

If `notebook.ipynb` already exists, the script copies the existing notebook into a temporary workspace and uses Jupytext's `--update --to notebook` flow there so that notebook outputs and metadata are preserved when possible.

If the target `.ipynb` does not exist, the script creates a new notebook with no outputs.

## Standard Workflow

When asked to edit a notebook:

1. Run `bash scripts/check_jupytext.sh`.
2. Create a temporary text path, e.g. `tmp_py="${TMPDIR:-/tmp}/$(basename path/to/notebook.ipynb .ipynb).edit.py"`.
3. Export the target notebook with `bash scripts/export_text_notebook.sh path/to/notebook.ipynb "$tmp_py"`.
4. Read and edit the generated text notebook.
5. Sync changes back with `bash scripts/update_ipynb_from_text.sh "$tmp_py" path/to/notebook.ipynb`.
6. Remove the temporary text file if it is no longer needed.

## Format Choice

The default text format is `py:percent` because it is easy to read and round-trip safely with Jupytext:

```python
# %%
import pandas as pd

# %%
df.head()
```

The user does not need to manage paired notebooks manually. The `.py` file is usually a temporary editing artifact and should live in `TMPDIR` unless the user explicitly wants to keep it.

## Important Notes

- Prefer editing the generated text notebook, not the raw JSON inside `.ipynb`.
- `jupytext --update --to notebook` is the safest default when updating an existing notebook because it updates input cells while preserving outputs and metadata.
- `jupyter` itself is not required for this editing bridge. Only `jupytext` is required.
- If `jupytext` is missing, tell the user and provide installation guidance rather than guessing another conversion path.

## References

- For the exact command behavior, see [references/jupytext-roundtrip.md](references/jupytext-roundtrip.md).
