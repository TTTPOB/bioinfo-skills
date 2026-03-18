#!/bin/bash
# Export an .ipynb notebook to a readable py:percent text notebook.

set -euo pipefail

if [ "$#" -ne 2 ]; then
    echo "Usage: bash scripts/export_text_notebook.sh <notebook.ipynb> <output.py>" >&2
    exit 1
fi

input_ipynb="$1"
output_py="$2"

if [ ! -f "$input_ipynb" ]; then
    echo "Input notebook not found: $input_ipynb" >&2
    exit 1
fi

if ! command -v jupytext >/dev/null 2>&1; then
    echo "jupytext is required but was not found in PATH" >&2
    exit 1
fi

jupytext --to py:percent --output "$output_py" "$input_ipynb"
echo "Exported text notebook: $output_py"
