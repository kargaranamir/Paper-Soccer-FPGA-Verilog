`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:04:53 11/10/2017 
// Design Name: 
// Module Name:    Score 
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
module Score(
	input [7:0] old_x,
	input [7:0] old_y,
	input [7:0] new_x,
	input [7:0] new_y,
	input [7:0] data_out,//profile of new location
	input my_move,
	input color,
	input [7:0]length,
	input [7:0]width,
	input perm,
	output reg [7:0]score
    );
	 
	 localparam red=1;
	 localparam blue=0;
	 
	 
	 wire [8:0] y_diff1=new_y - old_y;
	 wire [8:0] y_diff2=old_y - new_y;
	 wire [8:0] y_diff=(color==red)? y_diff2:y_diff1;
	 wire signed [8:0] x_diff_old={1'b0,width/2} - {1'b0,old_x};
	 wire signed[8:0] x_diff_new={1'b0,width/2} - {1'b0,new_x};
	 
	 reg [7:0] y_score=0;
	 always @(*)
	 begin
		if(color == red)
		begin
			if(y_diff == 2)
			begin
				y_score=20;
			end
			else if (y_diff == 1)
			begin
				y_score=10;
			end
			else
			begin
				y_score=0;
			end
		end
		else if (color==blue)
		begin
			if(y_diff == 2)
			begin
				y_score=20;
			end
			else if (y_diff == 1)
			begin
				y_score=10;
			end
			else
			begin
				y_score=0;
			end
		end
	 end
	 
	 reg [7:0] x_score=0;
//	 always @ (*)
//	 begin
//		//if(my_move)
//		//begin
//			if(x_diff_old - x_diff_new ==2 )
//			begin
//				x_score=10;
//			end
//			else if(x_diff_old - x_diff_new ==1 )//////////////////////////////////////////////////
//			begin
//				x_score=5;
//			end
//			else
//			begin
//				x_score=0;
//			end
//		//end
//		//else 
//		//begin
//			//x_score=0;
//		//end
//	 end
	 
	 
	 reg [3:0] frd_score;
	 wire [3:0] line_number = data_out[0] + data_out[1] + data_out[2] + data_out[3] + data_out[4] + data_out[5] + data_out[6] + data_out[7];
	 
	 always @ (*)
	 begin
		//if(my_move)
		//begin
			case(line_number)
				4'd0:frd_score=0;
				4'd1:frd_score=6;
				4'd2:frd_score=5;
				4'd3:frd_score=4;
				4'd4:frd_score=3;
				4'd5:frd_score=2;
				4'd6:frd_score=1;
				4'd7:frd_score=0;
				default:frd_score=0;
			endcase
		//end
		//else begin frd_score=0; end
	 end
	 
	 always @ (*)
	 begin
		if(perm)begin	score = y_score + x_score + frd_score; end
		else begin if(my_move)begin	score =0;end else begin score=255; end end//////////////////////////////////////////
	 end


endmodule
