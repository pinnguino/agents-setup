# agents-setup

> The automated way to generate templates for agentic AI workflows.

`agents-setup` is a small POSIX-compliant shell CLI that scaffolds OpenCode agent
templates (`plan.md` and `build.md`) into either the global or per-project
`.opencode/agents/` directory, with an interactive confirmation step.

## Install

Clone this repo wherever you want (eg. `/opt`)
```bash
cd /opt
git clone <repo-url>
```

Install the command:
```bash
chmod +x ./install.sh
./install.sh
```

## Uninstall

```bash
chmod +x ./uninstall.sh
./uninstall.sh
```

Cloning into `/opt/` may require `sudo` depending on your system configuration.
The installer copies the bundled templates into
`~/.config/agents-setup/templates/`, so `agents-setup` can read them from any
directory.

## Usage

```bash
agents-setup --global          # plan + build in ~/.config/opencode/agents/
agents-setup --project         # plan + build in ./.opencode/agents/
agents-setup --global plan     # only plan.md  (global)
agents-setup --project build   # only build.md (project)
```

| Mode       | Destination                      |
|------------|----------------------------------|
| `--global` | `~/.config/opencode/agents/`     |
| `--project`| `./.opencode/agents/`            |

Both modes produce files named `plan.md` and `build.md`, which override
OpenCode's built-in `plan` and `build` agents. The `plan` agent activates in
Plan Mode; the `build` agent activates in Build Mode. Neither pins a model —
they inherit the global `model` from `opencode.json`.

An optional `plan` or `build` argument limits the target to a single file.
Exactly one mode (`--global` or `--project`) is required.

## What it does

1. Reads the templates from `~/.config/agents-setup/templates/`.
2. Shows the paths that will be created and prompts `Continue? (y/N)`.
3. On `y`, recursively creates the destination folder and writes or overwrites
   each file with the template content.
4. On anything else, cancels and writes nothing.

The generated `plan.md` and `build.md` **override OpenCode's built-in agents**
of the same names. This means:

- `plan.md` activates automatically when you enter **Plan Mode** in OpenCode.
- `build.md` is the default agent used in **Build Mode**.
- Neither template hardcodes a `model` field, so both inherit the model
  configured globally in `opencode.json` (`"model": "provider/model-id"`).
  Change the global model at any time and both agents follow.

## Repository layout

```
agents-setup/
├── README.md
├── install.sh            # bundles templates into ~/.config/agents-setup/
├── bin/
│   └── agents-setup      # the CLI (single shell script, no dependencies)
└── templates/
    ├── plan.md           # planner agent template
    └── build.md          # builder agent template
```

## Platform support
Currently **macOS / Linux** via `bash`. A **PowerShell** port for Windows is planned.
