`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:39:27 10/29/2017 
// Design Name: 
// Module Name:    mem_reader 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: when start is lunched,current location is captured and module give information of neighbourhood if they are exist,
//at end,module arise finish signal,when finish signal arised you can trust output of module 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mem_reader(
    input clk,
    input [8:0] current_x,//0-254,one bit for sign
    input [8:0] current_y,//0-254,one bit for sign
	 input start,//handshake
	 input [7:0] data_in,//data recieve from memory
	 input data_valid,//input data from memory is valid
	 input [7:0] width,
	 input  [7:0] length,///////////////////////////////////////////*********************************
    output idle,//
    output finish,
	 output [7:0] data_out0,
	 output [7:0] data_out1,
	 output [7:0] data_out2,
	 output [7:0] data_out3,
	 output [7:0] data_out4,
	 output [7:0] data_out5,
	 output [7:0] data_out6,
	 output [7:0] data_out7,
	 output [7:0] data_out8,
	 output [7:0] data_out9,
	 output [7:0] data_out10,
	 output [7:0] data_out11,
	 output [7:0] data_out12,
	 output [7:0] data_out13,
	 output [7:0] data_out14,
	 output [7:0] data_out15,
	 output [7:0] data_out16,
	 output [7:0] data_out17,
	 output [7:0] data_out18,
	 output [7:0] data_out19,
	 output [7:0] data_out20,
	 output [7:0] data_out21,
	 output [7:0] data_out22,
	 output [7:0] data_out23,
	 output [7:0] data_out24,
	 output reg enable=1'b0,//enable signal for reading data from memory
	 output reg [24:0] status=0,
	 output [15:0]address//254*254
    );
	 reg [7:0] data_out [24:0];
	 reg signed [8:0] current_x_reg;/////////////////////////////////////////
	 reg signed[8:0] current_y_reg;/////////////////////////////////////////
	 reg [7:0] x_reg=0;
	 reg [7:0] y_reg=0;
	 
	 reg [7:0] counter =0;
	 localparam address_compute=0;
	 localparam m_read=1;
	 localparam get_data=2;
	 localparam idle_s=3;
	 reg [4:0] state=idle_s;
	 reg finish_point=0;
	 always @ (posedge clk)
	 begin
		if(state == idle_s)
		begin
			if(start == 1'b1)
			begin
			current_x_reg <= current_x;
			current_y_reg <= current_y;
			counter<=0;
			status<=0;
			enable<=0;
			end
		end
		if(state == address_compute)
		begin
			if(counter == 0)
			begin
				if((0<=current_x_reg-2) && (current_y_reg+2<=length))
				begin
					x_reg<=current_x_reg-2;
					y_reg<=current_y_reg+2;
					enable<=1'b1;
					status<=status | 25'b0000000000000000000000001;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 1)
			begin
				if((0<=current_x_reg-1) && (current_y_reg+2<=length))
				begin
					x_reg<=current_x_reg-1;
					y_reg<=current_y_reg+2;
					enable<=1'b1;
					status<=status | 25'b0000000000000000000000010;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 2)
			begin
				if((0<=current_x_reg) && (current_y_reg+2<=length))
				begin
					x_reg<=current_x_reg;
					y_reg<=current_y_reg+2;
					enable<=1'b1;
					status<=status | 25'b0000000000000000000000100;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 3)
			begin
				if((current_x_reg+1<=width) && (current_y_reg+2<=length))
				begin
					x_reg<=current_x_reg+1;
					y_reg<=current_y_reg+2;
					enable<=1'b1;
					status<=status | 25'b0000000000000000000001000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 4)
			begin
				if((current_x_reg+2<=width) && (current_y_reg+2<=length))
				begin
					x_reg<=current_x_reg+2;
					y_reg<=current_y_reg+2;
					enable<=1'b1;
					status<=status | 25'b0000000000000000000010000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 5)
			begin
				if((0<=current_x_reg-2) && (current_y_reg+1<=length))
				begin
					x_reg<=current_x_reg-2;
					y_reg<=current_y_reg+1;
					enable<=1'b1;
					status<=status | 25'b0000000000000000000100000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 6)
			begin
				if((0<=current_x_reg-1) && (current_y_reg+1<=length))
				begin
					x_reg<=current_x_reg-1;
					y_reg<=current_y_reg+1;
					enable<=1'b1;
					status<=status | 25'b0000000000000000001000000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 7)
			begin
				if((0<=current_x_reg) && (current_y_reg+1<=length))/////////////////////////////
				begin
					x_reg<=current_x_reg;
					y_reg<=current_y_reg+1;
					enable<=1'b1;
					status<=status | 25'b0000000000000000010000000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 8)
			begin
				if((current_x_reg+1<=width) && (current_y_reg+1<=length))
				begin
					x_reg<=current_x_reg+1;
					y_reg<=current_y_reg+1;
					enable<=1'b1;
					status<=status | 25'b0000000000000000100000000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 9)
			begin
				if((current_x_reg+2<=width) && (current_y_reg+1<=length))
				begin
					x_reg<=current_x_reg+2;
					y_reg<=current_y_reg+1;
					enable<=1'b1;
					status<=status | 25'b0000000000000001000000000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 10)
			begin
				if((0<=current_x_reg-2) && (current_y_reg<=length))
				begin
					x_reg<=current_x_reg-2;
					y_reg<=current_y_reg;
					enable<=1'b1;
					status<=status | 25'b0000000000000010000000000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 11)
			begin
				if((0<=current_x_reg-1) && (current_y_reg<=length))
				begin
					x_reg<=current_x_reg-1;
					y_reg<=current_y_reg;
					enable<=1'b1;
					status<=status | 25'b0000000000000100000000000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 12)
			begin
				if((0<=current_x_reg) && (current_y_reg<=length))
				begin
					x_reg<=current_x_reg;
					y_reg<=current_y_reg;
					enable<=1'b1;
					status<=status | 25'b0000000000001000000000000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 13)
			begin
				if((current_x_reg+1<=width) && (current_y_reg<=length))
				begin
					x_reg<=current_x_reg+1;
					y_reg<=current_y_reg;
					enable<=1'b1;
					status<=status | 25'b0000000000010000000000000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 14)
			begin
				if((current_x_reg+2<=width) && (current_y_reg<=length))
				begin
					x_reg<=current_x_reg+2;
					y_reg<=current_y_reg;
					enable<=1'b1;
					status<=status | 25'b0000000000100000000000000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 15)
			begin
				if((0<=current_x_reg-2) && (0<=current_y_reg-1))
				begin
					x_reg<=current_x_reg-2;
					y_reg<=current_y_reg-1;
					enable<=1'b1;
					status<=status | 25'b0000000001000000000000000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 16)
			begin
				if((0<=current_x_reg-1) && (0<=current_y_reg-1))
				begin
					x_reg<=current_x_reg-1;
					y_reg<=current_y_reg-1;
					enable<=1'b1;
					status<=status | 25'b0000000010000000000000000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 17)
			begin
				if((0<=current_x_reg) && (0<=current_y_reg-1))
				begin
					x_reg<=current_x_reg;
					y_reg<=current_y_reg-1;
					enable<=1'b1;
					status<=status | 25'b0000000100000000000000000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 18)
			begin
				if((current_x_reg+1<=width) && (0<=current_y_reg-1))
				begin
					x_reg<=current_x_reg+1;
					y_reg<=current_y_reg-1;
					enable<=1'b1;
					status<=status | 25'b0000001000000000000000000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 19)
			begin
				if((current_x_reg+2<=width) && (0<=current_y_reg-1))
				begin
					x_reg<=current_x_reg+2;
					y_reg<=current_y_reg-1;
					enable<=1'b1;
					status<=status | 25'b0000010000000000000000000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 20)
			begin
				if((0<=current_x_reg-2) && (0<=current_y_reg-2))
				begin
					x_reg<=current_x_reg-2;
					y_reg<=current_y_reg-2;
					enable<=1'b1;
					status<=status | 25'b0000100000000000000000000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 21)
			begin
				if((0<=current_x_reg-1) && (0<=current_y_reg-2))
				begin
					x_reg<=current_x_reg-1;
					y_reg<=current_y_reg-2;
					enable<=1'b1;
					status<=status | 25'b0001000000000000000000000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 22)
			begin
				if((0<=current_x_reg) && (0<=current_y_reg-2))
				begin
					x_reg<=current_x_reg;
					y_reg<=current_y_reg-2;
					enable<=1'b1;
					status<=status | 25'b0010000000000000000000000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 23)
			begin
				if((current_x_reg+1<=width) && (0<=current_y_reg-2))
				begin
					x_reg<=current_x_reg+1;
					y_reg<=current_y_reg-2;
					enable<=1'b1;
					status<=status | 25'b0100000000000000000000000;
				end
				else
				begin
					enable<=0;
				end
				counter<=counter+1;
			end
			if(counter == 24)
			begin
				if((current_x_reg+2<=width) && (0<=current_y_reg-2))
				begin
					x_reg<=current_x_reg+2;
					y_reg<=current_y_reg-2;
					enable<=1'b1;
					status<=status | 25'b1000000000000000000000000;
				end
				else
				begin
					enable<=0;
				end
				finish_point<=1'b1;
			end
		end
		/*if(state == get_data)
		begin
			if(data_valid)
			begin
				if(x_reg == current_x_reg + 2 && y_reg == current_y_reg + 2)
					begin
						x_reg <= 0;
						y_reg <= 0;
					end
			end
		end*/
		if(state == idle_s && start) begin finish_point<=0; end
	 end
	 
	 
	
	 
	 always @(posedge clk)
	 begin
		if(state == idle_s)
		begin
			if(start == 1'b1)
			begin
				state<=address_compute;
			end
		end
		if(state == address_compute)
		begin
			state<=m_read;
		end
		if(state == m_read)
		begin
			state<=get_data;
		end
		if(state == get_data)
		begin
			if(finish_point == 1'b1)
			begin
				state<=idle_s;
			end
			else
			begin
				state<=address_compute;
			end
		end
	 end
	 
	 assign idle = (state == idle_s);
	 assign address = x_reg+(width+1)*y_reg;//********************
	 assign finish = (state == get_data && finish_point == 1'b1);
		
	


	always @(posedge clk)
	 begin
		if(state == get_data)
		begin
			//if(data_valid)
			if(enable)
			begin
				if(finish_point == 1'b1)
				begin
					data_out[counter]<=data_in;
				end
				else
				begin
					data_out[counter-1]<=data_in;
				end
			end
		end
	 end
	 
	 assign data_out0 = data_out[0];
	 assign data_out1 = data_out[1];
	 assign data_out2 = data_out[2];
	 assign data_out3 = data_out[3];
	 assign data_out4 = data_out[4];
	 assign data_out5 = data_out[5];
	 assign data_out6 = data_out[6];
	 assign data_out7 = data_out[7];
	 assign data_out8 = data_out[8];
	 assign data_out9 = data_out[9];
	 assign data_out10 = data_out[10];
	 assign data_out11 = data_out[11];
	 assign data_out12 = data_out[12];
	 assign data_out13 = data_out[13];
	 assign data_out14 = data_out[14];
	 assign data_out15 = data_out[15];
	 assign data_out16 = data_out[16];
	 assign data_out17 = data_out[17];
	 assign data_out18 = data_out[18];
	 assign data_out19 = data_out[19];
	 assign data_out20 = data_out[20];
	 assign data_out21 = data_out[21];
	 assign data_out22 = data_out[22];
	 assign data_out23 = data_out[23];
	 assign data_out24 = data_out[24];
	 
endmodule
