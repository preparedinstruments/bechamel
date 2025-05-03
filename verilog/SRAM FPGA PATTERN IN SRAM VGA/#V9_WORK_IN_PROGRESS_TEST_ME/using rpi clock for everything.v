`default_nettype none // disable implicit definitions by Verilog


module top(
				input wire rpi_pixel_clock,
				input wire rec,  // the record button IS ACTIVE LOW !!
				input wire b_in, // input from rpi color
				input [7:0] key, //wire or reg ?
					
				output wire cs, 
				output wire oe, 
				output wire h_sync, 
				output wire v_sync, 
				
				output reg we, 
				output reg [17:0] addr, 
				output reg [2:0] r_out, 
				output reg [2:0] g_out, 
				output reg [2:0] b_out, 
								
				inout wire [7:0] io
);



//from vga_sync module 
input wire display_en;
input wire [11:0] h_count;
input wire [11:0] v_count;

//for SRAM inout
wire [7:0] data_in;
wire [7:0] data_out;
reg [7:0] a, b;

assign io = (rec==0) ? a : 8'bzzzzzzzz;

assign data_out = b;

assign cs = 0; 
assign oe = 0; 

assign data_in[7:0] = (b_in == 1'b1) ? 8'b11111111 : 8'b00000000; // input from rpi color


localparam  v_pixel_display = 600;
localparam  h_pixel_display = 800;



//SRAM address counter

always @(posedge rpi_pixel_clock) begin // 50MHz

		if (display_en) begin

			addr <= (((h_count)>>2)+(((v_count)>>2)*160)); // try 320 ?
				
			if(v_count >= v_pixel_display) begin
			
				addr <= 0;
				
			end					
		end			
end

//REC control

always @(posedge rpi_pixel_clock) begin // 50MHz
      b <= io;
      a <= data_in;
     if (rec==0 && display_en) begin
          we <= addr[0]; 
     end
     else begin
          we <= 1;
     end
end

// Color screen pixels

always @(rpi_pixel_clock) begin
			
	if (display_en) begin

		if ((rec==0) && (a==8'b11111111)) begin
		
					r_out <= 3'b010;
					g_out <= 3'b010;
					b_out <= 3'b111;
					
		end

		else if ((rec==0) && (a==8'b00000000)) begin
		
					r_out <= 3'b111;
					g_out <= 3'b011;
					b_out <= 3'b110;
					
		end

		else if ((rec==1) && (b==8'b11111111)) begin //data_out not b ??
		
					r_out <= 3'b011;
					g_out <= 3'b101;
					b_out <= 3'b111;
					
		end

		else begin
		
					r_out <= 3'b100;
					g_out <= 3'b001;
					b_out <= 3'b100;
					
		end	

	end
			
end


vga_sync vga_s(
      .clk_in(rpi_pixel_clock),         //50MHz
      .h_sync(h_sync),
      .v_sync(v_sync),
      .h_count(h_count),
      .v_count(v_count),
      .display_en(display_en) // '1' => pixel region
      );

endmodule