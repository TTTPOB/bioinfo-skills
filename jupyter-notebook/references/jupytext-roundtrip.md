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

## Searching `.ipynb` safely with ripgrep

For notebook search, this skill ships `scripts/rg_ipynb_preprocessor.py`.

Recommended usage:

```bash
rg --pre ./scripts/rg_ipynb_preprocessor.py --pre-glob '*.ipynb' 'pattern' .
```

The preprocessor:

- parses `.ipynb` with Python's standard `json` module
- renders cell sources as searchable plain text
- keeps text-like outputs searchable
- omits base64-heavy output payloads such as `image/png` and `application/pdf`

`rg --pre` executes the preprocessor directly, so the script must be executable and cannot be passed as `python3 script.py`.

If you want ordinary recursive `rg` commands to pick up `.ipynb` preprocessing automatically, put the same flags in a temporary ripgrep config and point `RIPGREP_CONFIG_PATH` at it:

```bash
tmp_rg="${TMPDIR:-/tmp}/rg-ipynb-pre.rc"
printf '%s\n' \
  '--pre' \
  './scripts/rg_ipynb_preprocessor.py' \
  '--pre-glob' \
  '*.ipynb' > "$tmp_rg"

RIPGREP_CONFIG_PATH="$tmp_rg" rg 'pattern' .
rm -f "$tmp_rg"
```

That lets `rg 'pattern' .` preprocess `.ipynb` files automatically without requiring the command itself to mention `*.ipynb`.
