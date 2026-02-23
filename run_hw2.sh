#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo ""
    echo "Usage: ./run_hw2.sh <benchmark> <automaton>"
    echo "  benchmark: blackscholes bodytrack canneal dedup fluidanimate freqmine streamcluster swaptions x264"
    echo "  automaton: A2 A3"
    exit 1
fi

# Use Windows-format path on Git Bash/MSYS to avoid path mangling with Docker; use pwd elsewhere
case "$(uname -s)" in
    MINGW*|CYGWIN*|MSYS*)
        HOSTPATH="$(pwd -W)"
        ;;
    *)
        HOSTPATH="$(pwd)"
        ;;
esac

MSYS_NO_PATHCONV=1 docker run --rm \
    -v "${HOSTPATH}:/app" \
    --privileged \
    casim-csce614-zsim \
    bash -c "cd /app/zsim && ./hw2runscript_foreground '$1' '$2'"
