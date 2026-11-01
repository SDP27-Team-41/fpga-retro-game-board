`default_nettype none
`timescale 1ns/1ps

module test_blink;
   parameter CLK_HZ = 25_000_000;
   localparam CLK_PERIOD_NS = 1_000_000_000.0/CLK_HZ;

   logic clk_25mhz;
   logic [6:0] btn;
   wire [7:0] led;

   blink DUT(
       .clk_25mhz(clk_25mhz),
       .btn(btn),
       .led(led));

   always #(CLK_PERIOD_NS/2.0) clk_25mhz = ~clk_25mhz;

   initial begin
      $dumpfile("blink.fst");
      $dumpvars;

      clk_25mhz = 0;
      btn = 7'b0000000;

      // Reset by holding the button down
      repeat(2) @(negedge clk_25mhz);
      btn[0] = 1;

      // Turn on a button
      btn[1] = 1;
      repeat(100) @(negedge clk_25mhz);

      btn[1] = 0;
      repeat(100) @(negedge clk_25mhz);
      
      btn[4] = 1;
      repeat(100) @(negedge clk_25mhz);
      
      btn[4] = 0;
      repeat(100) @(negedge clk_25mhz);
   end

   initial begin
      repeat(67000) @(negedge clk_25mhz);
      $finish;
   end

endmodule
