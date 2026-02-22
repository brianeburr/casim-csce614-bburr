# casim

Computer Architecture Simulation Infrastructure for CSCE 614 Computer Architecture

##### 1. Unzip benchmarks files

```
zip -F benchmarks.zip --out single-benchmark.zip && unzip single-benchmark.zip && mkdir benchmarks/parsec-2.1/inputs/streamcluster
```

### 2. Environemnt setup

To set up the Python environment for the first time, run the following commands.

```
$ python -m venv venv
$ source venv/bin/activate
$ pip install scons
```

Everytime you want to build or run zsim, you need to setup the environment variables first.

```
$ source venv/bin/activate
$ source setup_env
```

##### 3. Compile zsim

```
$ cd zsim
$ scons -j4
```

You need to compile the code each time you make a change.

###### For more information, check `zsim/README.md`

---

## Docker Usage

The Docker setup automates all environment and build steps (venv, scons, benchmarks, ptrace scope) on container start. Steps 1–3 above are handled automatically inside the container.

**Prerequisites:** Docker must be installed and running. On Windows, use Git Bash for the commands below.

### Build the image

Build once before using any of the methods below.

```bash
docker build -t casim-csce614 .
```

Or with Docker Compose (also builds if needed):

```bash
docker compose build
```

---

### Option A: Docker Compose (persistent container)

Start a long-lived container you can attach to repeatedly.

```bash
# Start the container in the background (builds zsim on first start)
docker compose up -d

# Attach an interactive shell
docker compose exec casim bash

# Stop the container when done
docker compose down
```

Inside the attached shell, the venv and `setup_env` are already active. You can run simulations directly and rebuild zsim as needed:

```bash
cd zsim
scons -j4
./hw2runscript blackscholes A2
```

---

### Option B: Dockerfile standalone (one-shot container)

Run a single simulation without a persistent container. The container starts, runs the simulation, and exits automatically.

```bash
HOSTPATH="$(pwd -W)"   # Windows (Git Bash) — use $(pwd) on Linux/Mac

MSYS_NO_PATHCONV=1 docker run --rm \
    -v "${HOSTPATH}:/app" \
    --privileged \
    casim-csce614 \
    bash -c "cd /app/zsim && ./hw2runscript_foreground blackscholes A2"
```

Output logs are written to `zsim/outputs/hw2/<automaton>/<benchmark>_8c_simsmall/<benchmark>.log`.

---

### Option C: `run_hw2.sh` (single benchmark wrapper)

Wraps the one-shot Docker invocation for a single benchmark/automaton pair. Handles Windows path issues automatically.

```bash
bash run_hw2.sh <benchmark> <automaton>
```

**Arguments:**

- `benchmark`: `blackscholes bodytrack canneal dedup fluidanimate freqmine streamcluster swaptions x264`
- `automaton`: `A2 A3`

**Example:**

```bash
bash run_hw2.sh blackscholes A2
```

The container exits when the simulation finishes. Logs are saved to `zsim/outputs/hw2/A2/blackscholes_8c_simsmall/blackscholes.log`.

---

### Option D: `run_hw2_parallel.sh` (all benchmarks in parallel)

Launches all benchmark/automaton combinations simultaneously, each in its own Docker container. Waits for all to complete and reports any failures.

```bash
bash run_hw2_parallel.sh
```

By default this runs all 9 benchmarks × 2 automatons = 18 containers in parallel. Edit the `BENCHMARKS` and `AUTOMATONS` variables at the top of the script to run a subset.

**Example (subset):**

```bash
# In run_hw2_parallel.sh, edit:
BENCHMARKS="blackscholes bodytrack"
AUTOMATONS="A2"
```

All logs are written independently to their respective output directories under `zsim/outputs/hw2/`.
