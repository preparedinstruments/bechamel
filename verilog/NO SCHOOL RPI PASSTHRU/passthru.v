module verilog(

      input wire  rpi_h_sync,
      input wire  rpi_v_sync,
      input wire  rpi_color, 
      
      output wire  h_sync,
      output wire  v_sync,
      output wire  [3:0] r_out, 
      output wire  [3:0] g_out,
      output wire  [3:0] b_out
      );


assign h_sync = rpi_h_sync;

assign v_sync = rpi_v_sync;

assign r_out[0] = rpi_color;
assign r_out[1] = rpi_color;
assign r_out[2] = rpi_color;

assign b_out[0] = rpi_color;
assign b_out[1] = rpi_color;
assign b_out[2] = rpi_color;

assign g_out[0] = rpi_color;
assign g_out[1] = rpi_color;
assign g_out[2] = rpi_color;


endmodule