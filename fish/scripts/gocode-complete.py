#!/usr/bin/env python3

import argparse
from datetime import datetime
from pathlib import Path


def relative_time(mtime: float) -> str:
    now = datetime.now()
    then = datetime.fromtimestamp(mtime)
    delta = now - then
    seconds = int(delta.total_seconds())

    if seconds < 60:
        return "just now"
    if seconds < 3600:
        return f"{seconds // 60}m ago"
    if seconds < 86400:
        return f"{seconds // 3600}h ago"
    if seconds < 604800:
        return f"{seconds // 86400}d ago"
    if seconds < 31536000:
        return then.strftime("%b %d")
    return then.strftime("%Y-%m-%d")


def collect_projects(coding_dir: Path, work_dir: Path) -> list[tuple[str, str | None, float]]:
    projects: list[tuple[str, str | None, float]] = []

    if coding_dir.is_dir():
        for entry in coding_dir.iterdir():
            if entry.is_dir() and not entry.name.startswith("."):
                projects.append((entry.name, None, entry.stat().st_mtime))

    if work_dir.is_dir():
        for company in work_dir.iterdir():
            if not company.is_dir() or company.name.startswith("."):
                continue
            for project in company.iterdir():
                if project.is_dir() and not project.name.startswith("."):
                    projects.append((project.name, company.name, project.stat().st_mtime))

    projects.sort(key=lambda item: item[2], reverse=True)
    return projects


def format_description(parent: str | None, mtime: float) -> str:
    time_str = relative_time(mtime)
    if parent:
        return f"{parent} · {time_str}"
    return time_str


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--coding-dir", required=True)
    parser.add_argument("--work-dir", required=True)
    args = parser.parse_args()

    for name, parent, mtime in collect_projects(Path(args.coding_dir), Path(args.work_dir)):
        print(f"{name}\t{format_description(parent, mtime)}")


if __name__ == "__main__":
    main()
