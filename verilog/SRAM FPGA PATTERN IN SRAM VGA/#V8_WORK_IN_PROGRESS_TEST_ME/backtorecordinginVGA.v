`default_nettype none // disable implicit definitions by Verilog


module top(
				input wire clk_in,
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

assign data_in[7:0] = (b_in_buffered == 1'b1) ? 8'b11111111 : 8'b00000000; // input from rpi color


localparam  v_pixel_display = 600;
localparam  h_pixel_display = 800;


wire b_in_temp;
wire b_in_buffered;

//double buffer rpi b_in input to avoid metastability

always @(posedge clk_in) begin

    b_in_temp 	  <= b_in;
	b_in_buffered <= b_in_temp;
	
end

//clock divider

reg [2:0] clk_div = 0;

always @(posedge clk_in) begin

     clk_div <= clk_div + 1;
	 
end


//SRAM address counter

always @(posedge clk_div[0]) begin // 50MHz

		if (display_en) begin

			addr <= (((h_count)>>2)+(((v_count)>>2)*160)); // try 320 ?
				
			if(v_count >= v_pixel_display) begin
			
				addr <= 0;
				
			end					
		end			
end

//REC control

always @(posedge clk_div[0]) begin // 50MHz
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

always @(clk_div[0]) begin
			
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
      .clk_in(clk_div[0]),         //50MHz
      .h_sync(h_sync),
      .v_sync(v_sync),
      .h_count(h_count),
      .v_count(v_count),
      .display_en(display_en) // '1' => pixel region
      );

endmodule