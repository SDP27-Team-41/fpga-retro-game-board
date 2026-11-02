set source_file [file join $::env(SYNTHESIS_ROOT) .. blink.sv]
set json_file $::env(JSON_FILE)

yosys read_verilog -sv $source_file
yosys synth_ecp5 -top blink
yosys write_json $json_file
