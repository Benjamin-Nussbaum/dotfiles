#!/usr/bin/env -S uv run --script

import re
import subprocess
import tomllib
from pathlib import Path


def uv(subcommand: str, packages: list[str], group: str | None):
    extra_arguments = []
    if group:
        extra_arguments.extend(["--group", group])

    subprocess.check_call(["uv", subcommand, *packages, "--no-sync"] + extra_arguments)


def main():
    """WARNING:
    from the `pyproject.toml` file, this may delete:
        - comments
        - upper bounds etc
        - markers
    """
    pyproject = tomllib.loads(Path("pyproject.toml").read_text())
    package_name_pattern = re.compile(r"^([-a-zA-Z\d]+)(\[[-a-zA-Z\d,]+])?")
    for group, dependencies in {
        None: pyproject["project"]["dependencies"],
        **pyproject["dependency-groups"],
    }.items():
        if not dependencies:
            continue
        to_remove = []
        to_add = []
        for dependency in dependencies:
            package_match = package_name_pattern.match(dependency)
            assert package_match, f"invalid package name '{dependency}'"
            package, extras = package_match.groups()
            to_remove.append(package)
            to_add.append(f"{package}{extras or ''}")
        uv("remove", to_remove, group=group)
        uv("add", to_add, group=group)
    subprocess.check_call(["uv", "sync"])


if __name__ == "__main__":
    main()
