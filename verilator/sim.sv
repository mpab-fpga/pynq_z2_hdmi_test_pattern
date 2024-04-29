`timescale 1ns / 1ps

module sim #(
    HRES = 640,
    VRES = 480,
    COORDSPC = 16,  // coordinate space (bits)
    COLSPC = 10  // color space (bits)
) (
    input logic video_clk_pix,
    output logic video_enable,
    output logic vsync,
    output logic hsync,
    output logic frame_start,
    output logic line_start,
    output logic signed [COORDSPC-1:0] sx,
    output logic signed [COORDSPC-1:0] sy,
    output logic [COLSPC-1:0] red,
    output logic [COLSPC-1:0] green,
    output logic [COLSPC-1:0] blue
);
  VIDEO_sync sync(.*);
  VIDEO_source source (.*);
endmodule
