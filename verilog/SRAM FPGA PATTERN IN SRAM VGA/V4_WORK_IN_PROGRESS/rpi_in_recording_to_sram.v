`default_nettype none // disable implicit definitions by Verilog

module top(
clk_in, rec, addr, io, cs, we, oe, key, reset, r_out, g_out, b_out, h_sync, v_sync, rpi_DEN, rpi_hsync, rpi_vsync, b_in , rpi_pixel_clock
);

input wire b_in,
input wire rpi_pixel_clock,
input wire rpi_DEN,
input wire rpi_hsync,
input wire rpi_vsync,

output wire h_sync,
output wire v_sync,

output reg [2:0] r_out;
output reg [2:0] b_out;
output reg [2:0] g_out;

input wire rec; // the record button IS ACTIVE LOW !!
input clk_in;

input reset;

input [7:0] key;

output reg [17:0] addr;
inout wire [7:0] io; // inout must be type wire

output wire cs;
output reg we;
output wire oe;

input wire display_en;

input wire [11:0] h_count;
input wire [11:0] v_count;

wire [7:0] data_in;
wire [7:0] data_out;

reg [7:0] a, b;

assign io = (rec==0) ? a : 8'bzzzzzzzz;

assign data_out = b;

assign cs = 0; //change this
assign oe = 0; //change this

reg [2:0] clk_div = 0;

always @(posedge rpi_pixel_clock)
begin
     clk_div <= clk_div + 1;
end


assign data_in[7:0] = (b_in == 1'b0) ? 8'b11111111 : 8'b00000000 ; // output from FPGA


assign h_sync = rpi_hsync;
assign v_sync = rpi_vsync;


//SRAM address counter

always @(posedge clk_div[0]) begin // 25MHz

		if (rpi_DEN) begin
	
        	addr <= addr + 1;

		end
		
		if(rpi_vsync==0) begin
			
				addr <= 0;
				
		end
						
end

//REC control

always @(posedge clk_div[0]) begin // 25MHz
      b <= io;
      a <= data_in;
     if (rec==0 && rpi_DEN) begin
          we <= addr[0]; //not sure why it isn't the inverse of addr[0] but that doesn't make the inverse on 'scope
     end
     else begin
          we <= 1;
     end
end

always @(clk_div[0]) begin
			
	if (rpi_DEN) begin

		if ((rec==0) && (a==8'b11111111))
		begin
					r_out <= 3'b000;
					g_out <= 3'b000;
					b_out <= 3'b111;
		end

		else if ((rec==0) && (a==8'b00000000))
		begin
					r_out <= 3'b111;
					g_out <= 3'b000;
					b_out <= 3'b000;
		end

		else if ((rec==1) && (b==8'b11111111)) //data_out not b ??
		begin
					r_out <= 3'b000;
					g_out <= 3'b111;
					b_out <= 3'b000;
		end

		else
		begin
					r_out <= 3'b101;
					g_out <= 3'b101;
					b_out <= 3'b101;
		end	

	end
			
end

/*
vga_sync vga_s(
      .clk_in(clk_div[0]),         //50MHz
      .h_sync(h_sync),
      .v_sync(v_sync),
      .h_count(h_count),
      .v_count(v_count),
      .display_en(display_en) // '1' => pixel region
      );

*/
endmodule