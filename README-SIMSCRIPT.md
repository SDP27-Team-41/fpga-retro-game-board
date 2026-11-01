# TODOs
- Implement synthesis with Yosys
- Add support for cocotb
- Automatically open gtkwave with a default config if it exists

# The Simulation Script Guide

The project uses `sim-and-synth.py` to compile and run HDL testbenches with
Icarus Verilog and `vvp`. Rose originally wrote this script for a different FPGA
project back in 2024.

## Testbench layout

Create a testbench directory for each module you want to test. The testbench
goes under the `verif` folder that the module we are testing lives under. For
example, `support/verif/<module_name>/`

Files under it include
- `test_<module>.sv`: Main testbench
- `testbench.cf`: Command file for iverilog/other simulation tool

Additional files, such as GTKWave configuration files, can be kept
in the same directory.

## Command file

The `testbench.cf` file tells Icarus which HDL and testbench files to compile.
The existing testbenches use this structure:

```
# Main project HDL
-y $(HDL_ROOT)/support

# Testbench files
-y $(TESTBENCH_ROOT)
+incdir+$(TESTBENCH_ROOT)

$(TESTBENCH_ROOT)/test_<module>.sv
```

`sim-and-synth.py` sets `HDL_ROOT` to the HDL source directory and
`TESTBENCH_ROOT` to the selected testbench directory. If a source file could
conflict with another module in the support directory, list that source
explicitly instead of using `-y` for the whole directory.

## Build and run

Run the commands from the repository root. Compile a testbench with `-b`:

```sh
python3 sim-and-synth.py hdl/verif/<module> -b
```

Run an existing build with `-r`:

```sh
python3 sim-and-synth.py hdl/verif/<module> -r
```

Compile and run in one command:

```sh
python3 sim-and-synth.py hdl/verif/<module> -b -r
```

The default build directory is `build-hdl/`. The compiled simulation binary
is named after the testbench directory. Waveform files are written to the
build directory when the simulation runs.

For complete script help, run:

```sh
python3 sim-and-synth.py -h
```

