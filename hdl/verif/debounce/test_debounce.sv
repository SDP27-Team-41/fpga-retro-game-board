`default_nettype none
`timescale 1ns/1ps

// Rudimentary Verilog testbench; we can also write them in Python with cocotb
// or in C++
// This does not contain any self checking
module test_debounce;
   parameter CLK_HZ = 25_000_000;
   localparam CLK_PERIOD_NS = 1_000_000_000.0/CLK_HZ;

   // DUT I/O
   logic clk;
   logic rst;
   logic ena;
   logic [6:0] in;
   wire [6:0] out;

   // Instantiate the Device Under Test (DUT)
   debounce 
     #(.DIV_AMOUNT(4), // Parameters
       .NBUTTONS(7))
   DUT( // DUT is the name of the instance
       // Connected nets
       // Inputs
       .clk(clk),
       .rst(rst),
       .ena(ena),
       .in(in),
       // Outputs
       .out(out));

   // Generate clock
   always #(CLK_PERIOD_NS/2.0) clk = ~clk;
   
   // Kill the testbench if it runs too long
   initial begin
      repeat (1000) @(posedge clk);
      $display("Test timed out!");
      $finish;
   end

   // Generate stimulus signals
   initial begin
      $dumpfile("debounce.fst");
      $dumpvars;

      // Reset the debouncer
      clk = 0;
      rst = 1;
      ena = 1;
      in = 7'b0000000;

      // Wait two negative clock edges for reset logic
      repeat(2) @(negedge clk);

      // Change inputs
      rst = 0;
      ena = 1;
      in = 7'b1110011; // Arbitrary inputs

      // We set the debouncer to divide the clock by 2^4, We should expect to see a change after 16 clock cycles
      // We are gonna wait 17
      repeat(17) @(negedge clk);

      // We are going to invert each of the input signals, but we will do it "noisily" by just toggling it a few times.
      in = ~in;
      repeat (1) @(negedge clk);
      in = ~in; // This is the "noise"
      repeat (1) @(negedge clk);
      in = ~in;
      repeat (16) @(negedge clk);

      // We should see the output have changed by now
      // Let's turn off the enable to check that outputs turn off
      ena = 0;
      repeat(4) @(negedge clk);
      $finish;
   end

   
endmodule // test_debounce
