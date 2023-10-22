`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2023 00:58:01
// Design Name: 
// Module Name: HDMI_frame
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// called by HDMI_generator
// draws a frame

module HDMI_frame(
    input pixclk,
	input [9:0] CounterX,
	input [9:0] CounterY,
	output reg [9:0] red = 0,
	output reg [9:0] green = 0,
	output reg [9:0] blue = 0
    );
    
    wire [7:0] W = {8{CounterX[7:0]==CounterY[7:0]}};                     
    wire [7:0] A = {8{CounterX[7:5]==3'h2 && CounterY[7:5]==3'h2}};
    
    always @(posedge pixclk) begin
        red <= ({CounterX[5:0] & {6{CounterY[4:3]==~CounterX[4:3]}}, 2'b00} | W) & ~A;
        green <= (CounterX[7:0] & {8{CounterY[6]}} | W) & ~A;
        blue <= CounterY[7:0] | W | A;
    end
endmodule
