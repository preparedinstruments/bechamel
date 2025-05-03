module verilog(

      input wire rec, 
      input wire  clk,
      input wire  rpi_h_sync,
      input wire  rpi_v_sync,
      input wire  rpi_color, 
       input wire  [1:0]key,      

	  	output reg [17:0] addr,
       inout wire [7:0] io,
		output wire cs,
		output reg we,
		output wire oe,

      output wire  h_sync,
      output wire  v_sync,
      output reg  [3:0] r_out, 
      output reg  [3:0] g_out,
      output reg  [3:0] b_out
      );

assign cs = 0; 
assign oe = 0; 

assign h_sync = rpi_h_sync;

assign v_sync = rpi_v_sync;



wire [7:0] data_in;
wire [7:0] data_out;

assign data_in[7:0] = (rpi_color == 1'b1) ? 8'b11111111 : 8'b00000000; // color from rpi

reg [7:0] a, b;

assign io = (rec==0) ? a : 8'bzzzzzzzz;

assign data_out = b;
        
reg [3:0] counter = 0; //our clock divider

reg div_sel;

  always @ (key) begin
    case(key)
      2'b00    : div_sel = counter[0]; 		// If sel=0, output is a
      2'b01    : div_sel = counter[1]; 		// If sel=1, output is b
      2'b10    : div_sel = counter[2]; 		// If sel=2, output is c
	  2'b11    : div_sel = counter[3]; 		// If sel=2, output is c
      default  : div_sel = counter[0]; 		// If sel is anything else, out is always 0
    endcase
  end

//SRAM address counter
always @(posedge clk) begin

  counter <= counter + 1;

  if (div_sel) begin

    	if(rpi_v_sync) begin // reset the SRAM each time we draw a new frame
			addr <= 0;
    	end

		else begin
    		addr <= addr+1;
		end
  end
end 

always @(posedge div_sel) begin
      b <= io;
      a <= data_in;
     if (rec==0) begin
          we <= addr[0]; //not sure why it isn't the inverse of addr[0] but that doesn't make the inverse on 'scope
     end
     else begin
          we <= 1;
     end
end

always @(posedge div_sel) begin


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
				r_out[2] <= 1'b0;

				b_out[0] <= 1'b1;
				b_out[1] <= 1'b1;
				b_out[2] <= 1'b0;

				g_out[0] <= 1'b1;
				g_out[1] <= 1'b1;
				g_out[2] <= 1'b0;
			end

		else if ((rec==1) && (b==8'b11111111)) //data_out not b ??
		begin
				r_out[0] <= 1'b1;
				r_out[1] <= 1'b0;
				r_out[2] <= 1'b1;

				b_out[0] <= 1'b1;
				b_out[1] <= 1'b0;
				b_out[2] <= 1'b1;

				g_out[0] <= 1'b1;
				g_out[1] <= 1'b0;
				g_out[2] <= 1'b1;
		end
		else
		begin
				r_out[0] <= 1'b1;
				r_out[1] <= 1'b0;
				r_out[2] <= 1'b0;

				b_out[0] <= 1'b1;
				b_out[1] <= 1'b0;
				b_out[2] <= 1'b0;

				g_out[0] <= 1'b1;
				g_out[1] <= 1'b0;
				g_out[2] <= 1'b0;
		end	
end


endmodule