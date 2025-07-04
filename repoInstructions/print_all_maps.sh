#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Hardcoded input file
input_file="${SCRIPT_DIR}/../kitty.conf"

# Function to show usage
usage() {
    echo "Usage: $0 [--print | outputfile]"
    echo "  --print       Print results to STDOUT"
    echo "  outputfile    Write results to specified file"
    exit 1
}

# Check for arguments
if [ "$#" -ne 1 ]; then
    usage
fi

if [ "$1" == "--print" ]; then
    grep '^map' "$input_file" | awk '{printf "%s %-"(20 - 1)"s %s\n", $1, $2, $3}'
else
    output_file="$1"
    grep '^map' "$input_file" | awk '{printf "%s %-"(20 - 1)"s %s\n", $1, $2, $3}'
    echo "Results written to $output_file"
fi
