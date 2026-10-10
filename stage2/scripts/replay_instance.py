#!/usr/bin/env python3
"""Replay a named frozen instance without invoking RSLearn."""
import argparse,pathlib,sys
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
from common import S
from validate_corpus import validate
from compare import compare
ap=argparse.ArgumentParser();ap.add_argument('instance');args=ap.parse_args()
path=S/'corpus'/args.instance/'trace.json'
if not path.is_file():raise SystemExit('Unknown frozen instance; unpack the published evidence archive first')
record=validate(path)
if record['status']!='validated':raise SystemExit('Independent validation failed; refusing search')
compare(path)
