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