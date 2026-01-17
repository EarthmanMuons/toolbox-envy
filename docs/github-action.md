# GitHub Action: Add toolbox-envy to PATH

toolbox-envy provides a composite GitHub Action that exposes selected script
directories directly to your workflow PATH without requiring an explicit
checkout of this repository.

The action is designed to be simple, strict, and predictable.

---

## What It Does

- Adds specified toolbox-envy directories to the workflow PATH
- Optionally adds a project-local `bin/` directory first for precedence
- Fails fast if any requested directory does not exist
- Avoids copying or installing files into the workspace

All scripts are executed directly from the action repository that GitHub
automatically downloads when the action is used.

---

## Usage

```yaml
- name: Add toolbox-envy tools
  uses: EarthmanMuons/toolbox-envy/.github/actions/add-to-path@v1
  with:
    include_bins: |
      common
      flutter
      media
    project_bin: bin
```

## Inputs

| Name            | Required | Description                                                                          |
| --------------- | -------- | ------------------------------------------------------------------------------------ |
| `include_bins`  | yes      | List of toolbox-envy `bin/<name>` subdirectories to add to PATH                      |
| `project_bin`   | no       | Project-local bin directory added first for PATH precedence (must exist if provided) |
| `write_summary` | no       | Write added PATH entries to the workflow summary (default: true)                     |

The `include_bins` entries must exist as `bin/<name>` in toolbox-envy and may be
newline- or comma-separated; invalid names will fail the job.

### PATH Precedence

PATH resolution is left-to-right. If you provide `project_bin`, it is added
first so project scripts override toolbox-envy scripts with the same name.

### Version Pinning

Recommended:

```
@v1
```

For maximum reproducibility, pin to a commit SHA instead.

## Design Philosophy

- No hidden fallbacks
- No silent skips
- No implicit installs
- One step, predictable PATH behavior
