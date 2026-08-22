#!/usr/bin/env bash

set -euo pipefail

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------


SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

PROJECT_NAME="$(basename "$SCRIPT_DIR")"
SCRIPT_PATH="$SCRIPT_DIR/$PROJECT_NAME.sh"

INSTALL_DIR="$HOME/.local/bin"
SHIM_PATH="$INSTALL_DIR/$PROJECT_NAME"

# ---------------------------------------------------------------------------
# Arguments
# ---------------------------------------------------------------------------

show_help() {
    cat <<EOF
Usage: install-shim

Install the current project's shell script as a command in ~/.local/bin.

Options:
  -h, --help    Show this help message.
EOF
}

case "${1:-}" in
    -h|--help)
        show_help
        exit 0
        ;;
esac

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

mkdir -p "$INSTALL_DIR"

cat > "$SHIM_PATH" <<EOF
#!/usr/bin/env bash

exec "$SCRIPT_PATH" "\$@"
EOF

chmod +x "$SHIM_PATH"

echo "Installed $PROJECT_NAME to:"
echo "  $SHIM_PATH"