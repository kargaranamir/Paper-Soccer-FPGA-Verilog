`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:38:37 11/16/2017 
// Design Name: 
// Module Name:    fifo2transmit 
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
module fifo2transmit(
	input clk,
	input rst,
	input buf_empty,
	output rd_en,
	input [7:0]buf_out,
	
	input TxD_busy,
	output TxD_start,
	output [7:0] TxD_data
    );
	 
	 localparam S1=0;
	 localparam S2=1;
	 localparam S3=2;
	 reg [1:0] state=S1;
	 assign TxD_data = buf_out;
	
	always @(posedge clk)
	begin
		if(rst)begin state<=S1; end
		else
		begin
			case(state)
			S1:
			begin
				if(!buf_empty && !TxD_busy)begin state<=S2; end
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
	end
	
	assign rd_en = (state == S2);
	assign TxD_start = (state == S3);

endmodule
