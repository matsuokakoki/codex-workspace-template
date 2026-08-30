# Profile: Python / Research

Typical additions before Codex starts:

- Python base image
- uv
- NumPy / SciPy / pandas / scikit-learn / matplotlib as needed
- pytest + Ruff
- LaTeX only if the project produces papers/PDFs
- dataset extractors only when required
- fixed dependency lockfile
- known datasets downloaded in advance
- smoke experiment and report-toolchain verification

Do not add all of these blindly. Use only what the current project needs.
