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

   logic              rst;
   always_comb rst = ~btn[0]; // Reset button is pull up, others are pull down

   // led[7] will be triggered through any of btn[6:1]
   always_comb led[7] = |btn[6:1]; // Prefixing with | means to OR all of the
   // inputs together from the combined bus

   // LED[6:0] will just be a counter
   logic [31:0] count;
   
   always_ff @(posedge clk_25mhz) begin
      if (rst) begin
         count <= 0;
      end else begin
         count <= count + 1;
      end
   end

   // We use the upper bits of a too large count to slow it down so it's human
   // visible
   always_comb led[6:0] = count[31:25];
   
   
   // assign led[6] = count[15];
   // assign led[5] = count[14];
   // assign led[4] = count[13];
   // assign led[3] = count[12];
   // assign led[2] = count[11];
   // assign led[1] = count[10];
   

endmodule // blink
