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

## Example

Toolbox Envy is designed around conventional script interfaces so the same
operations behave consistently across ecosystems. For example, a CI workflow
does not need to know how a project stores or updates its version, only that the
operation behaves predictably:

```sh
$ get-project-version
0.8.0

$ get-project-version | bump-semver --minor | set-project-version

$ get-project-version
0.9.0

$ get-project-version | bump-changelog-version
```

The workflow defines when versioning occurs. Toolbox Envy defines how those
versioning operations work across different languages and project types.

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

Toolbox Envy is intentionally consumed from `@main` as a rolling, shared set of
first-party CI utilities.

Expose Toolbox Envy tools directly in workflows using the built-in action:

```yaml
- name: Add Toolbox Envy to PATH
  uses: EarthmanMuons/toolbox-envy/.github/actions/add-to-path@main
  with:
    include_bins: |
      common
      flutter
      media
```

See [docs/github-action.md][] for full details.

[docs/github-action.md]:
  https://github.com/EarthmanMuons/toolbox-envy/blob/main/docs/github-action.md

## Script Index

Scripts are defined as executable files under `bin/`.

### Common

General-purpose scripts intended for use by any repository:

- `bump-calver` – Generate and format CalVer dates from input or today (UTC)
- `bump-changelog-version` – Roll CHANGELOG.md from Unreleased to a new release
- `bump-semver` – Bump or set a SemVer core, with optional prerelease/build
- `create-checksums` – Generate `sha256sums.txt` for release assets
- `screenshot-mode` – Apply or reset canonical iOS/Android screenshot state
- `tag-if-missing` – Create and push a missing git tag (SemVer aware)
- `verify-checksums` – Verify asset checksums for one or more patterns

### Flutter

Scripts specific to Flutter projects:

- `android-signing-setup` – Prepare Android keystore + `key.properties` from env
- `asc-auth-key-setup` – Decode App Store Connect API key and emit CI outputs
- `get-project-version` – Read Flutter `pubspec.yaml` version core
- `ios-signing-setup` – Configure iOS signing keychain, cert, and profile for CI
- `set-project-version` – Write Flutter version core and bump build number
- `stage-release-assets` – Stage Flutter release artifacts into `dist/`

### Media

Image and screenshot utilities:

- `diagmerge` – Diagonally merge two same-size images with optional feathering
- `shotproc` – Process a screenshot (resize, strip metadata, set quality)

### Rust

Scripts specific to Rust projects:

- `get-project-version` – Read Rust package version via `cargo metadata`

## Why the Name?

Because every good shop has that one perfectly organized toolbox you wish was
yours.

## License

Toolbox Envy is released under the [Zero Clause BSD License][LICENSE] (SPDX:
0BSD).

Copyright &copy; 2026 [Aaron Bull Schaefer][EMAIL] and contributors

[LICENSE]: https://github.com/EarthmanMuons/toolbox-envy/blob/main/LICENSE
[EMAIL]: mailto:aaron@elasticdog.com
