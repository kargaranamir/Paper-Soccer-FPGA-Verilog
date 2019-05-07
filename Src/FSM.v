`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:36:00 11/03/2017 
// Design Name: 
// Module Name:    FSM 
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
module FSM(
	input clk,
	input my_turn,
	input [7:0] current_x_in,//
	input [7:0] current_y_in,//
	input [7:0] width_in,//
	input [7:0] length_in,//
	input color_in,//
	output reg [7:0] current_x,//
	output reg [7:0] current_y,//
	output reg color=1'b0,//
	output reg [7:0] width,//
	output reg [7:0] length,//
	
	input idle_mem_reader,//
	input finish_mem_reader,//
	output reg start_mem_reader,//
	
	output reg start_a,

	input idle_a,

	input finish_a,

	input finish_valid_a,

	input no_perm_a,

	input no_perm_valid_a,

	output idle,
	input [7:0] bestval_a,

	output reg [2:0] direction,
	output direction_valid,
	input my_move_a,
	
	output comp_a,
	output comp_b,
	output comp_c,
	output comp_d,
	output comp_e,
	output comp_f,
	output comp_g,
	output comp_h,
	output reg flag=1'b0,////////////////////////////////////////////
	output reg my_move=1'b0
    );
	 
	 localparam a=0;
	 localparam b=1;
	 localparam c=2;
	 localparam d=3;
	 localparam e=4;
	 localparam f=5;
	 localparam g=6;
	 localparam h=7;
	 
	 localparam idle_s=0;
	 localparam mem_reading_wait=1;
	 localparam mem_reading=2;
	 localparam computation_a=3;
	 localparam computation_b=4;
	 localparam computation_c=5;
	 localparam computation_d=6;
	 localparam computation_e=7;
	 localparam computation_f=8;
	 localparam computation_g=9;
	 localparam computation_h=10;
	 localparam make_decision=11;
	 localparam result=12;
	 localparam computation_waiting=13;
	 localparam initial_check=14;
	 
	 localparam red=1;
	 localparam blue=0;
	 reg [4:0] state=0;
	 always @ (posedge clk)
	 begin
		if(state == idle_s && my_turn )
		begin
			state<= initial_check;
		end
		if(state == initial_check)
		begin
			if( ((current_x==width/2+1) && current_y==length && color==blue) || ((current_x==width/2-1) && current_y==length && color==blue) || ((current_x==width/2 )&& current_y==length && color==blue) || ((current_x==width/2+1) && current_y==0 && color==red) || ((current_x==width/2-1) && current_y==0 && color==red) || ((current_x==width/2) && current_y==0 && color==red))
			begin
				state<=result;
				flag<=1'b1;
			end
			else
			begin
				state<=mem_reading_wait;
			end
		end
		if(state == mem_reading_wait)
		begin
			if(idle_mem_reader)
			begin
				state<=mem_reading;
			end
			else
			begin
				state<=mem_reading_wait;
			end
		end
		if(state == mem_reading && finish_mem_reader)
		begin
			state<=computation_waiting;
		end
		if(state == computation_waiting)
		begin
			if(idle_a)
			begin
				state<=computation_a;/////////////
			end
			else
			begin
				state<=computation_waiting;
			end
		end
		if(state == computation_a && (finish_a || no_perm_a))
		begin
			state<=computation_b;////////////////
		end
		if(state == computation_b && (finish_a || no_perm_a))
		begin
			state<=computation_c;////////////////
		end
		if(state == computation_c && (finish_a || no_perm_a))
		begin
			state<=computation_d;
		end
		if(state == computation_d && (finish_a || no_perm_a))
		begin
			state<=computation_e;
		end
		if(state == computation_e && (finish_a || no_perm_a))
		begin
			state<=computation_f;
		end
		if(state == computation_f && (finish_a || no_perm_a))
		begin
			state<=computation_g;
		end
		if(state == computation_g && (finish_a || no_perm_a))
		begin
			state<=computation_h;
		end
		if(state == computation_h && (finish_a || no_perm_a))
		begin
			state<=make_decision;
		end
		if(state == make_decision)
		begin
			state<=result;
		end
		if(state == result)
		begin
			state<=idle_s;
		end
	 end
	 
	 always @ (posedge clk)
	 begin
		if(state== idle_s && my_turn)
		begin
			current_x<=current_x_in;
			current_y<=current_y_in;
			color<=color_in;
			width<=width_in;
			length<=length_in;
		end
	 end
	 
	 always @ (posedge clk)
	 begin
		if(state == idle_s && my_turn)
		begin
			start_mem_reader<=1'b0;
		end
		if( state == mem_reading_wait && idle_mem_reader )
		begin
			start_mem_reader<=1'b1;
		end
		if( state == mem_reading && finish_mem_reader  )
		begin
			start_mem_reader<=1'b0;
		end
	 end
	 
	 always @ (posedge clk)
	 begin
		if(state== idle_s && my_turn)
		begin
				start_a<=0;
		end
		if((state == computation_waiting) && idle_a )
		begin
			   start_a<=1;
		end
		if((state == computation_h) && (finish_a || no_perm_a) )
		begin
			   start_a<=0;
		end
	 end
	 
	 
	reg [7:0] bestvala=8'd0;
	reg [7:0] bestvalb=8'd0;
	reg [7:0] bestvalc=8'd0;
	reg [7:0] bestvald=8'd0;
	reg [7:0] bestvale=8'd0;
	reg [7:0] bestvalf=8'd0;
	reg [7:0] bestvalg=8'd0;
	reg [7:0] bestvalh=8'd0;
	 
	reg no_perm_a_r=1'b0;
	reg no_perm_b_r=1'b0;
	reg no_perm_c_r=1'b0;
	reg no_perm_d_r=1'b0;
	reg no_perm_e_r=1'b0;
	reg no_perm_f_r=1'b0;
	reg no_perm_g_r=1'b0;
	reg no_perm_h_r=1'b0;
	reg my_movea=1'b0;
	reg my_moveb=1'b0;
	reg my_movec=1'b0;
	reg my_moved=1'b0;
	reg my_movee=1'b0;
	reg my_movef=1'b0;
	reg my_moveg=1'b0;
	reg my_moveh=1'b0;
	
	
	 assign comp_a = (state==computation_a);
	 assign comp_b = (state==computation_b);
	 assign comp_c = (state==computation_c);
	 assign comp_d = (state==computation_d);
	 assign comp_e = (state==computation_e);
	 assign comp_f = (state==computation_f);
	 assign comp_g = (state==computation_g);
	 assign comp_h = (state==computation_h);
	 
	 always @ (posedge clk)
	 begin
		if(state == computation_a && finish_a)begin bestvala<=bestval_a; my_movea<=my_move_a; no_perm_a_r<=1'b0; end
		else if(state == computation_a && no_perm_valid_a)begin bestvala<=0; no_perm_a_r<=no_perm_a; end
		
		if(state == computation_b && finish_a)begin bestvalb<=bestval_a; my_moveb<=my_move_a;no_perm_b_r<=1'b0;  end
		else if(state == computation_b && no_perm_valid_a)begin bestvalb<=0;no_perm_b_r<=no_perm_a; end
		
		if(state == computation_c && finish_a)begin bestvalc<=bestval_a; my_movec<=my_move_a;no_perm_c_r<=1'b0;  end
		else if(state == computation_c && no_perm_valid_a)begin bestvalc<=0;no_perm_c_r<=no_perm_a; end
		
		if(state == computation_d && finish_a)begin bestvald<=bestval_a; my_moved<=my_move_a; no_perm_d_r<=1'b0; end
		else if(state == computation_d && no_perm_valid_a)begin bestvald<=0; no_perm_d_r<=no_perm_a; end
		
		if(state == computation_e && finish_a)begin bestvale<=bestval_a; my_movee<=my_move_a;no_perm_e_r<=1'b0;  end
		else if(state == computation_e && no_perm_valid_a)begin bestvale<=0;no_perm_e_r<=no_perm_a; end
		
		if(state == computation_f && finish_a)begin bestvalf<=bestval_a; my_movef<=my_move_a;no_perm_f_r<=1'b0;  end
		else if(state == computation_f && no_perm_valid_a)begin bestvalf<=0;no_perm_f_r<=no_perm_a; end
		
		if(state == computation_g && finish_a)begin bestvalg<=bestval_a; my_moveg<=my_move_a;no_perm_g_r<=1'b0;  end
		else if(state == computation_g && no_perm_valid_a)begin bestvalg<=0;no_perm_g_r<=no_perm_a; end
		
		if(state == computation_h && finish_a)begin bestvalh<=bestval_a; my_moveh<=my_move_a;no_perm_h_r<=1'b0;  end
		else if(state == computation_h && no_perm_valid_a)begin bestvalh<=0;no_perm_h_r<=no_perm_a; end
	 end

	
	 

	always @(posedge clk)
	begin
		if(state==idle_s && my_turn)begin my_move<=0; end//////////////////////////////////////////////////
		
		if(state == initial_check)
		begin
			if((current_x== width/2+1) && current_y==length)
			begin
				//if(color ==red)begin end
				if(color ==blue)begin direction<=h; end
			end
			else if((current_x==width/2-1) && current_y==length)
			begin
				//if(color ==red)begin end
				if(color ==blue)begin direction<=b; end
			end
			else if((current_x==width/2) && current_y==length)
			begin
				//if(color ==red)begin end
				if(color ==blue)begin direction<=a; end
			end
			else if((current_x==width/2+1) && current_y==0)
			begin
				if(color ==red)begin direction<=f; end
				//if(color ==blue)begin end
			end
			else if((current_x==width/2-1) && current_y==0)
			begin
				if(color ==red)begin direction<=d; end
				//if(color ==blue)begin end
			end
			else if((current_x==width/2) && current_y==0)
			begin
				if(color ==red)begin direction<=e; end
				//if(color ==blue)begin end
			end
		end
		if(state == make_decision)
		begin
			if(color==red)
			begin
				if((bestvala<=bestvale) && (bestvalb<=bestvale) && (bestvalc<=bestvale) && (bestvald<=bestvale) && (bestvalf<=bestvale) && (bestvalg<=bestvale) && (bestvalh<=bestvale)&& (!no_perm_e_r))
				begin
					direction <= e;
					my_move<=my_movee;
				end
				else if((bestvala<=bestvald) && (bestvalb<=bestvald) && (bestvalc<=bestvald) && (bestvale<=bestvald) && (bestvalf<=bestvald) && (bestvalg<=bestvald) && (bestvalh<=bestvald)&& (!no_perm_d_r))
				begin
					direction <= d;
					my_move<=my_moved;
				end
				else if((bestvala<=bestvalf) && (bestvalb<=bestvalf) && (bestvalc<=bestvalf) && (bestvald<=bestvalf) && (bestvale<=bestvalf) && (bestvalg<=bestvalf) && (bestvalh<=bestvalf)&& (!no_perm_f_r))
				begin
					direction <= f;
					my_move<=my_movef;
				end
				else if((bestvala<=bestvalc) && (bestvalb<=bestvalc) && (bestvald<=bestvalc) && (bestvale<=bestvalc) && (bestvalf<=bestvalc) && (bestvalg<=bestvalc) && (bestvalh<=bestvalc)&& (!no_perm_c_r))
				begin
					direction <= c;
					my_move<=my_movec;
				end
				else if((bestvala<=bestvalg) && (bestvalb<=bestvalg) && (bestvalc<=bestvalg) && (bestvald<=bestvalg) && (bestvale<=bestvalg) && (bestvalf<=bestvalg) && (bestvalh<=bestvalg)&& (!no_perm_g_r))
				begin
					direction <= g;
					my_move<=my_moveg;
				end
				else if((bestvala<=bestvalb) && (bestvalc<=bestvalb) && (bestvald<=bestvalb) && (bestvale<=bestvalb) && (bestvalf<=bestvalb) && (bestvalg<=bestvalb) && (bestvalh<=bestvalb)&& (!no_perm_b_r))
				begin
					direction <= b;
					my_move<=my_moveb;
				end
				else if((bestvala<=bestvalh) && (bestvalb<=bestvalh) && (bestvalc<=bestvalh) && (bestvald<=bestvalh) && (bestvale<=bestvalh) && (bestvalf<=bestvalh) && (bestvalg<=bestvalh)&& (!no_perm_h_r))
				begin
					direction <= h;
					my_move<=my_moveh;
				end
				else if((bestvalc<=bestvala) && (bestvalb<=bestvala) && (bestvald<=bestvala) && (bestvale<=bestvala) && (bestvalf<=bestvala) && (bestvalg<=bestvala) && (bestvalh<=bestvala)&& (!no_perm_a_r))///////////////////%%%%%%%%%%
				begin
					direction <= a;
					my_move<=my_movec;
				end
				else
				begin
					direction <= 2;//**********************////////\\\\\\\\****************************
					my_move<=1'b0;/////**************************\\\\\\\\\\\\\\\\\\\\\\\\
				end
			end
			if(color==blue)
			begin
				if((bestvalb<=bestvala) && (bestvalc<=bestvala) && (bestvald<=bestvala) && (bestvale<=bestvala) && (bestvalf<=bestvala) && (bestvalg<=bestvala) && (bestvalh<=bestvala) && (!no_perm_a_r))
				begin
					direction <= a;
					my_move<=my_movea;
				end 
				else if((bestvala<=bestvalb) && (bestvalc<=bestvalb) && (bestvald<=bestvalb) && (bestvale<=bestvalb) && (bestvalf<=bestvalb) && (bestvalg<=bestvalb) && (bestvalh<=bestvalb)&& (!no_perm_b_r))
				begin
					direction <= b;
					my_move<=my_moveb;
				end
				else if((bestvala<=bestvalh) && (bestvalb<=bestvalh) && (bestvalc<=bestvalh) && (bestvald<=bestvalh) && (bestvale<=bestvalh) && (bestvalf<=bestvalh) && (bestvalg<=bestvalh)&& (!no_perm_h_r))
				begin
					direction <= h;
					my_move<=my_moveh;
				end
				else if((bestvala<=bestvalc) && (bestvalb<=bestvalc) && (bestvald<=bestvalc) && (bestvale<=bestvalc) && (bestvalf<=bestvalc) && (bestvalg<=bestvalc) && (bestvalh<=bestvalc)&& (!no_perm_c_r))
				begin
					direction <= c;
					my_move<=my_movec;
				end
				else if((bestvala<=bestvalg) && (bestvalb<=bestvalg) && (bestvalc<=bestvalg) && (bestvald<=bestvalg) && (bestvale<=bestvalg) && (bestvalf<=bestvalg) && (bestvalh<=bestvalg)&& (!no_perm_g_r))
				begin
					direction <= g;
					my_move<=my_moveg;
				end
				else if((bestvala<=bestvald) && (bestvalb<=bestvald) && (bestvalc<=bestvald) && (bestvale<=bestvald) && (bestvalf<=bestvald) && (bestvalg<=bestvald) && (bestvalh<=bestvald)&& (!no_perm_d_r))
				begin
					direction <= d;
					my_move<=my_moved;
				end
				else if((bestvala<=bestvalf) && (bestvalb<=bestvalf) && (bestvalc<=bestvalf) && (bestvald<=bestvalf) && (bestvale<=bestvalf) && (bestvalg<=bestvalf) && (bestvalh<=bestvalf)&& (!no_perm_f_r))
				begin
					direction <= f;
					my_move<=my_movef;
				end
				else if((bestvala<=bestvale) && (bestvalb<=bestvale) && (bestvalc<=bestvale) && (bestvald<=bestvale) && (bestvalf<=bestvale) && (bestvalg<=bestvale) && (bestvalh<=bestvale)&& (!no_perm_e_r))
				begin
					direction <= e;
					my_move<=my_movee;
				end
				else
				begin
					direction <= 2;//*************************************************************************
					my_move<=1'b0;////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
				end
			end
		end
	end
	
	assign direction_valid =(state == result);
	assign idle = (state == idle_s);


endmodule
