// vga_sync_test verilog code 

`default_nettype none

module vga_sync_test(

input wire clk_in,
input wire reset,

input wire rec, // Direction of io, 1 = set output, 0 = read input

//RASPBERRY PI
input wire [3:0] r_in,
input wire [3:0] b_in,
input wire [3:0] g_in,

//VGA OUT
output reg [3:0] r_out,
output reg [3:0] b_out,
output reg [3:0] g_out,

output wire h_sync,
output wire v_sync,

//SRAM

output reg [20:0] addr,
inout wire [7:0] io, // inout must be type wire

output wire cs_1,
output wire cs_0,

output reg we_1,
output reg we_0

);

wire [7:0] data_in;
wire [7:0] data_out;

reg toggle;

reg [7:0] a, b;

assign io = rec ? a : 8'bzzzzzzzz;

assign data_out = b;

assign data_in[1:0] = r_in[3:2];
assign data_in[3:2] = b_in[3:2];
assign data_in[5:4] = g_in[3:2];
assign data_in[7:6] = 2'b00;


wire display_en;
wire [11:0] h_count;
wire [11:0] v_count;

localparam h_pixel_max = 1280;
localparam v_pixel_max = 960;
localparam h_pixel_half = 640;
localparam v_pixel_half = 480;

// CS: low to select, high to deselect

assign cs_0 = toggle ? 1 : 0;
assign cs_1 = toggle ? 0 : 1;

//SRAM address counter

always @(posedge clk_in) begin

if (addr == 0) begin
toggle <= toggle+1;
end

if (reset) begin
addr <= 0;
end else begin
addr <= addr+1;
end
end

//REC control

always @(posedge clk_in) begin

b <= io;
a <= data_in;
if (rec) begin
we_0 <= addr[0]; //not sure why it isn't the inverse of addr[0] but that doesn't make the inverse on 'scope
end
else begin
we_0 <= 1;
end
end

//VGA COLOR OUT

always @(posedge clk_in) begin
if (display_en) begin

r_out[3:2] <= data_out[1:0];
r_out[1:0] <= data_out[1:0];
g_out[3:2] <= data_out[3:2];
g_out[1:0] <= data_out[3:2];
b_out[3:2] <= data_out[5:4];
b_out[1:0] <= data_out[5:4];

end else begin
r_out <= 4'b0000;
g_out <= 4'b0000;
b_out <= 4'b0000;
end
end

vga_sync vga_s(
.clk_in(clk_in),
.reset(reset),
.h_sync(h_sync),
.v_sync(v_sync),
.h_count(h_count),
.v_count(v_count),
.display_en(display_en) // '1' => pixel region
);

endmodule