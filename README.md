# PRISM VPP Demo — JupyterLite

Interactive demo of the PRISM GPU dispatch engine for VPP / DER coordination.
Runs fully in the browser via Pyodide — no server, no install.

**Live**: https://asymmetrycomputing.github.io/prism-vpp-demo/lab/index.html?path=PRISM_VPP_Demo.ipynb

## What it shows
- Fleet generation (synthetic, N=2k–500k)
- 5-minute market clearing window breakdown
- Coordination premium: 12–28% when feeders bind (NYISO Jan 2024, validated)
- GPU scale benchmark: solve time vs fleet size
- Interactive sliders: fleet N, feeder cap %, η, cycles/day
- Scenario economics

## Deploy your own copy

```bash
# 1. Fork this repo on GitHub
# 2. Go to Settings → Pages → Source: GitHub Actions
# 3. Push any commit — Actions builds and deploys automatically
```

## Update notebook

```bash
python3 generate_jl_notebook.py   # regenerates content/PRISM_VPP_Demo.ipynb
git add content/PRISM_VPP_Demo.ipynb
git commit -m "Update demo notebook"
git push
# GitHub Actions redeploys automatically (~2 min)
```

## IP notice

This notebook evaluates PRISM through its public input/output behaviour only.
Internal solver mechanics are intentionally withheld.
Full methodology available under NDA — contact@asymmetrycomputing.com
