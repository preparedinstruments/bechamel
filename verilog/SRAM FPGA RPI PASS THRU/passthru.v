
module verilog(

output reg h_sync,
output reg v_sync,

      input wire rec, 
      input wire  clk,
      input wire  rpi_color, 
      
	  	output reg [17:0] addr,
       inout wire [7:0] io,
		output wire cs,
		output reg we,
		output wire oe,

      output reg  [3:0] r_out, 
      output reg  [3:0] g_out,
      output reg  [3:0] b_out
      );

// Pixel counters
reg [11:0] h_counter = 0;
reg [11:0] v_counter = 0;


localparam h_pixel_total = 1040;
localparam h_pixel_display = 800;
localparam h_pixel_front_porch_amount = 56;
localparam h_pixel_sync_amount = 120;
localparam h_pixel_back_porch_amount = 64;

localparam v_pixel_total = 666;
localparam v_pixel_display = 600;
localparam v_pixel_front_porch_amount = 37;
localparam v_pixel_sync_amount = 6;
localparam v_pixel_back_porch_amount = 23;

always @(posedge clk) begin

	//Check if horizontal has arrived to the end
	if (h_counter >= h_pixel_total)
		begin
		h_counter <= 0;
		v_counter <= v_counter + 1;
		end
	else
	//horizontal increment pixel value
		h_counter <= h_counter + 1;
	// check if vertical has arrived to the end
	if (v_counter >= v_pixel_total)
		v_counter <= 0;
	
end

always @(posedge clk) begin
// Check if sync_pulse needs to be created
if (h_counter >= (h_pixel_display + h_pixel_front_porch_amount)
&& h_counter < (h_pixel_display + h_pixel_front_porch_amount + h_pixel_sync_amount) )
h_sync <= 0;
else
h_sync <= 1;
// Check if sync_pulse needs to be created
if (v_counter >= (v_pixel_display + v_pixel_front_porch_amount)
&& v_counter < (v_pixel_display + v_pixel_front_porch_amount + v_pixel_sync_amount) )
v_sync <= 0;
else
v_sync <= 1;
end

assign cs = 0; 
assign oe = 0; 


wire [7:0] data_in;
wire [7:0] data_out;

assign data_in[7:0] = (rpi_color == 1'b1) ? 8'b11111111 : 8'b00000000; // color from rpi

reg [7:0] a, b;

assign io = (rec==0) ? a : 8'bzzzzzzzz;

assign data_out = b;
        
reg [3:0] counter = 0; //our clock divider

//SRAM address counter
always @(posedge clk) begin

  counter <= counter + 1;

  if (counter[1]) begin

    	if(v_sync) begin // reset the SRAM each time we draw a new frame
			addr <= 0;
    	end

		else begin
    		addr <= addr+1;
		end
  end
end 

always @(posedge counter[1]) begin
      b <= io;
      a <= data_in;
     if (rec==0) begin
          we <= addr[0]; //not sure why it isn't the inverse of addr[0] but that doesn't make the inverse on 'scope
     end
     else begin
          we <= 1;
     end
end

always @(posedge counter[1]) begin


		if ((rec==0) && (a==8'b11111111))
			begin
				r_out[0] <= 1'b0;
				r_out[1] <= 1'b0;
				r_out[2] <= 1'b0;

				b_out[0] <= 1'b0;
				b_out[1] <= 1'b0;
				b_out[2] <= 1'b0;

				g_out[0] <= 1'b0;
				g_out[1] <= 1'b0;
				g_out[2] <= 1'b0;
			end

		else if ((rec==0) && (a==8'b00000000))
			begin
				r_out[0] <= 1'b1;
				r_out[1] <= 1'b1;
				r_out[2] <= 1'b1;

				b_out[0] <= 1'b1;
				b_out[1] <= 1'b1;
				b_out[2] <= 1'b1;

				g_out[0] <= 1'b1;
				g_out[1] <= 1'b1;
				g_out[2] <= 1'b1;
			end

		else if ((rec==1) && (b==8'b11111111)) //data_out not b ??
		begin
				r_out[0] <= 1'b1;
				r_out[1] <= 1'b1;
				r_out[2] <= 1'b1;

				b_out[0] <= 1'b1;
				b_out[1] <= 1'b1;
				b_out[2] <= 1'b1;

				g_out[0] <= 1'b1;
				g_out[1] <= 1'b1;
				g_out[2] <= 1'b1;
		end
		else
		begin
				r_out[0] <= 1'b0;
				r_out[1] <= 1'b0;
				r_out[2] <= 1'b0;

				b_out[0] <= 1'b0;
				b_out[1] <= 1'b0;
				b_out[2] <= 1'b0;

				g_out[0] <= 1'b0;
				g_out[1] <= 1'b0;
				g_out[2] <= 1'b0;
		end	
end


endmodule