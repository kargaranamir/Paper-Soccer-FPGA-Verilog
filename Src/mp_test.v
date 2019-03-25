`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:39:23 11/16/2017 
// Design Name: 
// Module Name:    mp_test 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mp_test(
	input clk,
	input my_turn,
	input [7:0] current_x_in,
	input [7:0] current_y_in,
	input [7:0] width_in,
	input [7:0] length_in,
	input color_in,
	output idle,
	output [2:0] direction,
	output direction_valid,
	//mem_reader
	input [7:0] data_in,
//	input data_valid,
//	output enable,
	output [15:0] address,
	output my_move
    );
	 
	  localparam S1=0;
	 localparam S2=1;
	 localparam S3=2;
	 
	 reg [1:0] state=S1;
	 always @(posedge clk)
	begin
			case(state)
			S1:
			begin
				if(my_turn)begin state<=S2; end
			end
			S2:
			begin
				state<=S3;
			end
			S3:
			begin
				state<=S1;
			end
			endcase
	
	end
	
	assign direction_valid = (state == S3);
	assign direction = 3'd0;
	assign idle = (state == S1);


endmodule
