`default_nettype none
`timescale 1ns/1ps

module debounce (/*AUTOARG*/
   // Outputs
   out,
   // Inputs
   clk, rst, ena, in
   ) ;
   parameter DIV_AMOUNT = 10; // Divide on 2^DIV_AMOUNT
   parameter NBUTTONS = 1;
   localparam COUNT_W=$clog2(DIV_AMOUNT);

   input wire clk, rst, ena;
   input wire [NBUTTONS-1:0] in;
   output logic [NBUTTONS-1:0] out;

   logic [COUNT_W-1:0] count;

   logic ena_sample; // If high, take a button sample
   logic [NBUTTONS-1:0] sample; // Button sample to output
   
   always_ff @(posedge clk) begin
      if(rst) begin
         /*AUTORESET*/
         // Beginning of autoreset for uninitialized flops
         count <= {COUNT_W{1'b0}};
         sample <= {NBUTTONS{1'b0}};
         // End of automatics
      end else begin
         count <= count + 1;

         if (ena_sample) begin
            sample <= in;
         end
      end
   end // always_ff @ (posedge clk)

   always_comb begin
      ena_sample = &count; // Only sample if count is all 1s
      out = ena ? sample : 0;
   end

endmodule // debounce
