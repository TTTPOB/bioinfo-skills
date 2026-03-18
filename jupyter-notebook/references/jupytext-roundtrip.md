# Jupytext Round-Trip Notes

This skill uses only a very small part of Jupytext.

## Commands this skill relies on

Export an `.ipynb` notebook to a readable text notebook at an explicit path:

```bash
jupytext --to py:percent --output "$TMPDIR/notebook.edit.py" notebook.ipynb
```

Write a text notebook back to `.ipynb` with no outputs:

```bash
jupytext --to notebook notebook.py
```

Update an existing `.ipynb` from the text notebook while preserving outputs and metadata:

```bash
jupytext --update --to notebook notebook.py
```

## Why this skill uses `py:percent`

- It is readable in plain text.
- It preserves cell boundaries clearly.
- It has an official Jupytext round-trip workflow.

## Why this skill does not default to `--sync`

`--sync` is useful for long-lived paired notebooks, but this skill is narrower:

- convert one notebook to text for editing
- edit the text representation
- write the edits back to the notebook

That means `--update --to notebook` is the most relevant default when the `.ipynb` already exists.

## Jupyter is optional

For this skill's main purpose, Jupyter is not required on the host machine.

- `jupytext` is required to convert between `.ipynb` and text notebooks
- a text editor is required to edit the converted notebook
- `jupyter` is only optional if you want to open or execute the notebook interactively

## Source

Official Jupytext documentation:

- https://jupytext.readthedocs.io/en/latest/using-cli.html
- https://jupytext.readthedocs.io/en/latest/paired-notebooks.html
