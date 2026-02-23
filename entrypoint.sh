#!/bin/bash

cd /app

if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

venv/bin/pip install --quiet scons || true

sed -i 's/\r$//' setup_env zsim/hw2runscript zsim/hw2runscript_foreground zsim/hw4runscript zsim/hw4runscript_foreground run_zsim_consecutive.sh 2>/dev/null || true
source setup_env

chmod +x tools/pin-2.14-71313-gcc.4.4.7-linux/intel64/bin/pinbin || true
chmod +x zsim/hw2runscript zsim/hw2runscript_foreground zsim/hw4runscript run_zsim_consecutive.sh || true

if [ ! -d "benchmarks" ] && [ -f "benchmarks.zip" ]; then
    zip -F benchmarks.zip --out single-benchmark.zip && \
    unzip single-benchmark.zip && \
    mkdir -p benchmarks/parsec-2.1/inputs/streamcluster
fi

echo 0 > /proc/sys/kernel/yama/ptrace_scope || true
if [ ! -f "zsim/build/opt/zsim" ]; then
    (cd zsim && ../venv/bin/scons -j4) || true
fi

cd /app/zsim
exec "$@"
