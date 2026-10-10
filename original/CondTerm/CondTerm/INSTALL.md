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
   msbuild Boogie.sln
   ```

4. Build `C5.0` in `ice/popl16_artifact/C50`

   ```sh
   make clean; make all
   ```

   Then, copy all generated `c5.0.*` into `ice/popl16_artifact/Boogie/Binaries`

5. Download `z3 4.8.9` from [Github](https://github.com/Z3Prover/z3/releases/download/z3-4.8.9/z3-4.8.9-x64-ubuntu-16.04.zip)

   Unzip the zip file, copy the inside `bin/z3` into `ice/popl16_artifact/Boogie/Binaries` and rename it to `z3.exe`