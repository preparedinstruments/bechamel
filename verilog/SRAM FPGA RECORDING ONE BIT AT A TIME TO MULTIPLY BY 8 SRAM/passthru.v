module verilog(

      input wire  rec, 
      input wire  clk,
      input wire  rpi_h_sync,
      input wire  rpi_v_sync,
      input wire  rpi_color, 
      
	  output reg [17:0] addr,
      inout wire [7:0] io,
	  output wire cs,
	  output reg  we,
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

reg [7:0] data_in;
wire [7:0] data_out;

reg [4:0] temp;

always @ (temp) begin
    case(temp)
      4'b0000    : data_in[0] = rpi_color; 		
      4'b0001    : data_in[1] = rpi_color; 	
      4'b0010    : data_in[2] = rpi_color; 	
      4'b0011    : data_in[3] = rpi_color; 		
      4'b0100    : data_in[4] = rpi_color; 	
      4'b0101    : data_in[5] = rpi_color; 
      4'b0110    : data_in[6] = rpi_color; 		
      4'b0111    : data_in[7] = rpi_color; 		  
      default  : data_in[0] = rpi_color; 		
    endcase
end

reg [4:0] temp2;
reg c;

always @ (temp2) begin
    case(temp2)
      4'b0000    : c = data_out[0]; 		
      4'b0001    : c = data_out[1]; 	
      4'b0010    : c = data_out[2]; 	
      4'b0011    : c = data_out[3]; 		
      4'b0100    : c = data_out[4]; 	
      4'b0101    : c = data_out[5]; 
      4'b0110    : c = data_out[6]; 		
      4'b0111    : c = data_out[7]; 		  
      default  : c = data_out[0]; 		
    endcase
end

reg [7:0] a, b;



assign io = (rec==0) ? a : 8'bzzzzzzzz;

assign data_out = b;
        
reg [3:0] counter = 0; //our clock divider

//clk div
always @(posedge clk) begin

  counter <= counter + 1;
  
end 


//SRAM 
always @(posedge counter[1]) begin

      b <= io;
      a <= data_in;
	  temp<=temp + 1;
	  temp2<=temp2 + 1;
	  
		if(rpi_v_sync) begin // reset the SRAM each time we draw a new frame	
			addr <= 0;		
		end 	  
		 		
		if (temp==4'b0111) begin
			if (rec==0) begin
				we <= addr[0]; 
			end
			else if (rec==1) begin
				we <= 1;
			end
		end
		if (temp==4'b1000) begin
			addr <= addr+1;
			temp<=4'b0000;
			temp2<=4'b0000;
		end
        
end

always @(posedge counter[1]) begin

		if ((rec==0) && (rpi_color==1'b1))
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

		else if ((rec==0) && (rpi_color==1'b0))
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

		else if ((rec==1) && (c==1'b1)) //data_out not b ??
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