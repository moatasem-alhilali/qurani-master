# Translating the app (one translator per language)

Source: `lib/l10n/app_ar.arb` (Arabic, generated — do not edit). Every key has
an Arabic value; many have an `@key.description` explaining where it appears.

Target: `lib/l10n/app_<code>.arb` — a flat JSON object:

```json
{
  "@@locale": "tr",
  "appName": "Tamaneena",
  "commonSave": "Kaydet"
}
```

Only `@@locale` plus translated keys. No `@key` metadata (the template owns it).

## Must

- Translate **every** key in `app_ar.arb` (except `@`-prefixed ones).
- Keep placeholders exactly: `{prayer}`, `{count}` … same names, none dropped/added.
  Their position may move to suit your grammar.
- ICU plural/select: keep the structure and the variable name; translate only the
  text inside the braces. Use the plural categories of YOUR language
  (id: `other` only; tr/fa/ur/bn: `one`, `other`). `=0`/`=1` explicit cases
  may stay. Always include `other`. Never put both `=1{…}` and `one{…}` in the
  same message: gen-l10n keeps only one and warns at build time. Use `=1` when
  the singular needs its own wording, otherwise `one`.
- Quranic/dhikr/dua text that appears inside a value stays in Arabic as-is.
- Natural, short UI language as a native Muslim user of that language expects —
  not literal word-for-word. Buttons are short; widget labels are very short.
- Islamic terms: use the term your community actually uses (see glossary in
  your task). Be consistent across the whole file.
- `appName` («طمأنينة»): Latin-script languages → "Tamaneena". Arabic-script
  languages (ur, fa) keep «طمأنينة». Bengali → "তামানিনা".

## Validate

`python tool/l10n_sync.py --report` must end without errors and show
`<code>: N/N translated`, 0 stale.
