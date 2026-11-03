`default_nettype none
`timescale 1ns/1ps

module test_edge_detector;
   parameter CLK_HZ = 25_000_000;
   localparam CLK_PERIOD_NS = 1_000_000_000.0/CLK_HZ;

   logic clk;
   logic rst;
   logic ena;
   logic in;
   wire pos_edge;
   wire neg_edge;

   edge_detector
     #(.N(1))
   DUT(
       .clk(clk),
       .rst(rst),
       .in(in),
       .pos_edge(pos_edge),
       .neg_edge(neg_edge));

   always #(CLK_PERIOD_NS/2.0) clk = ~clk;

   initial begin
      $dumpfile("edge_detector.fst");
      $dumpvars;

      clk = 0;
      rst = 1;
      ena = 1;
      in = 0;

      repeat(2) @(negedge clk);
      rst = 0;

      repeat(8) @(negedge clk);
      in = 1;

      repeat(10) @(negedge clk);
      in = 0;
   end

   initial begin
      repeat(30) @(negedge clk);
      $finish;
   end

endmodule
