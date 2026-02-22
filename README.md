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


GCC Change Notes:
Seems like build errors are showing up, unexpected. Want to try with a lower version of gcc, matching remote


# Install multiple versions
sudo apt install gcc-11 g++-11 gcc-13 g++-13

# Register them with priorities
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 90 --slave /usr/bin/g++ g++ /usr/bin/g++-13
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 80 --slave /usr/bin/g++ g++ /usr/bin/g++-11

# Select active gcc
sudo update-alternatives --config gcc

