`default_nettype none // disable implicit definitions by Verilog

module top(
clk_in, rec, addr, io, cs, we, oe, key, reset, r_out, g_out, b_out, h_sync, v_sync
);

wire display_en;

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
//reg [9:0] h_count;
input wire [11:0] h_count;
//reg [9:0] v_count;
input wire [11:0] v_count;

localparam h_pixel_max = 800; 
localparam v_pixel_max = 600; 
localparam h_pixel_half = 400; 
localparam v_pixel_half = 300;

wire [7:0] data_in;
wire [7:0] data_out;

reg [7:0] a, b;

assign io = (rec==0) ? a : 8'bzzzzzzzz;

assign data_out = b;

// for our bittiness
reg [11:0] again_xnor;

assign cs = 0; //change this
assign oe = 0; //change this


// to store values from other modules
wire half_sec;

wire [12:0] random_number_0;
wire [12:0] random_number_1;
wire [12:0] random_number_2;
wire [12:0] random_number_3;
wire [12:0] random_number_4;
wire [12:0] random_number_5;
wire [12:0] random_number_6;
wire [12:0] random_number_7;
wire [12:0] random_number_8;
wire [12:0] random_number_9;
wire [7:0] sine_wave;

// for a 25MHz clock we divide 100MHz by 4
reg [1:0] clk_div = 0;

always @(posedge clk_in)
begin
     clk_div <= clk_div + 1;
end



assign data_in[7:0] = (h_count[7:0] >= key[7:0]) ? 8'b11111111 : 8'b00000000; // output from FPGA

always @(*) begin

again_xnor[9:0] = (h_count[9:0]^~v_count[9:0]);

end

localparam  h_pixel_total = 1040;
localparam  h_pixel_display            = 800;
localparam  h_pixel_front_porch_amount = 56;
localparam  h_pixel_sync_amount        = 120;
 

localparam  v_pixel_total              = 666;
localparam  v_pixel_display            = 600;
localparam  v_pixel_front_porch_amount = 37;
localparam  v_pixel_sync_amount        = 6;
localparam  v_pixel_back_porch_amount  = 23;



//SRAM address counter

always @(posedge clk_div[1]) begin

		if (display_en) begin
			if( addr < 17'b11111111111111111 && h_count > h_pixel_front_porch_amount && v_count > v_pixel_front_porch_amount && h_count < h_pixel_display  && v_count < v_pixel_display && h_count[0]==1 && v_count[0]==1) begin // basically divide the counters because there are 480K pixels but I have 256K SRAM, and only count the active pixel area
        		addr <= addr+1;
			end
			else begin
			addr <= 0; // I want to restart the counter at the end of each screen draw ?
			end
		end
    end

//REC control


always @(posedge clk_div[1]) begin
      b <= io;
      a <= data_in;
     if (rec==0) begin
          we <= addr[0]; //not sure why it isn't the inverse of addr[0] but that doesn't make the inverse on 'scope
     end
     else begin
          we <= 1;
     end
end

always @(posedge clk_in) begin
			
	if (display_en) begin

		if ((rec==0) && (a==8'b11111111))
		begin
					r_out <= 3'b010;
					g_out <= 3'b010;
					b_out <= 3'b111;
		end
		// display black bar
		else if ((rec==0) && (a==8'b00000000))
		begin
					r_out <= 3'b111;
					g_out <= 3'b011;
					b_out <= 3'b110;
		end

		else if ((rec==1) && (b==8'b11111111)) //data_out not b ??
		begin
					r_out <= 3'b011;
					g_out <= 3'b101;
					b_out <= 3'b111;
		end
		// display black bar
		else
		begin
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