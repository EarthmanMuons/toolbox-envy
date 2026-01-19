<p align="center">
  <img width="256" src="https://raw.githubusercontent.com/EarthmanMuons/toolbox-envy/refs/heads/main/docs/images/toolbox-envy-logo.webp" alt="Toolbox Envy logo">
</p>

<h1 align="center">Toolbox Envy</h1>

This repository centralizes the small but important scripts that tend to
accumulate across projects: version management, packaging and release helpers,
asset processing utilities, and ecosystem specific developer tooling.

Toolbox Envy is the conceptual companion to the [Reusable Workflows][]
repository. Where reusable workflows provide high-level CI structure, Toolbox
Envy houses the concrete, reusable scripts those workflows rely on to keep
procedural logic out of CI definitions.

It exists to provide a shared, automation toolbox that:

- Keeps individual project repositories clean
- Eliminates duplicated logic across codebases
- Works identically in local environments and CI
- Prefers simple, composable shell implementations
- Remains easy to audit, maintain, and grow over time

[Reusable Workflows]: https://github.com/EarthmanMuons/reusable-workflows

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

## Usage

### Local Development

Add the Toolbox Envy directories you want via `direnv`, `mise`, or similar:

**direnv**

```bash
PATH_add ../toolbox-envy/bin/common
PATH_add ../toolbox-envy/bin/flutter
PATH_add ../toolbox-envy/bin/media
```

**mise**

```toml
[env]
_.path = [
  "../toolbox-envy/bin/common",
  "../toolbox-envy/bin/flutter",
  "../toolbox-envy/bin/media",
]
```

### Remote CI (GitHub Actions)

Expose toolbox-envy tools directly in workflows using the built-in action:

```yaml
- name: Add Toolbox Envy to PATH
  uses: EarthmanMuons/toolbox-envy/.github/actions/add-to-path@v1
  with:
    include_bins: |
      common
      flutter
      media
```

See [docs/github-action.md][] for full details.

[docs/github-action.md]:
  https://github.com/EarthmanMuons/toolbox-envy/blob/main/docs/github-action.md

## Why the Name?

Because every good shop has that one perfectly organized toolbox you wish was
yours.

## License

Toolbox Envy is released under the [Zero Clause BSD License][LICENSE] (SPDX:
0BSD).

Copyright &copy; 2026 [Aaron Bull Schaefer][EMAIL] and contributors

[LICENSE]: https://github.com/EarthmanMuons/toolbox-envy/blob/main/LICENSE
[EMAIL]: mailto:aaron@elasticdog.com
