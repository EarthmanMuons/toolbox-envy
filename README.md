# toolbox-envy

**A shared toolbox for development and release automation.**

This repository centralizes the small but important scripts that tend to
accumulate across projects: version management, packaging and release helpers,
asset processing utilities, and ecosystem specific developer tooling.

The goal is simple:

- Keep project repositories clean
- Avoid duplicating scripts across multiple codebases
- Make tooling usable both locally and in CI
- Provide a consistent, opinionated developer experience

---

## Structure

```
toolbox-envy/
├── bin/
│   ├── common/     # generic scripts usable anywhere
│   ├── flutter/    # Flutter-specific tooling
│   ├── media/      # image and media processing utilities
│   └── rust/       # Rust-specific tooling
└── docs/           # usage notes where needed
```

Each ecosystem directory is designed to be added to your PATH independently so
projects only pull in the tools they actually need.

## Philosophy

- Scripts are source controlled and human readable
- CI workflows call the same tools used locally
- Prefer composable shell utilities over complex action logic
- Centralize maintenance without over engineering distribution

This repo is intentionally lightweight, practical, and is meant to grow
organically as new tooling proves broadly useful.

## Usage (Typical)

Example using `direnv` in a Flutter project:

```bash
PATH_add ../toolbox-envy/bin/common
PATH_add ../toolbox-envy/bin/flutter
```

## Why the Name?

Because every good shop has that one perfectly organized toolbox you wish was
yours.

## License

toolbox-envy is released under the [Zero Clause BSD License][LICENSE] (SPDX:
0BSD).

Copyright &copy; 2026 [Aaron Bull Schaefer][EMAIL] and contributors

[LICENSE]: https://github.com/EarthmanMuons/toolbox-envy/blob/main/LICENSE
[EMAIL]: mailto:aaron@elasticdog.com
