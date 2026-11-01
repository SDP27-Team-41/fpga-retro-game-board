`default_nettype none
`timescale 1ns/1ps

module debounce (/*AUTOARG*/
   // Outputs
   pos_edge, neg_edge,
   // Inputs
   clk, rst, ena, in
   ) ;
   parameter N = 1; // How many signals should this instance handle

   input wire clk, rst, ena;
   input wire [N-1:0] in;
   output logic [N-1:0] pos_edge, neg_edge;

   logic [N-1:0] prev;
   
   always_ff @(posedge clk) begin
      if(rst) begin
         /*AUTORESET*/
         // Beginning of autoreset for uninitialized flops
         prev <= {N{1'b0}};
         // End of automatics
      end else begin
         prev <= in;
      end
   end // always_ff @ (posedge clk)

   always_comb begin
      pos_edge = in & ~prev; // Input high and previous low
      neg_edge = ~in & prev; // Input low and previous high
   end

endmodule // debounce
