`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:04:31 11/16/2017 
// Design Name: 
// Module Name:    timer 
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
module timer(
	input clk,
	input start,
	input timer_rst,
	output time_expire
    );
	 
	 reg [31:0] counter=0;
	 reg [1:0] state=0;
	 
	 localparam N=23_995_000;
	 
	 localparam idle=0;
	 localparam counter_s=1;
	 localparam time_expire_s=2;
	 
	 always @ (posedge clk)
	 begin
		if(timer_rst)begin state<=idle; end
		else
		begin
			case(state)
			idle:begin if(start) state<=counter_s; end
			counter_s:begin if(timer_rst)begin state<=idle;end if(counter==N)begin state<=time_expire_s; end end
			time_expire_s:begin if(timer_rst)begin state<=idle; end end
			endcase
		end
	 end
	 
	 always @ (posedge clk)
	 begin
		if(timer_rst)begin counter<=0; end
		else
		begin
			if(state==idle)begin counter<=0; end
			if(state == counter_s)begin counter<=counter+1; end
		end
	 end
	 
	 assign time_expire = (state == time_expire_s);
	 


endmodule
