# TODOs
- Add support for cocotb
- Automatically open gtkwave with a default config if it exists

# Simulation Script README

`sim-and-synth.py` is a helper to compile and run HDL testbenches with Icarus Verilog and
`vvp`. Rose originally wrote this script for a different FPGA project back in 2024.

For details on the specific arguments, you can run `sim-and-synth.py -h`

## Testbench layout

Create a testbench directory for each module you want to test. Try to call them `verif`
for verification. For example, `support/verif/<debounce>/` would be a good name for
testing the debouncer that lives under the `support` hdl.

Files in this directory include
- `test_<module>.sv`: Main testbench
- `testbench.cf`: Command file for iverilog/other simulation tool
- `wave_conf.gtkw`: Save file for waveform viewing.

Additional files, such as GTKWave configuration files, can be kept in the same directory.

## Command file

The `testbench.cf` file tells Icarus which HDL and testbench files to compile. The most
basic testbenches can get away with

```
# Main project HDL
-y $(HDL_ROOT)/support

# Testbench files
-y $(TESTBENCH_ROOT)
+incdir+$(TESTBENCH_ROOT)

$(TESTBENCH_ROOT)/test_<module>.sv
```

`sim-and-synth.py` sets `HDL_ROOT` to the HDL source directory and `TESTBENCH_ROOT` to the
selected testbench directory; they are environment variables.

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
python3 sim-and-synth.py hdl/verif/<module> -br
```

The default build directory is `build-hdl/`. Any sort of intermediate or output file will
be dumped here to avoid cluttering the repo.


## Synthesis

If you want to target synthesis to the FPGA, make a directory containing a Yosys Tcl script
and Lattice board constraints:

For example `hdl/fpga-blink-test/`:
- `blink.sv`
- `synth_blink/`
  - `yosys.tcl`
  - `ulx3s.lpf`

Run the complete Yosys, nextpnr, and bitstream-packaging flow by passing the
synthesis directory and `-s`:

```sh
python3 sim-and-synth.py hdl/fpga-blink-test/synth_blink -s
```

Again, output is put in `build-hdl` by default.
