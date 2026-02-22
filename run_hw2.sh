#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo ""
    echo "Usage: ./run_hw2.sh <benchmark> <automaton>"
    echo "  benchmark: blackscholes bodytrack canneal dedup fluidanimate freqmine streamcluster swaptions x264"
    echo "  automaton: A2 A3"
    exit 1
fi

# Use Windows-format path (pwd -W) to avoid Git Bash MSYS path mangling with Docker on Windows
HOSTPATH="$(pwd -W)"

MSYS_NO_PATHCONV=1 docker run --rm \
    -v "${HOSTPATH}:/app" \
    --privileged \
    casim-csce614 \
    bash -c "cd /app/zsim && ./hw2runscript_foreground '$1' '$2'"
