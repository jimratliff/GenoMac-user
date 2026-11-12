import argparse
from pathlib import Path
from tempfile import NamedTemporaryFile

import tomlkit

parser = argparse.ArgumentParser()
parser.add_argument("desired", type=Path)
parser.add_argument("config", type=Path)
args = parser.parse_args()

desired = tomlkit.parse(args.desired.read_text(encoding="utf-8"))
config_path = args.config.expanduser().resolve()

try:
    config = tomlkit.parse(config_path.read_text(encoding="utf-8"))
except FileNotFoundError:
    config = tomlkit.document()

def merge_settings(target, settings, parent=""):
    changed = False
    for key, value in settings.items():
        path = f"{parent}.{key}" if parent else key
        current = target.get(key)
        if hasattr(current, "unwrap"):
            current = current.unwrap()

        if isinstance(value, dict):
            if not value:
                continue
            if key not in target:
                target[key] = tomlkit.table()
            elif not isinstance(current, dict):
                parser.error(f"Expected a table in the live config: {path}")

            if merge_settings(target[key], value, path):
                changed = True
            continue

        if not parent or type(value) not in (bool, str, int, float):
            parser.error(f"Expected a scalar value inside a table: {path}")
        if isinstance(current, dict):
            parser.error(f"Expected a scalar value in the live config: {path}")
        if type(current) is type(value) and current == value:
            continue

        target[key] = value
        changed = True

    return changed


if merge_settings(config, desired.unwrap()):
    config_path.parent.mkdir(parents=True, exist_ok=True)
    with NamedTemporaryFile(
        mode="w", encoding="utf-8", dir=config_path.parent, delete=False
    ) as output:
        temporary = Path(output.name)
        try:
            output.write(tomlkit.dumps(config))
            output.close()
            temporary.replace(config_path)
        finally:
            temporary.unlink(missing_ok=True)
