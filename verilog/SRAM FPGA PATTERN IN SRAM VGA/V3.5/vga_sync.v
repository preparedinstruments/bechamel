/*
   640x480 VGA singal generator
   ============================

Author : IÃ±igo Muguruza imuguruza 

https://github.com/imuguruza/alhambra_II_test/blob/master/vga/vga_test/vga_sync.v

  - Instantiates PLL for creating 25MHz clock
  - Creates h_sync,v_sync signals
  - Creates display enable signal and horizontal, vertical
    pixel position in display (h,v)
*/

`default_nettype none


module vga_sync(
      input  wire clk_in,
      input  wire reset,
      output reg  h_sync,
      output reg  v_sync,
      output wire clk_sys,
      output reg [10:0] h_count,
      output reg [9:0] v_count,
      output reg display_en,
      output wire locked
      );

wire locked;
wire sys_clk;

// Pixel counters
reg [10:0] h_counter = 0;
reg [9:0] v_counter = 0;

localparam  h_pixel_total = 1040;
localparam  h_pixel_display            = 800;
localparam  h_pixel_front_porch_amount = 56;
localparam  h_pixel_sync_amount        = 120;
 

localparam  v_pixel_total              = 666;
localparam  v_pixel_display            = 600;
localparam  v_pixel_front_porch_amount = 37;
localparam  v_pixel_sync_amount        = 6;
localparam  v_pixel_back_porch_amount  = 23;


always @(posedge clk_in) begin

  if (reset) begin
    //Reset counter values
    h_counter <= 0;
    v_counter <= 0;
    display_en <= 0;
  end
  else
    begin
    // Generate display enable signal
    if (h_counter < h_pixel_display && v_counter < v_pixel_display)
      display_en <= 1;
    else
      display_en <= 0;

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
end

always @(posedge clk_in) begin
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

// Route h_/v_counter to out
always @ (posedge clk_in) begin
  h_count <= h_counter;
  v_count <= v_counter;
end



endmodule
