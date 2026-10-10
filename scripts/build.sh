#!/usr/bin/env bash
set -euo pipefail
RSG_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$RSG_ROOT"
exec .venv/bin/python scripts/build.py
