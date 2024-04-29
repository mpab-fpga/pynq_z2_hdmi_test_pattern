`timescale 1ns / 1ps

module top_HDMI #(COORDSPC = 16, // coordinate space (bits)
                  COLSPC = 10)
                 (input wire sysclk, // 125MHz
                  output logic [2:0] hdmi_tx_d_p,
                  output logic [2:0] hdmi_tx_d_n,
                  output logic hdmi_tx_clk_p,
                  output logic hdmi_tx_clk_n);
  logic video_clk_pix, video_clk_tmds,
  video_enable, vsync, hsync,
  frame_start, line_start;
  logic [COORDSPC-1:0] sx;
  logic [COORDSPC-1:0] sy;
  logic [COLSPC-1:0] red;
  logic [COLSPC-1:0] green;
  logic [COLSPC-1:0] blue;
  VIDEO_sig_gen sig_gen (.*);
  HDMI_encoder encoder (.*);
  VIDEO_source source (.*);
endmodule // top_HDMI
