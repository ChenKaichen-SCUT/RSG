#!/usr/bin/env bash
set -euo pipefail
RSG_STAGE2_ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$RSG_STAGE2_ROOT_DIR"
RSG_STAGE2_PY="${RSG_PYTHON:-$RSG_STAGE2_ROOT_DIR/.venv/bin/python}"
export RSG_PYTHON="$RSG_STAGE2_PY"
"$RSG_STAGE2_PY" stage2/scripts/prepare_fresh_run.py
"$RSG_STAGE2_PY" stage2/scripts/check_isolation.py
"$RSG_STAGE2_PY" stage2/scripts/setup.py
"$RSG_STAGE2_PY" stage2/scripts/collect.py --split smoke
"$RSG_STAGE2_PY" stage2/scripts/validate_corpus.py
"$RSG_STAGE2_PY" stage2/scripts/compare.py
"$RSG_STAGE2_PY" stage2/scripts/collect.py --split holdout
"$RSG_STAGE2_PY" stage2/scripts/validate_corpus.py
"$RSG_STAGE2_PY" stage2/scripts/compare.py --resume
"$RSG_STAGE2_PY" stage2/scripts/compare_balanced.py
"$RSG_STAGE2_PY" stage2/scripts/aggregate.py
"$RSG_STAGE2_PY" stage2/scripts/check_replay_syntax.py
"$RSG_STAGE2_PY" stage2/scripts/analyze_dependencies.py
"$RSG_STAGE2_PY" stage2/scripts/conditional_e2e.py
