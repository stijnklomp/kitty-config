#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Paths
UPPER_DIR="${SCRIPT_DIR}/../"
BASE_CONFIG="${UPPER_DIR}base.conf"
MAC_CONFIG="${UPPER_DIR}macos.conf"
LINUX_CONFIG="${UPPER_DIR}linux.conf"
WINDOWS_CONFIG="${UPPER_DIR}windows.conf"
FINAL_CONFIG="${UPPER_DIR}kitty.conf"

# Detect OS
OS_TYPE="$(uname)"
case "$OS_TYPE" in
    Darwin)
        OS_SPECIFIC_CONFIG="$MAC_CONFIG"
        ;;
    Linux)
        OS_SPECIFIC_CONFIG="$LINUX_CONFIG"
        ;;
    MINGW*|MSYS*|CYGWIN*)
        OS_SPECIFIC_CONFIG="$WINDOWS_CONFIG"
        ;;
    *)
        echo "Unsupported OS: $OS_TYPE"
        exit 1
        ;;
esac

# Check files exist
if [[ ! -f "$BASE_CONFIG" ]]; then
    echo "Base config not found: $BASE_CONFIG"
    exit 1
fi

if [[ ! -f "$OS_SPECIFIC_CONFIG" ]]; then
    echo "OS-specific config not found: $OS_SPECIFIC_CONFIG"
    exit 1
fi

# Extract modeline (if any) from base config
MODELINE=$(grep -m1 '^# vim:fileencoding=' "$BASE_CONFIG")

# Strip modelines from both configs
CLEAN_BASE=$(mktemp)
CLEAN_OS=$(mktemp)

grep -v '^# vim:fileencoding=' "$BASE_CONFIG" > "$CLEAN_BASE"
grep -v '^# vim:fileencoding=' "$OS_SPECIFIC_CONFIG" > "$CLEAN_OS"

# Combine into final config
{
    [[ -n "$MODELINE" ]] && echo "$MODELINE"
    cat "$CLEAN_BASE"
    echo -e "\n# --- OS-specific additions ---"
    cat "$CLEAN_OS"
} > "$FINAL_CONFIG"

# Cleanup
rm "$CLEAN_BASE" "$CLEAN_OS"

echo "Final Kitty config generated at: ~/.config/kitty/kitty.conf"
