`timescale 1ns / 1ps

module VIDEO_source #(
  COORDSPC = 16,  // coordinate space (bits)
  COLSPC   = 10   // color space (bits)
) (
  input wire video_clk_pix,
  input wire video_enable,
  input wire vsync,
  input wire hsync,
  input wire frame_start,
  input wire line_start,
  input wire signed [COORDSPC-1:0] sx,
  input wire signed [COORDSPC-1:0] sy,
  output logic [COLSPC-1:0] red,
  output logic [COLSPC-1:0] green,
  output logic [COLSPC-1:0] blue
);
  // TODO: extend VIDEO_frame_gen
  logic [COLSPC-1:0] _red, _green, _blue;
  VIDEO_frame_gen #(
  ) fg (
    .red  (_red),
    .green(_green),
    .blue (_blue),
    .*
  );

  always_ff @(posedge video_clk_pix) begin
    red   <= _red;
    green <= _green;
    blue  <= _blue;
  end
endmodule
