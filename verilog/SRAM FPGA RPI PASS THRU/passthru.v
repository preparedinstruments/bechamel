module verilog(
     // NO NEED FOR RPI PIXEL CLOCK, THE NOISE CAUSES ISSUES DISPLAYING 
      input wire  rpi_h_sync,
      input wire  rpi_v_sync,
      input wire  rpi_color, 
      
      output wire  h_sync,
      output wire  v_sync,
      output wire  color
      );


assign h_sync = rpi_h_sync;

assign v_sync = rpi_v_sync;

assign color = rpi_color;

endmodule