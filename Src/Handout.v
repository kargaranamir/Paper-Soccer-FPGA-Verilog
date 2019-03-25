module Handout(
	input clk,
	input rst,
	input me_game_start, // croshe baste dariaft shode ast
	input opponent_game_start,//croshe baz dariaft shode ast
	input [7:0] RxD_data_opponent,
	input Rxd_data_opponent_valid,

	output my_turn,
	input direction_valid,
	input [2:0]direction_in,
	input my_move_in,

	output reg [2:0] direction_out,
	output reg direction_valid_out=1'b0,
	input update_done,

	output reg start=1'b0,
	output reg timer_rst=1'b0,
	input time_expire,

	output reg wr_en=1'b0,
	output reg [7:0]buf_in

);


reg [3:0]state=0;
reg [2:0] direction;
reg my_move=1'b0;
localparam idle_s=0;
localparam enemy_move_waiting=1;
localparam enemy_move_update=2;
localparam my_move_s=3;
localparam my_move_waiting=4;
localparam send_update=5;
localparam make_decision=6;
localparam mymove_start=7;
localparam finish_mymove=8;
localparam enter_send=9;

always @ (posedge clk)
begin
	if(rst)
	begin
		state<=idle_s;

	end
	else
	begin
		case(state)
			idle_s:
			begin
				if(opponent_game_start)begin state<=enemy_move_waiting; end
			end
			enemy_move_waiting:
			begin
				if(Rxd_data_opponent_valid)begin state<=enemy_move_update; end
				else if(me_game_start)begin state<=my_move_s; end
			end
			enemy_move_update:
			begin
				if(update_done)begin state<=enemy_move_waiting; end
			end
			my_move_s:
			begin
				state<=mymove_start;
			end
			mymove_start:
			begin
				if(!time_expire) begin state<=my_move_waiting;end
				else begin state<=finish_mymove; end
			end
			my_move_waiting:
			begin
				if(direction_valid)begin state<=send_update; end
			end
			send_update:
			begin
				if(update_done)begin state<=make_decision; end	
			end
			make_decision:
			begin
				if(!time_expire && my_move) begin state<=mymove_start; end
				else begin state<=finish_mymove; end
			end
			finish_mymove:
			begin
				state<=enter_send;
			end
			enter_send:
			begin
				state<=idle_s;
			end
		endcase
	end
end

//MP
assign my_turn = (state == mymove_start) && (!time_expire);

always @ (posedge clk)
begin
	if(rst)begin	my_move<=1'b0; end
	else
	begin
		if(state == idle_s)begin my_move<=1'b0; end
		if(direction_valid && state==my_move_waiting)
		begin
			direction<=direction_in;
			my_move<=my_move_in;
		end
	end
end


//Memory_handler
always @ (posedge clk)
begin
	if(rst)begin direction_valid_out<=1'b0; end
	else
	begin
		if(state == idle_s)begin direction_valid_out<=1'b0; end
		if(state == enemy_move_waiting && Rxd_data_opponent_valid )
		begin
			direction_out<=RxD_data_opponent-8'd48;//**************************************
			direction_valid_out<=1'b1;
		end
		if(state==enemy_move_update && update_done )begin direction_valid_out<=1'b0; end
	//	if((state == send_update) && !update_done)begin direction_out<=direction; direction_valid_out<=1'b1;end //******************
		if((state == my_move_waiting) && direction_valid)begin direction_out<=direction_in; direction_valid_out<=1'b1;end
	//	else if((state == send_update) && update_done)begin direction_valid_out<=1'b0; end///////////*************************************
		else if(state == send_update)begin direction_valid_out<=1'b0; end
	end
end

//Timer
always @ (posedge clk)
begin	
	if(rst)begin start<=1'b0; timer_rst<=1'b0; end
	else
	begin
		if(state == idle_s)begin start<=1'b0; timer_rst<=1'b0; end
		if(me_game_start)begin start<=1'b1; end
		if(state == finish_mymove)begin timer_rst<=1'b1; end
	end
end



//Buffer
localparam crushe=8'b01111011;
localparam crushe_baste=8'b01111101;
localparam enter=8'b00001010;
always @ (posedge clk)
begin
	if(rst)begin wr_en<=1'b0; end
	else
	begin
		if(state == idle_s)begin wr_en<=1'b0; end
		if((state==enemy_move_waiting) && me_game_start)begin  wr_en<=1'b1; buf_in<=crushe; end
		if(state==my_move_s)begin  wr_en<=1'b0; end
		if(state ==my_move_waiting && direction_valid)begin wr_en<=1'b1; buf_in<=direction_in +8'd48;  end//*****************
		if(state == send_update)begin wr_en<=1'b0; end
		if(state == finish_mymove)begin wr_en<=1'b1; buf_in<=crushe_baste; end
		if(state == enter_send)begin  buf_in<=enter; end
	end
end





endmodule