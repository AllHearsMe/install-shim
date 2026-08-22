#!/usr/bin/env bash

set -euo pipefail

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------

INSTALL_DIR="$HOME/.local/bin"

# ---------------------------------------------------------------------------
# Arguments
# ---------------------------------------------------------------------------

show_help() {
    cat <<EOF
Usage: install-shim [path]

Install a shell script as a command in ~/.local/bin.

If path is omitted, the current directory is used.
If path is a file, its name is used as the command name.
If path is a directory, <directory-name>.sh is used as the entry script.

Options:
  -h, --help    Show this help message.
EOF
}

TARGET="."

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            echo "Error: unknown option: $1" >&2
            echo "Try 'install-shim --help' for more information." >&2
            exit 1
            ;;
        *)
            [[ "$TARGET" == "." ]] ||
                {
                    echo "Error: too many arguments" >&2
                    echo "Try 'install-shim --help' for more information." >&2
                    exit 1
                }

            TARGET="$1"
            ;;
    esac

    shift
done

# ---------------------------------------------------------------------------
# Determine script and command name
# ---------------------------------------------------------------------------

if [[ -f "$TARGET" ]]; then
    SCRIPT_PATH="$(cd -- "$(dirname -- "$TARGET")" && pwd)/$(basename "$TARGET")"

    COMMAND_NAME="$(basename "$TARGET")"
    COMMAND_NAME="${COMMAND_NAME%.sh}"

elif [[ -d "$TARGET" ]]; then
    PROJECT_DIR="$(cd -- "$TARGET" && pwd)"
    PROJECT_NAME="$(basename "$PROJECT_DIR")"

    SCRIPT_PATH="$PROJECT_DIR/$PROJECT_NAME.sh"
    COMMAND_NAME="$PROJECT_NAME"

else
    echo "Error: '$TARGET' is not a file or directory." >&2
    exit 1
fi

# ---------------------------------------------------------------------------
# Preconditions
# ---------------------------------------------------------------------------

[[ -f "$SCRIPT_PATH" ]] ||
    {
        echo "Error: $SCRIPT_PATH does not exist" >&2
        exit 1
    }

[[ -x "$SCRIPT_PATH" ]] ||
    {
        echo "Error: $SCRIPT_PATH is not executable" >&2
        exit 1
    }

# ---------------------------------------------------------------------------
# Install shim
# ---------------------------------------------------------------------------

SHIM_PATH="$INSTALL_DIR/$COMMAND_NAME"

mkdir -p "$INSTALL_DIR"

if [[ -e "$SHIM_PATH" ]]; then
    read -r -p "$SHIM_PATH already exists. Overwrite? [y/N] " response

    [[ "$response" =~ ^[Yy]$ ]] ||
        exit 0
fi

cat > "$SHIM_PATH" <<EOF
#!/usr/bin/env bash

exec "$SCRIPT_PATH" "\$@"
EOF

chmod +x "$SHIM_PATH"

echo "Installed $COMMAND_NAME to:"
echo "  $SHIM_PATH"