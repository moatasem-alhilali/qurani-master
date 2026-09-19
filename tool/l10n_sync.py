"""Merge l10n/fragments/*.json into lib/l10n/app_ar.arb and regenerate L10n.

Usage:
    python tool/l10n_sync.py            # merge + validate + flutter gen-l10n
    python tool/l10n_sync.py --check    # merge + validate only (no codegen)
    python tool/l10n_sync.py --report   # also list untranslated keys per locale

Why fragments: several people/agents extract strings in parallel. Each owns
one fragment file, so nobody edits the same JSON file. This script is the only
writer of the Arabic template, and it holds a lock while regenerating so
concurrent runs never interleave.

Exit code is non-zero on any validation error (duplicate key across fragments,
invalid key name, metadata without a message, broken placeholders, or a
translation that drops/renames a placeholder).
"""
import json
import os
import re
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
FRAGMENTS = ROOT / 'l10n' / 'fragments'
ARB_DIR = ROOT / 'lib' / 'l10n'
TEMPLATE_LOCALE = 'ar'
TARGET_LOCALES = ['ur', 'fa', 'bn', 'id', 'tr']
LOCK = ROOT / '.dart_tool' / 'l10n_sync.lock'

KEY_RE = re.compile(r'^[a-z][A-Za-z0-9]*$')
SIMPLE_PLACEHOLDER_RE = re.compile(r'\{([A-Za-z_][A-Za-z0-9_]*)\}')


def acquire_lock(timeout=180):
    LOCK.parent.mkdir(parents=True, exist_ok=True)
    deadline = time.time() + timeout
    while True:
        try:
            LOCK.mkdir()  # atomic on every OS
            return
        except FileExistsError:
            # a crashed run leaves a stale lock; treat >10 min as stale
            if time.time() - LOCK.stat().st_mtime > 600:
                LOCK.rmdir()
                continue
            if time.time() > deadline:
                sys.exit(f'l10n_sync: lock busy for {timeout}s ({LOCK})')
            time.sleep(1.5)


def release_lock():
    try:
        LOCK.rmdir()
    except FileNotFoundError:
        pass


def load_json(path):
    try:
        return json.loads(path.read_text(encoding='utf-8'))
    except json.JSONDecodeError as error:
        raise SystemExit(f'l10n_sync: invalid JSON in {path.relative_to(ROOT)}: {error}')


def top_level_placeholders(message):
    """Placeholder names used as {name} in a message, ignoring ICU branches."""
    return set(SIMPLE_PLACEHOLDER_RE.findall(message))


def merge_fragments(errors):
    merged = {}
    owner = {}
    for path in sorted(FRAGMENTS.glob('*.json')):
        data = load_json(path)
        name = path.relative_to(ROOT).as_posix()
        for key, value in data.items():
            if key.startswith('@'):
                continue
            if not KEY_RE.match(key):
                errors.append(f'{name}: invalid key "{key}" (use lowerCamelCase, start with a letter)')
                continue
            if key in owner:
                errors.append(f'duplicate key "{key}" in {name} and {owner[key]}')
                continue
            if not isinstance(value, str):
                errors.append(f'{name}: "{key}" must be a string')
                continue
            owner[key] = name
            merged[key] = value
            meta = data.get('@' + key)
            if meta is not None:
                merged['@' + key] = meta
        for key in data:
            if key.startswith('@') and not key.startswith('@@') and key[1:] not in data:
                errors.append(f'{name}: metadata "{key}" has no message "{key[1:]}"')
    for key, value in list(merged.items()):
        if key.startswith('@'):
            continue
        if value.count('{') != value.count('}'):
            errors.append(f'{owner[key]}: unbalanced braces in "{key}"')
        used = top_level_placeholders(value)
        declared = set((merged.get('@' + key) or {}).get('placeholders', {}).keys())
        if used - declared and '{' in value and ', plural,' not in value and ', select,' not in value:
            errors.append(f'{owner[key]}: "{key}" uses {sorted(used - declared)} but does not declare them in "@{key}".placeholders')
    return merged, owner


def check_translations(template, report):
    messages = {k: v for k, v in template.items() if not k.startswith('@')}
    errors, summary = [], []
    for locale in TARGET_LOCALES:
        path = ARB_DIR / f'app_{locale}.arb'
        if not path.exists():
            path.write_text(json.dumps({'@@locale': locale}, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
        data = load_json(path)
        translated = {k: v for k, v in data.items() if not k.startswith('@')}
        missing = [k for k in messages if k not in translated]
        stale = [k for k in translated if k not in messages]
        for key, value in translated.items():
            if key not in messages:
                continue
            if not isinstance(value, str):
                errors.append(f'app_{locale}.arb: "{key}" must be a string')
                continue
            expected = top_level_placeholders(messages[key])
            got = top_level_placeholders(value)
            if ', plural,' not in messages[key] and ', select,' not in messages[key] and expected != got:
                errors.append(f'app_{locale}.arb: "{key}" placeholders {sorted(got)} != template {sorted(expected)}')
            if value.count('{') != value.count('}'):
                errors.append(f'app_{locale}.arb: unbalanced braces in "{key}"')
        summary.append(f'  {locale}: {len(translated) - len(stale)}/{len(messages)} translated'
                       + (f', {len(stale)} stale' if stale else ''))
        if report and missing:
            summary.append('     missing: ' + ', '.join(missing[:40]) + (' …' if len(missing) > 40 else ''))
        if report and stale:
            summary.append('     stale:   ' + ', '.join(stale[:40]))
    return errors, summary


def main():
    check_only = '--check' in sys.argv
    report = '--report' in sys.argv
    acquire_lock()
    try:
        errors = []
        merged, owner = merge_fragments(errors)
        if errors:
            print('l10n_sync: fragment errors:')
            for e in errors:
                print('  -', e)
            sys.exit(1)

        ARB_DIR.mkdir(parents=True, exist_ok=True)
        template = {'@@locale': TEMPLATE_LOCALE, **merged}
        (ARB_DIR / f'app_{TEMPLATE_LOCALE}.arb').write_text(
            json.dumps(template, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

        translation_errors, summary = check_translations(template, report)
        count = sum(1 for k in merged if not k.startswith('@'))
        print(f'l10n_sync: {count} keys from {len(set(owner.values()))} fragments')
        print('\n'.join(summary))
        if translation_errors:
            print('l10n_sync: translation errors:')
            for e in translation_errors:
                print('  -', e)
            sys.exit(1)

        if check_only:
            return
        result = subprocess.run('flutter gen-l10n', cwd=ROOT, shell=True,
                                capture_output=True, text=True, encoding='utf-8', errors='replace')
        output = (result.stdout + result.stderr).strip()
        if result.returncode != 0:
            print('l10n_sync: flutter gen-l10n failed:\n' + output)
            sys.exit(result.returncode)
        print('l10n_sync: generated lib/l10n/app_localizations*.dart')
    finally:
        release_lock()


if __name__ == '__main__':
    main()
