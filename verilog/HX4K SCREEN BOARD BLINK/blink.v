`default_nettype none

module top(
input wire clk,
output wire LED
);


reg[23:0] counter;

assign LED = counter[23];

always@(posedge clk)
begin

counter <= counter + 1;

end

endmodule