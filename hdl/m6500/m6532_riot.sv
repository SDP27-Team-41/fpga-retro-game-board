`default_nettype none
`timescale 1ns/1ps

// The 6532 is the RAM-I/O-Timer, or RIOT. It is used in the Atari 2600. It has 128 bytes (no
// prefix) of SRAM on board, so we don't even need to use a block RAM and can get away with
// inferring as flip flops or LUTs. It also handles I/O and has a timer function.

module m6532_riot (/*AUTOARG*/
   // Outputs
   irq,
   // Inouts
   data, pa, pb,
   // Inputs
   clk, res_n, read_write, cs1, cs2_n, rs_n, addr
   ) ;
   // Page 2 of the datasheet
   input wire phi_2;       // phi2 clock from 6502
   input wire res_n;
   input wire read_write;  // R/W on datasheet
   input wire cs1;         // CS1 is active high
   input wire cs2_n;       // CS2 is active low
   input wire rs_n;        // RAM select, low means addr pins address RAM on chip, high means it is
                           // addressing registers to configure I/O pins (see datasheet table 1)
   output logic irq;       // Interrupt request
   inout logic [7:0] data;
   input wire  [6:0] addr;
   inout logic [7:0] pa;   // I/O pins
   inout logic [7:0] pb;   // I/O pins
   
   // Magic numbers are bad but we are recreating a real chip with fixed values
   logic [7:0] memory [2**7-1:0]; // 128 (2^7) byte memory
endmodule // m6532_riot
