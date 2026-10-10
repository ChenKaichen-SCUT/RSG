#!/usr/bin/env bash
# Ubuntu 22.04 x86_64. System dependencies plus a project-local Python venv.
set -euo pipefail
RSG_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$RSG_ROOT"
mkdir -p sources original work experiments scripts results logs reports patches
if [[ "${RSG_SKIP_APT:-0}" != 1 ]]; then
    RSG_SUDO=()
    if [[ "$EUID" != 0 ]]; then RSG_SUDO=(sudo); fi
    python3 scripts/record_command.py --name setup/apt_update -- "${RSG_SUDO[@]}" apt-get update
    python3 scripts/record_command.py --name setup/apt_install -- "${RSG_SUDO[@]}" env DEBIAN_FRONTEND=noninteractive apt-get install -y mono-devel mono-xbuild unrar python3-venv python3-pip build-essential curl unzip time poppler-utils git rsync
fi
python3 -m venv .venv
.venv/bin/python scripts/record_command.py --name setup/pip -- .venv/bin/pip install -r scripts/requirements.lock
.venv/bin/python scripts/record_command.py --name setup/sources -- .venv/bin/python scripts/download_sources.py
.venv/bin/python scripts/record_command.py --name setup/artifact -- .venv/bin/python scripts/download_artifact.py
.venv/bin/python scripts/record_command.py --name setup/extract -- .venv/bin/python scripts/extract_artifact.py
export PATH="$RSG_ROOT/.venv/bin:$PATH"
.venv/bin/python scripts/record_command.py --name setup/environment -- .venv/bin/python scripts/capture_environment.py
printf '%s\n' 'Setup complete. Next: bash scripts/build.sh'
