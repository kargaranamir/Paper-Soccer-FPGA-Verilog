`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:06:25 11/16/2017 
// Design Name: 
// Module Name:    TOP 
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
module TOP(

	input clk,
	//input rst,
	output TxD,
	output flag,////////////////////////////////////////////////
	input RxD
	//output color_in
	//output reg flag=1'b0
	//output color_o
	//output [7:0] data_out12
	//output [7:0] current_y
	
    );
	 
	 wire rst;
	 assign rst=1'b0;
	 wire [7:0] TxD_data;
	 wire [7:0] RxD_data;
	 //for final project,correct frequency 
	 M1_UART U1 (
    .clk(clk), //
    .rst(rst), //
    .TxD_start(TxD_start),// 
    .TxD_data(TxD_data), //
    .TxD_busy(TxD_busy), //
    .TxD(TxD), //
    .RxD(RxD), //
    .RxD_data_ready(RxD_data_ready),// 
    .RxD_data(RxD_data), //
    .RxD_endofpacket(RxD_endofpacket),// 
    .RxD_idle(RxD_idle)//
    );
	 
	 // Instantiate the module
	 wire [7:0] width;
	 wire [7:0] length;
	 wire [7:0] RxD_data_Opponent;
Interpreter I1 (
    .clk(clk), //
    .rst(rst), //
    .RxD_ready(RxD_data_ready), //
    .RxD_data(RxD_data), //
    .width(width), //
    .width_valid(width_valid), //Persistent
    .length(length), //
    .length_valid(length_valid),// Persistent
    .red(red), //
    .blue(blue), //
    .color_valid(color_valid), //Persistent
    .me_game_start(me_game_start),// 1 clock asserted
    .opponent_game_start(opponent_game_start), //1 clock asserted
    .RxD_data_Opponent(RxD_data_Opponent), //
    .new_en_mov(new_en_mov)//1 clock asserted
    );
	 
	 wire [2:0] direction;
	 wire [2:0] direction_out;
	 wire [7:0] buf_in;
	 Handout H1 (//*********************
    .clk(clk), //
    .rst(rst), //
    .me_game_start(me_game_start), //
    .opponent_game_start(opponent_game_start), //
    .RxD_data_opponent(RxD_data_Opponent), //
    .Rxd_data_opponent_valid(new_en_mov), //
    .my_turn(my_turn), //
    .direction_valid(direction_valid), //
    .direction_in(direction), //
    .my_move_in(my_move), //
    .direction_out(direction_out), //conected to memory_handler
    .direction_valid_out(direction_valid_out),//conected to memory_handler 
    .update_done(update_done), // 
    .start(start), //
    .timer_rst(timer_rst), //
    .time_expire(time_expire), //    
    .wr_en(wr_en), //
    .buf_in(buf_in)//
    );
	 
	 
	 wire [15:0]address_mh;
	 wire [7:0] data_out;
	 wire [7:0] current_x;//////////////////
	 wire [7:0]	current_y;//////////////
	 wire [7:0] data_ram;
	 memory_handler MH11 (
    .clk(clk), //
    .rst(rst), //
    .direction_in(direction_out), //
    .direction_valid(direction_valid_out), //
    .width_in(width), //
    .width_valid(width_valid), //
    .length_in(length), //
    .length_valid(length_valid),// 
    .update_done(update_done), //
    .address(address_mh), //
    .data_out(data_out), //
    .data_in(data_ram), //
    .current_x(current_x), // conected to MP
    .current_y(current_y), //	conected to MP
    .we(we)// connected 2 ram
    );
	 
	 wire [15:0] address;
	 
	 
	 assign address = (idle) ? address_mh :  address_mp;
	 ram_single rs1 (
    .q(data_ram), //output
    .a(address), //
    .d(data_out),//input 
    .we(we), //
    .clk(clk)//
    );
	 
	 
	 wire [15:0] address_mp;
	 wire color_in;
	 assign color_in = (red)? 1'b1:1'b0;
	 MP mp1(//*****************************************************************
    .clk(clk), //
    .my_turn(my_turn), //
    .current_x_in(current_x), //
    .current_y_in(current_y), //
    .width_in(width), //
    .length_in(length), //
    .color_in(color_in), 
    .idle(idle), //
    .direction(direction), //
    .direction_valid(direction_valid), //
    .data_in(data_ram), //
    .address(address_mp), //
	 .flag(flag),////////////////////////////////////////////
    .my_move(my_move)//,
	 //.data_out12(data_out12)
	// .color_o(color_o)/////////////////////////////////
    );
	 
	 
	 wire [7:0] buf_out;
	 fifo ff1 (
    .clk(clk),// 
    .rst(rst), //
    .buf_in(buf_in), //
    .buf_out(buf_out), //
    .wr_en(wr_en), //
    .rd_en(rd_en), //
    .buf_empty(buf_empty), //
    .buf_full(buf_full), //
    .fifo_counter(fifo_counter)//
    );
	 
	 fifo2transmit f2t (
    .clk(clk), //
    .rst(rst), //
    .buf_empty(buf_empty),// 
    .rd_en(rd_en), //
    .buf_out(buf_out), //
    .TxD_busy(TxD_busy), //
    .TxD_start(TxD_start), //
    .TxD_data(TxD_data)//
    );
	 
	 timer t1 (
    .clk(clk), //
    .start(start), //
    .timer_rst(timer_rst), //
    .time_expire(time_expire)//
    );
	 
	 
	 
//	 always @ (posedge clk)
//	 begin
//		if((current_x==4) )
//		begin
//			flag<=1;
//		end
//	 end
	 


endmodule
