`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:30:11 10/31/2017 
// Design Name: 
// Module Name:    A_azimuth 
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
module A_azimuth(
	input [7:0] current_x,
	input [7:0] current_y,
	input [7:0] width,
	input [7:0] length,
	input color,
	input clk,
	input start,
	output idle,
	output  finish,//////////////////////////////////////
	output finish_valid,
	output reg [7:0]bestval,
	output reg no_perm=0,
	output reg no_perm_valid=0,
	input [24:0] status,
	
	input [7:0] data_out12,
	input [7:0] data_out1,
	input [7:0] data_out2,
	input [7:0] data_out3,
	input [7:0] data_out6,
	input [7:0] data_out7,
	input [7:0] data_out8,
	input [7:0] data_out11,
	input [7:0] data_out13,
	input [7:0] data_out_newloc,
	//output color_o,//////////////////////
	output reg my_move,
	input comp_a,
	input comp_b,
	input comp_c,
	input comp_d,
	input comp_e,
	input comp_f,
	input comp_g,
	input comp_h

    );
	// assign color_o =color;
	 
	 reg [7:0] desired_point_number =0;
	 reg [7:0] desired_direction_number=0;
	 reg [7:0] a=0;
	 reg [7:0] b=0;
	 reg [7:0] c=0;
	 reg [7:0] d=0;
	 reg [7:0] e=0;
	 reg [7:0] f=0;
	 reg [7:0] g=0;
	 reg [7:0] h=0;
	 
	 always @(*)
	 begin
		if(comp_a)
		begin
			 desired_point_number =7;
			 desired_direction_number=0;
			 a=2;
			 b=3;
			 c=8;
			 d=13;
			 e=12;
			 f=11;
			 g=6;
			 h=1;
		end
		else if(comp_b)
		begin
			desired_point_number =8;
			desired_direction_number=1;
			a=3;
			b=4;
			c=9;
			d=14;
			e=13;
			f=12;
			g=7;
			h=2;
		end
		else if(comp_c)
		begin
			desired_point_number =13;
			desired_direction_number=2;
			a=8;
			b=9;
			c=14;
			d=19;
			e=18;
			f=17;
			g=12;
			h=7;
		end
		else if(comp_d)
		begin
			desired_point_number =18;
			desired_direction_number=3;
			a=13;
			b=14;
			c=19;
			d=24;
			e=23;
			f=22;
			g=17;
			h=12;
		end
		else if(comp_e)
		begin
			desired_point_number =17;
			desired_direction_number=4;
			a=12;
			b=13;
			c=18;
			d=23;
			e=22;
			f=21;
			g=16;
			h=11;
		end
		else if(comp_f)
		begin
			desired_point_number =16;
			desired_direction_number=5;
			a=11;
			b=12;
			c=17;
			d=22;
			e=21;
			f=20;
			g=15;
			h=10;
		end
		else if(comp_g)
		begin
			desired_point_number =11;
			desired_direction_number=6;
			a=6;
			b=7;
			c=12;
			d=17;
			e=16;
			f=15;
			g=10;
			h=5;
	 
		end
		else if(comp_h)
		begin
			desired_point_number =6;
			desired_direction_number=7;
			a=1;
			b=2;
			c=7;
			d=12;
			e=11;
			f=10;
			g=5;
			h=0;
		end
		else
		begin
			desired_point_number =0;
			desired_direction_number=0;
			a=0;
			b=0;
			c=0;
			d=0;
			e=0;
			f=0;
			g=0;
			h=0;
		end
	 end
	 
	localparam idle_s=0;
	 localparam perm_check=1;
	 localparam new_location=2;
	 localparam make_decision=3;
	 localparam red=1;
	 localparam blue=0;
	 
	 reg [4:0] state  =0;
  	 wire [3:0] line_number;
	 assign line_number = data_out_newloc[0] + data_out_newloc[1] + data_out_newloc[2] + data_out_newloc[3] + data_out_newloc[4] + data_out_newloc[5] + data_out_newloc[6] + data_out_newloc[7];
	 always @(posedge clk)
	 begin
		if(state == idle_s && start)
		begin
			if(comp_a)
			begin
				no_perm<=(!status[desired_point_number]) ||(data_out12[desired_direction_number]) || (line_number == 7 ) || (current_x == width ) || (current_x == 0 ) || (current_y==length-1 && line_number==2) || (current_y==length/2-1 && line_number==5);
			end
			else if(comp_b)
			begin
				no_perm<=(!status[desired_point_number]) ||(data_out12[desired_direction_number]) || (line_number == 7 ) || (current_x == width-1 && current_y==length-1 )  || (current_x==width-1 && line_number==2) || (current_y==length-1 && line_number==2)|| (current_y==length/2-1 && line_number==5);
			end
			else if(comp_c)
			begin
				no_perm<=(!status[desired_point_number]) ||(data_out12[desired_direction_number]) || (line_number == 7 ) || (current_y == length ) || (current_y == 0 ) || (current_y == length/2) || (current_x==width-1 && line_number==2);
			end
			else if(comp_d)
			begin
				no_perm<=(!status[desired_point_number]) ||(data_out12[desired_direction_number]) || (line_number == 7 ) || (current_x == width-1 && current_y==1 ) || (current_x==width-1 && line_number==2) || (current_y==1 && line_number==2)|| (current_y==length/2+1 && line_number==5);
			end
			else if(comp_e)
			begin
				no_perm<=(!status[desired_point_number]) ||(data_out12[desired_direction_number]) || (line_number == 7 ) || (current_x == width ) || (current_x == 0 ) || (current_y==1 && line_number==2)|| (current_y==length/2+1 && line_number==5);
			end
			else if(comp_f)
			begin
				no_perm<=(!status[desired_point_number]) ||(data_out12[desired_direction_number]) || (line_number == 7 )||(current_x == 1 && current_y== 1 ) || (current_x==1 && line_number==2) || (current_y==1 && line_number==2)|| (current_y==length/2+1 && line_number==5);
			end
			else if(comp_g)
			begin
				no_perm<=(!status[desired_point_number]) ||(data_out12[desired_direction_number]) || (line_number == 7 ) || (current_y == length ) || (current_y == 0 )|| (current_y == length/2 ) || (current_x==1 && line_number==2);
			end
			else if(comp_h)
			begin
				no_perm<=(!status[desired_point_number]) ||(data_out12[desired_direction_number]) || (line_number == 7 ) || (current_x == 1 && current_y==length-1 ) || (current_x==1 && line_number==2) || (current_y==length-1 && line_number==2)|| (current_y==length/2-1 && line_number==5) ;
			end
			no_perm_valid<=1;
		end
		if(state == perm_check && no_perm)
		begin
			no_perm<=0;
		end
		if(state == perm_check) begin no_perm_valid<=0; end
	 end
	

	assign idle = (state == idle_s);
	assign finish = (state == make_decision);////////////////////////////////
	assign finish_valid = (state == make_decision);
	always @(posedge clk)
	 begin
		if(state == idle_s)
		begin
			if(start)
			begin
				state<=perm_check;
			end
		end
		if(state == perm_check)
		begin
			if(no_perm)
			begin
				state<=idle_s;
			end
			else
			begin
				state<=new_location;
			end
		end
		if(state == new_location)
		begin
			state<=make_decision;
		end
		if(state == make_decision)
		begin
			state<=idle_s;
		end
	 end

	 
	 reg [7:0] nloc_x;
	 reg [7:0] nloc_y;
	 
	 always @(posedge clk)
	 begin
		if(state == perm_check && (!no_perm))
		begin
			if(comp_a)
			begin
				nloc_x<=current_x;
				nloc_y<=current_y+1;
			end
			else if(comp_b)
			begin
				nloc_x<=current_x+1;
				nloc_y<=current_y+1;
			end
			else if(comp_c)
			begin
				nloc_x<=current_x+1;
				nloc_y<=current_y;
			end
			else if(comp_d)
			begin
				nloc_x<=current_x+1;
				nloc_y<=current_y-1;
			end
			else if(comp_e)
			begin
				nloc_x<=current_x;
				nloc_y<=current_y-1;
			end
			else if(comp_f)
			begin
				nloc_x<=current_x-1;
				nloc_y<=current_y-1;
			end
			else if(comp_g)
			begin
				nloc_x<=current_x-1;
				nloc_y<=current_y;
			end
			else if(comp_h)
			begin
				nloc_x<=current_x-1;
				nloc_y<=current_y+1;
			end
		end
	 end
	 
	 wire [7:0] a_linenumber;
	 wire [7:0] b_linenumber;
	 wire [7:0] c_linenumber;
	 wire [7:0] d_linenumber;
	 wire [7:0] e_linenumber;
	 wire [7:0] f_linenumber;
	 wire [7:0] g_linenumber;
	 wire [7:0] h_linenumber;
	 assign a_linenumber = data_out2[0] + data_out2[1] + data_out2[2] + data_out2[3] + data_out2[4] + data_out2[5] + data_out2[6] + data_out2[7];
	 assign b_linenumber = data_out3[0] + data_out3[1] + data_out3[2] + data_out3[3] + data_out3[4] + data_out3[5] + data_out3[6] + data_out3[7];
	 assign c_linenumber = data_out8[0] + data_out8[1] + data_out8[2] + data_out8[3] + data_out8[4] + data_out8[5] + data_out8[6] + data_out8[7];
	 assign d_linenumber = data_out13[0] + data_out13[1] + data_out13[2] + data_out13[3] + data_out13[4] + data_out13[5] + data_out13[6] + data_out13[7];
	 assign e_linenumber = data_out7[0] + data_out7[1] + data_out7[2] + data_out7[3] + data_out7[4] + data_out7[5] + data_out7[6] + data_out7[7];///////////////////////////////////////////%%%%%%%%%
	 assign f_linenumber = data_out11[0] + data_out11[1] + data_out11[2] + data_out11[3] + data_out11[4] + data_out11[5] + data_out11[6] + data_out11[7];
	 assign g_linenumber = data_out6[0] + data_out6[1] + data_out6[2] + data_out6[3] + data_out6[4] + data_out6[5] + data_out6[6] + data_out6[7];
	 assign h_linenumber = data_out1[0] + data_out1[1] + data_out1[2] + data_out1[3] + data_out1[4] + data_out1[5] + data_out1[6] + data_out1[7];
	 assign a_perm = status[a] && (!data_out_newloc[0]) && !(my_move && (a_linenumber==7)) && !(nloc_x == width) && !(nloc_x == 0) && (!comp_e) &&  !((nloc_y==length-1 && a_linenumber==2) || (nloc_y==length/2-1 && a_linenumber==5));
	 assign b_perm = status[b] && (!data_out_newloc[1]) && !(my_move && (b_linenumber==7)) && (!comp_f) && !((nloc_x == width-1 && nloc_y==length-1 )  || (nloc_x==width-1 && b_linenumber==2) || (nloc_y==length-1 && b_linenumber==2)|| (nloc_y==length/2-1 && b_linenumber==5));
	 assign c_perm = status[c] && (!data_out_newloc[2]) && !(my_move && (c_linenumber==7)) && !(nloc_y == length) && !(nloc_y == 0) && !(nloc_y == length/2) && (!comp_g) && !(nloc_x==width-1 && c_linenumber==2);
	 assign d_perm = status[d] && (!data_out_newloc[3]) && !(my_move && (d_linenumber==7)) && (!comp_h) && !((nloc_x == width-1 && nloc_y==1 ) || (nloc_x==width-1 && d_linenumber==2) || (nloc_y==1 && d_linenumber==2)|| (nloc_y==length/2+1 && d_linenumber==5));
	 assign e_perm = status[e] && (!data_out_newloc[4]) && !(my_move && (e_linenumber==7)) && !(nloc_x == width)&& !(nloc_x == 0) && (!comp_a) && !((nloc_y==1 && e_linenumber==2)|| (nloc_y==length/2+1 && e_linenumber==5));
	 assign f_perm = status[f] && (!data_out_newloc[5]) && !(my_move && (f_linenumber==7)) &&(!comp_b) && !((nloc_x == 1 && nloc_y== 1 ) || (nloc_x==1 && f_linenumber==2) || (nloc_y==1 && f_linenumber==2)|| (nloc_y==length/2+1 && f_linenumber==5));
	 assign g_perm = status[g] && (!data_out_newloc[6]) && !(my_move && (g_linenumber==7)) && !(nloc_y == length) && !(nloc_y == 0) && !(nloc_y == length/2) && (!comp_c) && !(nloc_x==1 && g_linenumber==2);
	 assign h_perm = status[h] && (!data_out_newloc[7]) && !(my_move && (h_linenumber==7)) && (!comp_d) && !((nloc_x == 1 && nloc_y==length-1 ) || (nloc_x==1 && h_linenumber==2) || (nloc_y==length-1 && h_linenumber==2)|| (nloc_y==length/2-1 && h_linenumber==5));
	 
	 always @(*)
	 begin
	 if(comp_a)
	 begin
		my_move =  (data_out_newloc[7] || data_out_newloc[6] || data_out_newloc[5] || data_out_newloc[4] || data_out_newloc[3] || data_out_newloc[2] || data_out_newloc[1] || data_out_newloc[0] || (current_x == 0) || (current_x == width) || (current_y + 1 == 0 && (current_x != width/2) ) || (current_y+1 == length && (current_x != width/2) )) || (current_y+1 == length/2);
	 end
	 else if(comp_b)
	 begin
		my_move =  (data_out_newloc[7] || data_out_newloc[6] || data_out_newloc[5] || data_out_newloc[4] || data_out_newloc[3] || data_out_newloc[2] || data_out_newloc[1] || data_out_newloc[0] || (current_x+1 == 0) || (current_x+1 == width) || (current_y + 1== 0 && current_x+1 != width/2  ) || (current_y+1 == length && current_x+1 != width/2 )) || (current_y+1 == length/2);
	 end
	 else if(comp_c)
	 begin
		my_move =  (data_out_newloc[7] || data_out_newloc[6] || data_out_newloc[5] || data_out_newloc[4] || data_out_newloc[3] || data_out_newloc[2] || data_out_newloc[1] || data_out_newloc[0] || (current_x+1 == 0) || (current_x+1 == width) || (current_y== 0 && current_x+1 != width/2 ) || (current_y  == length && current_x+1 != width/2 )) || (current_y == length/2);
	 end
	 else if(comp_d)
	 begin
		my_move =  (data_out_newloc[7] || data_out_newloc[6] || data_out_newloc[5] || data_out_newloc[4] || data_out_newloc[3] || data_out_newloc[2] || data_out_newloc[1] || data_out_newloc[0] || (current_x+1 == 0) || (current_x+1 == width) || (current_y - 1 == 0 &&  current_x+1 != width/2 ) || (current_y-1 == length && current_x+1 != width/2 )) || (current_y-1 == length/2);
	 end
	 else if(comp_e)
	 begin
		my_move =  (data_out_newloc[7] || data_out_newloc[6] || data_out_newloc[5] || data_out_newloc[4] || data_out_newloc[3] || data_out_newloc[2] || data_out_newloc[1] || data_out_newloc[0] || (current_x == 0) || (current_x == width) || (current_y - 1 == 0 && current_x != width/2 ) || (current_y-1 == length && current_x != width/2 )) || (current_y-1 == length/2);
	 end
	 else if(comp_f)
	 begin
		my_move =  (data_out_newloc[7] || data_out_newloc[6] || data_out_newloc[5] || data_out_newloc[4] || data_out_newloc[3] || data_out_newloc[2] || data_out_newloc[1] || data_out_newloc[0] || (current_x-1 == 0) || (current_x-1 == width) || (current_y - 1 == 0 && current_x-1 != width/2 ) || (current_y-1 == length && current_x-1!= width/2 )) || (current_y-1 == length/2);
	 end
	 else if(comp_g)
	 begin
		my_move =  (data_out_newloc[7] || data_out_newloc[6] || data_out_newloc[5] || data_out_newloc[4] || data_out_newloc[3] || data_out_newloc[2] || data_out_newloc[1] || data_out_newloc[0] || (current_x-1 == 0) || (current_x-1 == width) || (current_y  == 0 && current_x-1 != width/2 ) || (current_y == length && current_x-1 != width/2)) || (current_y == length/2);
	 end
	 else if(comp_h)
	 begin
		my_move =  (data_out_newloc[7] || data_out_newloc[6] || data_out_newloc[5] || data_out_newloc[4] || data_out_newloc[3] || data_out_newloc[2] || data_out_newloc[1] || data_out_newloc[0] || (current_x-1 == 0) || (current_x-1 == width) || (current_y + 1 == 0 && current_x-1 != width/2) || (current_y+1 == length && current_x-1 != width/2)) || (current_y+1 == length/2);
	 end
	 else begin my_move = 0 ;end
	 end
	 reg [7:0] anloc_x;
	 reg [7:0] anloc_y;
	 reg [7:0] bnloc_x;
	 reg [7:0] bnloc_y;
	 reg [7:0] cnloc_x;
	 reg [7:0] cnloc_y;
	 reg [7:0] dnloc_x;
	 reg [7:0] dnloc_y;
	 reg [7:0] enloc_x;
	 reg [7:0] enloc_y;
	 reg [7:0] fnloc_x;
	 reg [7:0] fnloc_y;
    reg [7:0] gnloc_x;
	 reg [7:0] gnloc_y;
	 reg [7:0] hnloc_x;
	 reg [7:0] hnloc_y;

	 always @ (posedge clk)
	 begin
		if((state ==  new_location) && a_perm )
		begin
			anloc_x<=nloc_x;
			anloc_y<=nloc_y+1;
		end

		if((state ==  new_location) && b_perm )
		begin
			bnloc_x<=nloc_x+1;
			bnloc_y<=nloc_y+1;
		end
		if((state ==  new_location) && c_perm )
		begin
			cnloc_x<=nloc_x+1;
			cnloc_y<=nloc_y;
		end
		if((state ==  new_location) && d_perm )
		begin
			dnloc_x<=nloc_x+1;
			dnloc_y<=nloc_y-1;
		end
		if((state ==  new_location) && e_perm )
		begin
			enloc_x<=nloc_x;
			enloc_y<=nloc_y-1;
		end
		if((state ==  new_location) && f_perm )
		begin
			fnloc_x<=nloc_x-1;
			fnloc_y<=nloc_y-1;
		end
		if((state ==  new_location) && g_perm )
		begin
			gnloc_x<=nloc_x-1;
			gnloc_y<=nloc_y;
		end
		if((state ==  new_location) && h_perm )
		begin
			hnloc_x<=nloc_x-1;
			hnloc_y<=nloc_y+1;
		end
	 end
	 
	 
	 wire [7:0] main_score;
	 
	 wire [7:0] scorea;
	 wire [7:0] scoreb;
	 wire [7:0] scorec;
	 wire [7:0] scored;
	 wire [7:0] scoree;
	 wire [7:0] scoref;
	 wire [7:0] scoreg;
	 wire [7:0] scoreh;
	 Score main(
    .old_x(current_x), 
    .old_y(current_y), 
    .new_x(nloc_x), 
    .new_y(nloc_y), 
    .data_out(data_out_newloc), 
    .my_move(1'b1), 
    .color(color), 
    .length(length), 
    .width(width), 
    .score(main_score),
	 .perm(!no_perm)
    );
	 
	 Score Sa (
    .old_x(current_x), 
    .old_y(current_y), 
    .new_x(anloc_x), 
    .new_y(anloc_y), 
    .data_out(data_out2), 
    .my_move(my_move), 
    .color(color), 
    .length(length), 
    .width(width), 
    .score(scorea),
	 .perm(a_perm)
    );
	 
	 Score Sb (
    .old_x(current_x), 
    .old_y(current_y), 
    .new_x(bnloc_x), 
    .new_y(bnloc_y), 
    .data_out(data_out3), 
    .my_move(my_move), 
    .color(color), 
    .length(length), 
    .width(width), 
    .score(scoreb),
	 .perm(b_perm)
    );
	 
	 Score Sc (
    .old_x(current_x), 
    .old_y(current_y), 
    .new_x(cnloc_x), 
    .new_y(cnloc_y), 
    .data_out(data_out8), 
    .my_move(my_move), 
    .color(color), 
    .length(length), 
    .width(width), 
    .score(scorec),
	 .perm(c_perm)
    );
	 
	 Score Sd (
    .old_x(current_x), 
    .old_y(current_y), 
    .new_x(dnloc_x), 
    .new_y(dnloc_y), 
    .data_out(data_out13), 
    .my_move(my_move), 
    .color(color), 
    .length(length), 
    .width(width), 
    .score(scored),
	 .perm(d_perm)
    );
	 
	 Score Se (
    .old_x(current_x), 
    .old_y(current_y), 
    .new_x(enloc_x), 
    .new_y(enloc_y), 
    .data_out(data_out7), ///////////////////////ghalat%%%%%%%%%%%%%%%%%%%%dorost shod
    .my_move(my_move), 
    .color(color), 
    .length(length), 
    .width(width), 
    .score(scoree),
	 .perm(e_perm)
    );
	 
	 Score Sf (
    .old_x(current_x), 
    .old_y(current_y), 
    .new_x(fnloc_x), 
    .new_y(fnloc_y), 
    .data_out(data_out11), 
    .my_move(my_move), 
    .color(color), 
    .length(length), 
    .width(width), 
    .score(scoref),
	 .perm(f_perm)
    );
	 
	 Score Sg (
    .old_x(current_x), 
    .old_y(current_y), 
    .new_x(gnloc_x), 
    .new_y(gnloc_y), 
    .data_out(data_out6), 
    .my_move(my_move), 
    .color(color), 
    .length(length), 
    .width(width), 
    .score(scoreg),
	 .perm(g_perm)
    );
	 
	 Score Sh (
    .old_x(current_x), 
    .old_y(current_y), 
    .new_x(hnloc_x), 
    .new_y(hnloc_y), 
    .data_out(data_out1), 
    .my_move(my_move), 
    .color(color), 
    .length(length), 
    .width(width), 
    .score(scoreh),
	 .perm(h_perm)
    );
	 
	 
	 wire [7:0] max_score;
	 wire [7:0] min_score;
	 
	 comparator instance_name (
    .a(scorea), 
    .b(scoreb), 
    .c(scorec), 
    .d(scored), 
    .e(scoree), 
    .f(scoref), 
    .g(scoreg), 
    .h(scoreh), 
    .max(max_score)
    );
	 
	 comparator_min cm (
    .a(scorea), 
    .b(scoreb), 
    .c(scorec), 
    .d(scored), 
    .e(scoree), 
    .f(scoref), 
    .g(scoreg), 
    .h(scoreh),
    .min(min_score)
    );
	 
	 always @ (*)
	 begin
		if(state == make_decision)
		begin
			if(my_move)begin bestval = main_score  +max_score;end/////////////////////////%%%%%%%%%
			else if (!my_move) begin bestval = main_score  +min_score;end////////////////////
			else bestval=0;
		end
		else begin bestval=0; end
	 end

//	 always @ (*)
//	 begin
//		if(state == make_decision)
//		begin
//			if(comp_a)begin bestval=100; end
//			else if(comp_b)begin bestval=20; end
//			else if(comp_c)begin bestval=30; end
//			else if(comp_d)begin bestval=40; end
//			else if(comp_e)begin bestval=50; end
//			else if(comp_f)begin bestval=120; end
//			else if(comp_g)begin bestval=1; end
//			else if(comp_h)begin bestval=180; end
//			else begin bestval=0; end
//		//	finish<=1'b1;
//		end
//		else begin bestval=0; end
	// end


endmodule
