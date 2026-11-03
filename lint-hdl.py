#!/usr/bin/env python3

"""Lint project HDL sources with Verilator."""

import argparse
import shutil
import subprocess
import sys
from pathlib import Path


VERILATOR_FLAGS = [
    "--lint-only",
    "-Wall",
    "--language",
    "1800-2012",
]


def project_sources(hdl_root):
    """Return project HDL sources excluding testbenches"""
    return sorted(
        path
        for path in hdl_root.rglob("*.sv")
        if "test" not in str(path)
    )


def main():
    verilator = shutil.which("verilator")
    if verilator is None:
        parser.error(f"Verilator executable not found: {args.verilator}")

    hdl_root = Path(__file__).resolve().parent / "hdl"
    components_root = hdl_root / "support"
    sources = project_sources(hdl_root)

    failed = []
    for source in sources:
        command = [
            verilator,
            *VERILATOR_FLAGS,
            "-y",
            str(components_root),
            str(source),
        ]
        print(f"Linting {source}")
        result = subprocess.run(command, cwd=hdl_root.parent)
        if result.returncode != 0:
            failed.append(source)

    if failed:
        print("\nVerilator lint failed for:", file=sys.stderr)
        for source in failed:
            print(f"  {source}", file=sys.stderr)
        return 1

    print(f"\nVerilator lint passed for {len(sources)} source(s).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
