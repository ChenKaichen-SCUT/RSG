# CondTerm

CondTerm is a tool for generating accurate termination conditions for loops. It is based on data-driven termination prover ddlTerm and non-termination prover RSLearn.

## Install on Linux

*We tested the following procedure on Ubuntu 22.04.*

1. Install the [Mono environment](https://www.mono-project.com/download/stable/#download-lin)

2. Install `python3`, `gcc/g++`, `make` and the necessary pip packages

   ```sh
   apt install -y gcc g++ make python3 python3-pip
   pip install pandas scipy scikit-learn antlr4-python3-runtime xlsxwriter
   ```

3. Build `Boogie` in `ice/popl16_artifact/Boogie/Source`

   ```sh
   msbuild NewBoogie.sln
   ```

4. Build `C5.0` in `ice/popl16_artifact/C50`

   ```sh
   make clean; make all
   ```

   Then, copy all generated `c5.0.*` into `ice/popl16_artifact/Boogie/Binaries`

5. Download `z3 4.8.9` from [Github](https://github.com/Z3Prover/z3/releases/download/z3-4.8.9/z3-4.8.9-x64-ubuntu-16.04.zip)

   Unzip the zip file, copy the inside `bin/z3` into `ice/popl16_artifact/Boogie/Binaries` and rename it to `z3.exe`

## Run on Linux

1. Please update the configuration file `experiment/scripts/Config.xml` first.

   ```xml
   <!-- A path to tmp directory -->
   <Tmp>/tmpfs</Tmp>
   <!-- A path to output result directory -->
   <Log_Dir>/my/path/to/log</Log_Dir>
   ```

2. Run the experiments (e.g. the main experiment in our paper)

   ```sh
   cd CondTerm
   python3 experiment/scripts/RunTasks.py experiment/scripts/Config.xml
   ```

​	Following ddlTerm, we suggest using [tmpfs](https://man7.org/linux/man-pages/man5/tmpfs.5.html) to reduce the time of IO.

The result Excel file will be located at `/my/path/to/log`, and the output of each benchmark will be in a subfolder within `outputs/` with the same name as the Excel file.

## The Baseline Tool

To run a comparative experiment against the baseline tool Acabar, please visit [its website](http://loopkiller.com/acabar/acabar.php#syntax) to download the executable file. 

- The benchmarks manually transferred for Acabar locate in `experiment/condterm-benchmarks-acabar`
- The running script can be found at `experiment/baseline.scripts/Acabar` and please modify the paths in the scripts before executing.

## File Structure

- `experiment/` includes benchmarks and important scripts
  - `scripts/` includes scripts to run the experiment, among which `CondTerm.py` is the main entrance of CondTerm
  - `baseline.scripts` contains the script for running the base line tool Acabar
  - `condterm-benchmarkd*` are benchmarks used for CondTerm as well as Acabar
- `src/` includes codes to support ddlTerm and RSLearn
  - `RSLearner.py` is to prepocess and call RSLearn to get a recurrent set.
  - The others are inherited from ddlTerm and we made some modification
- `ice/` includes an open source safety validator `ICE-DT`
  - we incorporated the implementation of RSLearn into `popl16_artifact/Boogie/Source` and  made some modification.
