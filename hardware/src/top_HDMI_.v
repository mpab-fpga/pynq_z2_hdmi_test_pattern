`timescale 1ns / 1ps

module top_HDMI_ #(
) (
  input wire sysclk,  // 125MHz
  output wire [2:0] hdmi_tx_d_p,
  output wire [2:0] hdmi_tx_d_n,
  output wire hdmi_tx_clk_p,
  output wire hdmi_tx_clk_n
);
  top_HDMI hdmi (
    .sysclk(sysclk),
    .hdmi_tx_d_p(hdmi_tx_d_p),
    .hdmi_tx_d_n(hdmi_tx_d_n),
    .hdmi_tx_clk_p(hdmi_tx_clk_p),
    .hdmi_tx_clk_n(hdmi_tx_clk_n)
  );
endmodule  // top_HDMI
