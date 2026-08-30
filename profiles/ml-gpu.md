# Profile: ML / GPU

Typical additions before Codex starts:

- CUDA-compatible base image
- NVIDIA Container Toolkit already functional on the machine
- pinned PyTorch/JAX/etc. versions
- GPU visibility check
- model weights/data downloaded in advance when licenses allow
- cache volumes
- lightweight smoke inference/training check

Do not assume GPU support; verify it before Codex starts.
