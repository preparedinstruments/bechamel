`default_nettype none

module vga_sync_test(

			input wire clk_in,

			output reg [2:0] clk_div, // remember to change clk_div[MSB] also below ! Changing the size of this register changes how big the pixels are :D !

			input wire reset,
			
			input wire rec, // Direction of io, 1 = set output, 0 = read input

			//RASPBERRY PI
			input wire b_in,
			input wire rpi_DEN,
			
			output reg [1:0] V_SYNC_COUNT,


			//VGA OUT
			output reg [3:0] r_out,
			output reg [3:0] b_out,
			output reg [3:0] g_out,

			output wire h_sync,
			output wire v_sync,

			//SRAM
			output reg [17:0] addr,
			inout wire [7:0] io, // inout must be type wire

			output wire cs,
			output reg we,
			output wire oe

);

	wire [7:0] data_in;
	wire [7:0] data_out;

	reg [7:0] a, b;

	assign io = (rec==0) ? a : 8'bzzzzzzzz;

	assign data_out = b;

	assign data_in[0] = rpi_DEN ? b_in : 0;
	assign data_in[1] = rpi_DEN ? b_in : 0;
	assign data_in[2] = rpi_DEN ? b_in : 0;
	assign data_in[3] = rpi_DEN ? b_in : 0;
	assign data_in[4] = rpi_DEN ? b_in : 0;
	assign data_in[5] = rpi_DEN ? b_in : 0;
	assign data_in[7:6] = 2'b00;

	wire display_en;
	wire [11:0] h_count;
	wire [11:0] v_count;

	assign cs = 1'b0;
	assign oe = 1'b0;

//V SYNC counter

	always @(posedge rpi_DEN) begin
		V_SYNC_COUNT <= V_SYNC_COUNT+1;
			if(reset == 1) begin
				V_SYNC_COUNT <=0;
			end
	end

//increment our clock divider

	always @(posedge clk_in) begin
		clk_div <= clk_div+1;
			if(reset == 1) begin
				clk_div <=0;
			end
	end

	always@(posedge clk_div[0]) begin

	// reset the address once we've rolled over V_SYNC_COUNT
		if (V_SYNC_COUNT == 0 ) begin
			addr <= 0;
		end 
		else begin
			//only increment address if DEN high
			if (rpi_DEN) begin
				addr <= addr+1;
			end
		end
	end

	//REC control

	always @(posedge clk_div[0]) begin

		b <= io;
		a <= data_in;
		
		if (rec==0) begin
			//only enable WR if DEN high
			if (rpi_DEN) begin
				we <= addr[0]; //not sure why it isn't the inverse of addr[0] but that doesn't make the inverse on 'scope
			end
		end
		else begin
			we <= 1;
		end
	end

	//VGA COLOR OUT

	always @(posedge clk_div[0]) begin
		

		//only display pixels if DEN high
		if (rpi_DEN) begin
			if ((rec==0) && (a==8'b11111111)) begin
				r_out[3:2] <= data_out[1:0];
				r_out[1:0] <= data_out[1:0];
				g_out[3:2] <= data_out[3:2];
				g_out[1:0] <= data_out[3:2];
				b_out[3:2] <= data_out[5:4];
				b_out[1:0] <= data_out[5:4];
			end
			else if ((rec==0) && (a==8'b00000000)) begin
			
			    r_out[3:0] <= 4'b0110;
				g_out[3:0] <= 4'b0011;
				b_out[3:0] <= 4'b1100;
			end
			else if ((rec==1) && (b==8'b11111111)) begin
			    
				r_out[3:0] <= 4'b1110;
				g_out[3:0] <= 4'b0010;
				b_out[3:0] <= 4'b0101;
			end
			else begin
				r_out[3:0] <= 4'b0011;
				g_out[3:0] <= 4'b0110;
				b_out[3:0] <= 4'b0011;
			end	
		end
			
		else begin
			r_out <= 4'b0000;
			g_out <= 4'b0000;
			b_out <= 4'b0000;
		end
	end

vga_sync vga_s(
.clk_in(clk_div[0]), // 50MHz
.reset(reset),
.h_sync(h_sync),
.v_sync(v_sync),
.h_count(h_count),
.v_count(v_count),
.display_en(display_en) // '1' => pixel region
);

endmodule
