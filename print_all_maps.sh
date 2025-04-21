#!/bin/bash

# Hardcoded input file
input_file="$(dirname "$0")/kitty.conf"
#input_file="~/.config/kitty/kitty.conf"

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
    grep '^map' "$input_file"
else
    output_file="$1"
    grep '^map' "$input_file" > "$output_file"
    echo "Results written to $output_file"
fi
