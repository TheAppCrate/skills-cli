#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_NAME="skills"
INSTALL_DIR="${1:-/usr/bin}"

# Build release if not already built
BINARY="$SCRIPT_DIR/target/release/$BIN_NAME"
if [ ! -f "$BINARY" ]; then
    echo "Binary not found, building..."
    "$SCRIPT_DIR/build.sh"
fi

mkdir -p "$INSTALL_DIR"
cp "$BINARY" "$INSTALL_DIR/$BIN_NAME"
chmod +x "$INSTALL_DIR/$BIN_NAME"

VERSION=$("$INSTALL_DIR/$BIN_NAME" --version 2>/dev/null || echo "unknown")
echo "Installed $BIN_NAME $VERSION → $INSTALL_DIR/$BIN_NAME"

if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
    echo ""
    echo "Warning: $INSTALL_DIR is not in PATH"
    echo "Add to your shell config:"
    echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
fi
