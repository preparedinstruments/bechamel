`default_nettype none // disable implicit definitions by Verilog

module top(
clk_in, reset, r_out, g_out, b_out, h_sync, v_sync, rpi_DEN,  b_in , rpi_pixel_clock
);

input wire b_in,
input wire rpi_pixel_clock,
input wire rpi_DEN,

output wire h_sync,
output wire v_sync,

wire [10:0] h_count;
wire [9:0] v_count;

output reg [2:0] r_out;
output reg [2:0] b_out;
output reg [2:0] g_out;

input clk_in;

input reset;

input wire display_en;


reg [11:0] rpi_hc;


reg [0:89] heart;

reg pixel;

reg [2:0] clk_div = 0;

always @(posedge clk_in)
begin
     clk_div <= clk_div + 1;
end

always @(posedge rpi_pixel_clock) begin

if(rpi_DEN && trig_record)begin
      rpi_hc <= rpi_hc+1; // count horizontal pixels while DEN
      heart[(rpi_hc>>2)]<=b_in; // put color data in a 90 bit long register (using posedge rpi pixel clock already divides once)
end
else begin
rpi_hc <= 0;
end
end


reg trig_record;

always @(posedge clk_in) begin

	if(v_count[3:0] == 4'b1111) begin

		trig_record <= 1;

	end
	else begin
		trig_record <= 0;
	end
end

always @(*) begin
			

	
	 
		
		if(display_en) begin
		
			pixel = heart[(h_count>>2)]; // read a portion of the 90 bit long register
			
			if (pixel == 1'b1)
			begin
						r_out = 3'b000;
						g_out = 3'b000;
						b_out = 3'b111;
			end

			else
			begin
						r_out = 3'b000;
						g_out = 3'b111;
						b_out = 3'b000;
			end	

		end
			
end


vga_sync vga_s(
      .clk_in(clk_div[0]),         //50MHz
      .h_sync(h_sync),
      .v_sync(v_sync),
      .h_count(h_count),
      .v_count(v_count),
      .display_en(display_en) // '1' => pixel region
      );


endmodule