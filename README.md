# Glaze
Tools & Utilities to improve Microsoft Windows

---

## Getting started

`start` is a reserved word, so we can't use that.
`run` is a cross-platform wrapper to start `main`

| Terminal        | Start Command         |
|-----------------|-----------------------|
| Command Line    | `run[.bat]`           |
| PowerShell      | `./run[.bat]`         |
| GitBash / MinGW | `[.\|source] [./]run` |


### `./nvm` Node Version Manager

- `install.ps1` Install, see the script for extra flags
- `uninstall.ps1` Uninstall if installrd
- `permissions.ps1` Allow nvm to mklink without prompting, see the script for extra flags
- `check.ps1` List related Env Vars

[//]: # (TODO - script to 'clean' downloads from all possible download dirs)
