module blink (/*AUTOARG*/
   // Outputs
   led,
   // Inputs
   clk_25mhz, btn
   ) ;
   // Simple module with blink and buttons
   
   input wire clk_25mhz;
   input wire [6:0] btn;
   output logic [7:0] led;

   logic rst;
   always_comb rst = ~btn[0]; // Reset button is pull up, others are pull down

   // led[7] will be triggered through any of btn[6:1]
   always_comb led[7] = |btn[6:1]; // Prefixing with | means to OR all of the
                                   // inputs together from the combined bus

   // LED[6:0] will just be a counter
   logic count[15:0];
   always_ff @(posedge clk) begin
      if (rst) begin
         count <= 16'b0;
      end else begin
         count <= count + 1;
      end
   end

   always_comb led[6:0] = count[15:9]; // We use the upper bits of a too large
                                       // count to slow it down so it's human
                                       // visible
   
endmodule // blink
