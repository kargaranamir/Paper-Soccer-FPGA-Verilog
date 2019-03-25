`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:04:17 11/15/2017 
// Design Name: 
// Module Name:    memory_handler 
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
module memory_handler(
input clk,
input rst,
input [2:0] direction_in,
input direction_valid,
input [7:0] width_in,
input width_valid,
input [7:0] length_in,
input length_valid,
output update_done,
output [15:0] address,
output reg [7:0] data_out,
input [7:0] data_in,
output reg [7:0] current_x=0,
output reg [7:0] current_y=0,
output reg we=0
    );
	 
	 reg [3:0] state=0;
localparam get_width=0;
localparam get_length=1;
localparam get_direction=2;
localparam point_computation=3;
localparam memory_read=4;
localparam memory_write=5;
localparam update_done_s=6;

reg [7:0] width=0;
reg [7:0] length=0;
reg [2:0] direction=0;
reg second_point=0;
//
always @(posedge clk)
begin
	if(rst)
	begin
		state<=get_width;
		length<=0;
		width<=0;
		direction<=0;
	end
	else
	begin
		if(state == get_width)
		begin
			if(width_valid)
			begin
				width<=width_in;
				state<=get_length;
			end
		end
	
		if(state == get_length)
		begin
			if(length_valid)
			begin
				length<=length_in;
				state<=get_direction;
			end
		end

		if(state == get_direction)
		begin
			if(direction_valid)
			begin
				direction<=direction_in;
				state<=memory_read;	
			end	
		end

		if(state == memory_read)
		begin
			state<=memory_write;
		end

		if(state == memory_write)
		begin	
			if(second_point)begin state<=update_done_s; end
			else begin state<=point_computation;  end
		end

		if(state ==point_computation)
		begin
			state<=memory_read;
		end

		if(state == update_done_s)
		begin
			state<=get_direction;
		end
	end
end
//
always @(posedge clk)
begin
	if(rst)
	begin
		
		current_x<=0;
		current_y<=0;
	end
	else
	begin
		if(state == get_width)
		begin
			if(width_valid)
			begin
				current_x<=width_in/2;
			end
		end
		if(state == get_length)
		begin
			if(length_valid)
			begin
				current_y<=length_in/2;
			end
		end
		if(state ==point_computation)
		begin
			if(direction == 0)
			begin
				current_y<=current_y+1;
			end
			if(direction == 1)
			begin
				current_y<=current_y+1;
				current_x<=current_x+1;
			end
			if(direction == 2)
			begin
				current_x<=current_x+1;
			end
			if(direction == 3)
			begin
				current_x<=current_x+1;
				current_y<=current_y-1;
			end
			if(direction == 4)
			begin
				current_y<=current_y-1;
			end
			if(direction == 5)
			begin
				current_x<=current_x-1;
				current_y<=current_y-1;
			end
			if(direction == 6)
			begin
				current_x<=current_x-1;
			end
			if(direction == 7)
			begin
				current_x<=current_x-1;
				current_y<=current_y+1;
			end
		end
	end
end
//
//assign address={current_y,current_x};*****************************************************
assign address = current_x+(width+1)*current_y;

always @(posedge clk)
begin	
	if(rst)begin second_point<=0; end
	else
	begin
		if(state == point_computation)begin second_point<=1; end
		if(state == memory_write && second_point == 1)begin second_point<=0; end
	end
end

always @(posedge clk)
begin
	if(rst)begin we<=0;end
	else
	begin
		if(state == memory_read)begin we<=1; end
		if(state == memory_write)begin we<=0; end
	end
end

always @(*)
begin
		if(!second_point)
		begin	
			if(direction == 0)
			begin
				data_out=data_in |8'b00000001;
			end
			else if(direction == 1)
			begin
				data_out=data_in |8'b00000010;
			end
			else if(direction == 2)
			begin
				data_out=data_in |8'b00000100;
			end
			else if(direction == 3)
			begin
				data_out=data_in |8'b00001000;
			end
			else if(direction == 4)
			begin
				data_out=data_in |8'b00010000;
			end
			else if(direction == 5)
			begin
				data_out=data_in |8'b00100000;
			end
			else if(direction == 6)
			begin
				data_out=data_in |8'b01000000;
			end
			else //if(direction == 7)
			begin
				data_out=data_in |8'b10000000;
			end
		end
		else if(second_point)
		begin	
		   if(direction == 0)
			begin
				data_out=data_in |8'b00010000;
			end
			else if(direction == 1)
			begin
				data_out=data_in |8'b00100000;
			end
			else if(direction == 2)
			begin
				data_out=data_in |8'b01000000;
			end
			else if(direction == 3)
			begin
				data_out=data_in |8'b10000000;
			end
			else if(direction == 4)
			begin
				data_out=data_in |8'b00000001;
			end
			else if(direction == 5)
			begin
				data_out=data_in |8'b00000010;
			end
			else if(direction == 6)
			begin
				data_out=data_in |8'b00000100;
			end
			else //if(direction == 7)
			begin
				data_out=data_in |8'b00001000;///////////////////////////////*********************
			end
		end
	
end

assign update_done = (state == update_done_s);



endmodule
