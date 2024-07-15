`default_nettype none

module vga_sync_test(

input wire clk_in,

input wire [8:0] key,
//RASPBERRY PI
input wire rpi_hsync, 
input wire rpi_vsync, 
input wire analog_in,

//VGA OUT
output reg [2:0] r_out,
output reg [2:0] b_out,
output reg [2:0] g_out,

output wire h_sync,
output wire v_sync
);


assign h_sync = rpi_hsync;
assign v_sync = rpi_vsync;

reg [14:0] clk_div;

reg sample_rate;

//VGA COLOR OUT

always @(posedge clk_in) begin

	clk_div <= clk_div + 1'b1;
		
end

always @(*) begin

	  case(key[8:5])
	  
		 4'b0000: sample_rate = clk_div[14];  
		 4'b0001: sample_rate = clk_div[13];
		 4'b0010: sample_rate = clk_div[12];
		 4'b0011: sample_rate = clk_div[11];		

		 4'b0100: sample_rate = clk_div[10]; 
		 4'b0101: sample_rate = clk_div[9];
		 4'b0110: sample_rate = clk_div[8];
		 4'b0111: sample_rate = clk_div[7];	

		 4'b1000: sample_rate = clk_div[6];
		 4'b1001: sample_rate = clk_div[5];
		 4'b1010: sample_rate = clk_div[4];
		 4'b1011: sample_rate = clk_div[3];	

		 4'b1100: sample_rate = clk_div[2];
		 4'b1101: sample_rate = clk_div[1];
		 4'b1110: sample_rate = clk_div[0];
		 4'b1111: sample_rate = clk_in;			 

		default: sample_rate = clk_in;
		endcase

end

always @(posedge sample_rate) begin
		
				  case(key[1:0])
				  
					 2'b00: begin 				
								r_out[0] = 1'b0;
								r_out[1] = analog_in;
								r_out[2] = analog_in;

								g_out[0] = analog_in;
								g_out[1] = 1'b0;
								g_out[2] = analog_in;

								b_out[0] = analog_in;
								b_out[1] = analog_in;
								b_out[2] = 1'b0;
							  end 
					 2'b01: begin 				
								r_out[0] = analog_in;
								r_out[1] = analog_in;
								r_out[2] = 1'b0;

								g_out[0] = 1'b0;
								g_out[1] = analog_in;
								g_out[2] = analog_in;

								b_out[0] = 1'b0;
								b_out[1] = analog_in;
								b_out[2] = analog_in;
							  end 
					 2'b10: begin 				
								r_out[0] = analog_in;
								r_out[1] = 1'b0;
								r_out[2] = analog_in;

								g_out[0] = analog_in;
								g_out[1] = analog_in;
								g_out[2] = 1'b0;

								b_out[0] = 1'b0;
								b_out[1] = analog_in;
								b_out[2] = analog_in;
							  end 
					 2'b11:  begin 	

								r_out[0] = analog_in;
								r_out[1] = analog_in;
								r_out[2] = analog_in;

								g_out[0] = analog_in;
								g_out[1] = analog_in;
								g_out[2] = analog_in;

								b_out[0] = analog_in;
								b_out[1] = analog_in;
								b_out[2] = analog_in;
								

							  end 
		 

				default: begin 				
								r_out[0] = analog_in;
								r_out[1] = analog_in;
								r_out[2] = analog_in;

								g_out[0] = analog_in;
								g_out[1] = analog_in;
								g_out[2] = analog_in;

								b_out[0] = analog_in;
								b_out[1] = analog_in;
								b_out[2] = analog_in;
							  end 
				endcase
			
end

endmodule
