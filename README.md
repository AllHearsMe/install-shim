# install-shim

Install a project's shell script as a command in `~/.local/bin`.

## Installation

Clone the repository and run the installer:

```bash
git clone <repository-url>
cd install-shim
./install-shim.sh
```

This installs `install-shim` to `~/.local/bin`. Make sure `~/.local/bin` is included in your `PATH`.

## Usage

```bash
install-shim [options] [path]
```

If `path` is omitted, the current directory is used.

If `path` is a file, its name is used as the command name. A trailing `.sh` is removed from the command name.

If `path` is a directory, `install-shim` looks for a shell script whose name matches the directory name:

```text
my-tool/
└── my-tool.sh
```

The script is installed as:

```text
~/.local/bin/my-tool
```

The generated shim references the target script by its absolute path. If the project is moved, reinstall the shim from its new location.

### Options

```text
-f, --force   Overwrite an existing command shim.
-h, --help    Show this help message.
```

## Examples

Install the current project:

```bash
install-shim
```

Install a project from another directory:

```bash
install-shim ~/Documents/Projects/Tools/my-tool
```

Install a script directly:

```bash
install-shim ./my-tool.sh
```

The resulting command is available through `PATH`:

```bash
my-tool
```

Arguments are forwarded to the installed script.

## Requirements

* Bash

The target script must exist and be executable.

## Development

### TODO

* [ ] Test rejection of a non-executable target script on a Unix-like filesystem.

## License

MIT — see [LICENSE](LICENSE).
