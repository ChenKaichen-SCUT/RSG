#!/usr/bin/env bash
set -euo pipefail
RSG_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$RSG_ROOT"
export PATH="$RSG_ROOT/.venv/bin:$PATH"
export PYTHONHASHSEED=0
unset RSG_EXPERIMENT RSG_ORDER RSG_ATTRS RSG_INJECT_ONCE RSG_ORACLE RSG_PROFILE
run_stage() {
    .venv/bin/python scripts/record_command.py --name "$1" -- .venv/bin/python "$2"
}
run_stage independent_smt experiments/verify.py
run_stage prepare_frontend scripts/prepare_end_to_end.py
run_stage frontend_equivalence experiments/verify_frontend.py
run_stage interface_suite experiments/run_interface.py
run_stage A4_exact experiments/exact_single_term.py
run_stage end_to_end_suite experiments/run_end_to_end.py
run_stage end_to_end_validation experiments/analyze_end_to_end.py
run_stage aggregate scripts/aggregate_results.py
printf '%s\n' 'All experiments and independent checks complete: results/results.json'
