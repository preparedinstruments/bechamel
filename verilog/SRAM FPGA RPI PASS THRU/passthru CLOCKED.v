module verilog(
     // NO NEED FOR RPI PIXEL CLOCK, THE NOISE CAUSES ISSUES DISPLAYING 
      input wire  clk,
      input wire  rpi_h_sync,
      input wire  rpi_v_sync,
      input wire  rpi_color, 
      
      output wire  h_sync,
      output wire  v_sync,
      output reg  [3:0] r_out, 
      output reg  [3:0] g_out,
      output reg  [3:0] b_out
      );


assign h_sync = rpi_h_sync;

assign v_sync = rpi_v_sync;

reg [3:0] counter = 0;

always @(posedge clk) begin

      counter <= counter + 1;
  if (counter[2]) begin

	r_out[0] <= rpi_color;
	r_out[1] <= rpi_color;
	r_out[2] <= rpi_color;

	b_out[0] <= rpi_color;
	b_out[1] <= rpi_color;
	b_out[2] <= rpi_color;

	g_out[0] <= rpi_color;
	g_out[1] <= rpi_color;
	g_out[2] <= rpi_color;

  end
end 




endmodule