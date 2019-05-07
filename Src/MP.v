`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:09:42 10/30/2017 
// Design Name: 
// Module Name:    MP 
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
module MP(
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
	output flag,
	output my_move
	//output color_o/////////////////////
	//output [7:0] data_out12
    );
	 
wire [7:0] current_x;
wire [7:0] current_y;
wire [7:0] width;
wire [7:0] length;

wire [7:0] bestvala;




// Instantiate the module
FSM FSM1 (
    .clk(clk), //
    .my_turn(my_turn), //
    .current_x_in(current_x_in), //
    .current_y_in(current_y_in), //
    .width_in(width_in), //
    .length_in(length_in),// 
    .color_in(color_in), //
    .current_x(current_x), //
    .current_y(current_y),// 
    .color(color), //
    .width(width), //
    .length(length), //
    .idle_mem_reader(idle_mem_reader), //
    .finish_mem_reader(finish_mem_reader), //
    .start_mem_reader(start_mem_reader), 
    .start_a(start_a), //
    .idle_a(idle_a), //
    .finish_a(finish_a), 
    .finish_valid_a(finish_valid_a), //
    .no_perm_a(no_perm_a), //
    .no_perm_valid_a(no_perm_valid_a), //
    .idle(idle), //
    .bestval_a(bestvala), //
    .direction(direction), //
    .direction_valid(direction_valid),// 
    .my_move_a(my_move_a), //
    .comp_a(comp_a), //
    .comp_b(comp_b), //
    .comp_c(comp_c), //
    .comp_d(comp_d),// 
    .comp_e(comp_e), //
    .comp_f(comp_f), //
    .comp_g(comp_g), //
    .comp_h(comp_h), //
	 .flag(flag),/////////////////////////////
    .my_move(my_move)//
    );
	 
	 



wire [24:0] status;

	wire [7:0] data_out0;
	 wire [7:0] data_out1;
	 wire [7:0] data_out2;
	 wire [7:0] data_out3;
	 wire [7:0] data_out4;
	 wire [7:0] data_out5;
	 wire [7:0] data_out6;
	 wire [7:0] data_out7;
	 wire [7:0] data_out8;
	 wire [7:0] data_out9;
	 wire [7:0] data_out10;
	 wire [7:0] data_out11;
	 wire [7:0] data_out12;//*******************************
	 wire [7:0] data_out13;
	 wire [7:0] data_out14;
	 wire [7:0] data_out15;
	 wire [7:0] data_out16;
	 wire [7:0] data_out17;
	 wire [7:0] data_out18;
	 wire [7:0] data_out19;
	 wire [7:0] data_out20;
	 wire [7:0] data_out21;
	 wire [7:0] data_out22;
	 wire [7:0] data_out23;
	 wire [7:0] data_out24;
	 
	 
// Instantiate the module
wire [8:0] current_x_m = {1'b0,current_x};
wire [8:0] current_y_m = {1'b0,current_y};
mem_reader M1 (
    .clk(clk), //
    .current_x(current_x_m), //
    .current_y(current_y_m), //
    .start(start_mem_reader), //
    .data_in(data_in), //
    .data_valid(data_valid),// 
    .width(width), //
    .length(length), //
    .idle(idle_mem_reader), //
    .finish(finish_mem_reader),// 
    .data_out0(data_out0), 
    .data_out1(data_out1), 
    .data_out2(data_out2), 
    .data_out3(data_out3), 
    .data_out4(data_out4), 
    .data_out5(data_out5), 
    .data_out6(data_out6), 
    .data_out7(data_out7), 
    .data_out8(data_out8), 
    .data_out9(data_out9), 
    .data_out10(data_out10), 
    .data_out11(data_out11), 
    .data_out12(data_out12), 
    .data_out13(data_out13), 
    .data_out14(data_out14), 
    .data_out15(data_out15), 
    .data_out16(data_out16), 
    .data_out17(data_out17), 
    .data_out18(data_out18), 
    .data_out19(data_out19), 
    .data_out20(data_out20), 
    .data_out21(data_out21), 
    .data_out22(data_out22), 
    .data_out23(data_out23), 
    .data_out24(data_out24), 
    .enable(enable), //
    .status(status), //
    .address(address)//
    );


	 
	reg [7:0] data_a;
	reg [7:0] data_b;
	reg [7:0] data_c;
	reg [7:0] data_d;
	reg [7:0] data_e;
	reg [7:0] data_f;
	reg [7:0] data_g;
	reg [7:0] data_h;
	reg [7:0] data_newloc;
	
	
	always @(*)
	begin
		if(comp_a)
		begin
			data_a=data_out2;
			data_b=data_out3;
			data_c=data_out8;
			data_d=data_out13;
			data_e=data_out12;
			data_f=data_out11;
			data_g=data_out6;
			data_h=data_out1;
			data_newloc=data_out7;
		end
		else if(comp_b)
		begin
			data_a=data_out3;
			data_b=data_out4;
			data_c=data_out9;
			data_d=data_out14;
			data_e=data_out13;
			data_f=data_out12;
			data_g=data_out7;
			data_h=data_out2;
			data_newloc=data_out8;
		end
		else if(comp_c)
		begin
			data_a=data_out8;
			data_b=data_out9;
			data_c=data_out14;
			data_d=data_out19;
			data_e=data_out18;
			data_f=data_out17;
			data_g=data_out12;
			data_h=data_out7;
			data_newloc=data_out13;
		end
		else if(comp_d)
		begin
			data_a=data_out13;
			data_b=data_out14;
			data_c=data_out19;
			data_d=data_out24;
			data_e=data_out23;
			data_f=data_out22;
			data_g=data_out17;
			data_h=data_out12;
			data_newloc=data_out18;
		end
		else if(comp_e)
		begin
			data_a=data_out12;
			data_b=data_out13;
			data_c=data_out18;
			data_d=data_out23;
			data_e=data_out22;
			data_f=data_out21;
			data_g=data_out16;
			data_h=data_out11;
			data_newloc=data_out17;
		end
		else if(comp_f)
		begin
			data_a=data_out11;
			data_b=data_out12;
			data_c=data_out17;
			data_d=data_out22;
			data_e=data_out21;
			data_f=data_out20;
			data_g=data_out15;
			data_h=data_out10;
			data_newloc=data_out16;
		end
		else if(comp_g)
		begin
			data_a=data_out6;
			data_b=data_out7;
			data_c=data_out12;
			data_d=data_out17;
			data_e=data_out16;
			data_f=data_out15;
			data_g=data_out10;
			data_h=data_out5;
			data_newloc=data_out11;
		end
		else if(comp_h)
		begin
			data_a=data_out1;
			data_b=data_out2;
			data_c=data_out7;
			data_d=data_out12;
			data_e=data_out11;
			data_f=data_out10;
			data_g=data_out5;
			data_h=data_out0;
			data_newloc=data_out6;
		end
		else
		begin
			data_a=0;
			data_b=0;
			data_c=0;
			data_d=0;
			data_e=0;
			data_f=0;
			data_g=0;
			data_h=0;
			data_newloc=0;
		end
	end


A_azimuth A1 (
    .current_x(current_x), //
    .current_y(current_y),// 
    .width(width), //
    .length(length), //
    .color(color),// 
    .clk(clk), //
    .start(start_a), //
    .idle(idle_a), //
    .finish(finish_a), //
    .finish_valid(finish_valid_a), 
    .bestval(bestvala),// 
    .no_perm(no_perm_a), //
    .no_perm_valid(no_perm_valid_a), //
    .status(status), 
    .data_out12(data_out12),
	 .data_out_newloc(data_newloc),	 
    .data_out1(data_h), //h
    .data_out2(data_a), //a
    .data_out3(data_b), //b
    .data_out6(data_g), //g
    .data_out7(data_e), //e
    .data_out8(data_c), //c
    .data_out11(data_f),//f 
    .data_out13(data_d), //d
    .my_move(my_move_a),// 
    .comp_a(comp_a), 
    .comp_b(comp_b), 
    .comp_c(comp_c), 
    .comp_d(comp_d), 
    .comp_e(comp_e), 
    .comp_f(comp_f), 
    .comp_g(comp_g), 
	// .color_o(color_o),///////////////
    .comp_h(comp_h)
    );
	 
	 
























	 
	 


endmodule
