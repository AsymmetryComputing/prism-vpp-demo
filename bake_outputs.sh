#!/usr/bin/env bash
# Executes content/PRISM_VPP_Demo.ipynb with a real Python kernel and writes
# real outputs (charts, tables, widget state) back into the same file, so the
# notebook works on first view in JupyterLite without anyone running a cell.
#
# This does NOT change the notebook's own kernelspec (stays "python" / Pyodide)
# — it only borrows a local CPython kernel to pre-compute what Pyodide would
# compute anyway. Run this after every `python3 generate_jl_notebook.py`.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

VENV=".bake_venv"
if [ ! -d "$VENV" ]; then
  python3 -m venv "$VENV"
  "$VENV/bin/pip" install --quiet --upgrade pip
  "$VENV/bin/pip" install --quiet plotly pandas numpy ipywidgets ipykernel nbconvert nbclient jupyter_client
fi

KERNEL_NAME="prism-vpp-bake"
if ! "$VENV/bin/jupyter" kernelspec list 2>/dev/null | grep -q "$KERNEL_NAME"; then
  "$VENV/bin/python" -m ipykernel install --user --name "$KERNEL_NAME" --display-name "$KERNEL_NAME"
fi

"$VENV/bin/jupyter" nbconvert --to notebook --execute --inplace \
  --ExecutePreprocessor.kernel_name="$KERNEL_NAME" \
  --ExecutePreprocessor.timeout=180 \
  content/PRISM_VPP_Demo.ipynb

"$VENV/bin/python" -c "
import json
nb = json.load(open('content/PRISM_VPP_Demo.ipynb'))
errs = sum(1 for c in nb['cells'] if c['cell_type']=='code'
           for o in c.get('outputs', []) if o.get('output_type') == 'error')
ncode = sum(1 for c in nb['cells'] if c['cell_type'] == 'code')
nout  = sum(1 for c in nb['cells'] if c['cell_type'] == 'code' and c.get('outputs'))
assert nb['metadata']['kernelspec']['name'] == 'python', 'kernelspec got mutated — fix before committing'
assert errs == 0, f'{errs} cell(s) raised an error during bake — fix before committing'
assert nout == ncode, f'only {nout}/{ncode} code cells have outputs'
print(f'OK — {ncode} code cells executed, {errs} errors, kernelspec.name=python')
"
