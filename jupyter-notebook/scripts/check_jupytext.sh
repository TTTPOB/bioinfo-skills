#!/bin/bash
# Check whether Jupytext is available for notebook round-trip editing.

set -euo pipefail

if command -v jupytext >/dev/null 2>&1; then
    echo "✓ jupytext is installed"
    jupytext --version
else
    echo "✗ jupytext is not installed"
    echo ""
    echo "Install Jupytext in your current Python environment, for example:"
    echo "  uv tool install jupytext"
    echo "  pixi global install jupytext"
    exit 1
fi
