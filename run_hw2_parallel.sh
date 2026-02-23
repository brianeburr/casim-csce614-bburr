#!/bin/bash

BENCHMARKS="blackscholes bodytrack canneal dedup fluidanimate freqmine streamcluster swaptions x264"
AUTOMATONS="A2 A3"

# Resolve host path (cross-platform: Git Bash on Windows vs Linux/Mac)
case "$(uname -s)" in
    MINGW*|CYGWIN*|MSYS*)
        HOSTPATH="$(pwd -W)"
        ;;
    *)
        HOSTPATH="$(pwd)"
        ;;
esac

# Build zsim once before launching parallel simulations to avoid contention over zsim/build/
echo "Pre-building zsim..."
MSYS_NO_PATHCONV=1 docker run --rm \
    -v "${HOSTPATH}:/app" \
    --privileged \
    casim-csce614-zsim \
    bash -c "true"
echo "Build step complete."
echo ""

PIDS=()

for automaton in $AUTOMATONS; do
    for bench in $BENCHMARKS; do
        echo "Launching: $bench $automaton"
        bash run_hw2.sh "$bench" "$automaton" &
        PIDS+=($!)
    done
done

echo ""
echo "All ${#PIDS[@]} simulations launched. Waiting for completion..."

FAILED=0
for pid in "${PIDS[@]}"; do
    if ! wait "$pid"; then
        FAILED=$((FAILED + 1))
    fi
done

echo ""
if [ "$FAILED" -eq 0 ]; then
    echo "All simulations completed successfully."
else
    echo "$FAILED simulation(s) failed. Check individual logs in zsim/outputs/hw2/."
fi
