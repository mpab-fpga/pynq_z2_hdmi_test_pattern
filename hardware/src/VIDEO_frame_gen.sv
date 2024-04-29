`timescale 1ns / 1ps

// pattern taken from here
// https:// www.fpga4fun.com/HDMI.html
// https:// www.youtube.com/watch?v = sMOZxOCfkBU
// https:// github.com/dominic-meads/HDMI_FPGA/tree/master/HDMI_FPGA4fun

module VIDEO_frame_gen #(COORDSPC = 16, // coordinate space (bits)
                         COLSPC = 10)
                        (input wire video_clk_pix,
                         input wire video_enable,
                         input wire vsync,
                         input wire hsync,
                         input wire frame_start,
                         input wire line_start,
                         input wire signed [COORDSPC-1:0] sx,
                         input wire signed [COORDSPC-1:0] sy,
                         output logic [COLSPC-1:0] red,
                         output logic [COLSPC-1:0] green,
                         output logic [COLSPC-1:0] blue);
  wire [COLSPC-1:0] SX = sx[COLSPC-1:0];
  wire [COLSPC-1:0] SY = sy[COLSPC-1:0];
  wire [COLSPC-1:0] W  = {COLSPC{SX[7:0] == SY[7:0]}};
  wire [COLSPC-1:0] A  = {COLSPC{SX[7:5] == 3'h2 && SY[7:5] == 3'h2}};
  
  always_ff @(posedge video_clk_pix) begin
    red <= ({SX[5:0] & {6{SY[4:3] == ~SX[4:3]}}, 4'b0} | W) & ~A;
    green <= (SX & {COLSPC{SY[6]}} | W) & ~A;
    blue  <= SY | W | A;
  end
endmodule
