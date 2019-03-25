module Interpreter(
	input              clk,
	input              rst,//not?
	input              RxD_ready,//receive dataValid
	input        [7:0] RxD_data,//receive data
	output   reg [7:0] width,//
	output 	 reg 	 width_valid=0,//
	output   reg [7:0] length,//
	output   reg 	 length_valid=0,//
	output   reg       red=1'b0,//
	output   reg       blue=1'b0,//
	output   reg       color_valid=1'b0,//
	output   reg       me_game_start,//
	output   reg       opponent_game_start=1'b0,//
	output   reg [7:0] RxD_data_Opponent,//
	output 	 reg  new_en_mov=1'b0//            
   );

	localparam W=8'b01110111;
	localparam L=8'b01101100;
	localparam C=8'b01100011;
	localparam R=8'b01110010;
	localparam B=8'b01100010;
	localparam En=8'b00001010;
	localparam OC=8'b01111011;
	localparam CC=8'b01111101;
	

	localparam get_width=0;
	localparam get_w=1;
	localparam width_valid_s=2;
	localparam get_length=3;
	localparam get_l=4;
	localparam length_valid_s=5;
	localparam get_color=6;
	localparam get_c=7;
	localparam get_OC=8;
	localparam enemy_Opp=9;
	localparam get_enemy_move=10;
	localparam new_enemy_move=11;
	localparam get_CC=12;
	localparam my_Opp=13;
	reg [3:0] state=0;

	always @ (posedge clk)
	begin
		if(rst)
		begin
			state<=0;
			width<=0;
			width_valid<=0;
			length<=0;
			length_valid<=0;
			red<=0;
			blue<=0;
			color_valid<=0;
			opponent_game_start<=1'b0;
			new_en_mov<=1'b0;
			me_game_start<=1'b0;
		end
		else
		begin
		case(state)
			get_width:
			begin
				if(RxD_data == W && RxD_ready )
				begin
					state<=get_w;
				end
			end

			get_w:
			begin
				if(RxD_ready )
				begin
					state<=width_valid_s;
					width<=RxD_data;
					width_valid<=1'b1;
				end
			end

			width_valid_s:
			begin
				state<=get_length;
			end

			get_length:
			begin
				if(RxD_data == L && RxD_ready )
				begin
					state<=get_l;
				end
			end

			get_l:
			begin
				if(RxD_ready )
				begin
					state<=length_valid_s;
					length<=RxD_data;
					length_valid<=1'b1;
				end
			end

			length_valid_s:
			begin
				state<=get_color;
			end

		        get_color:
			begin
				if(RxD_data == C && RxD_ready )
				begin
					state<=get_c;
				end
			end

			get_c:
			begin
				if(RxD_ready )
				begin
					state<=get_OC;
					if(RxD_data == R)begin red<=1'b1;blue<=1'b0; end
					else if(RxD_data == B)begin blue<=1'b1;red<=1'b0; end
					color_valid<=1'b1;
				end
			end

			get_OC:
			begin
				if(RxD_data == OC && RxD_ready )
				begin
					state<=enemy_Opp;
					opponent_game_start<=1'b1;
				end
			end

			enemy_Opp:
			begin
				state<=get_enemy_move;
				opponent_game_start<=1'b0;
			end

			get_enemy_move:
			begin
				if(RxD_data == CC && RxD_ready )
				begin
					state<=get_CC;
					me_game_start<=1'b1;
					
				end
				else if(RxD_ready)
				begin
					state<=new_enemy_move;
					new_en_mov<=1'b1;
					RxD_data_Opponent<=RxD_data;
					
				end	
			end
			
			new_enemy_move:
			begin
				state<=get_enemy_move;
				new_en_mov<=1'b0;
			end
			get_CC:
			begin
				state<=my_Opp;
				me_game_start<=1'b0;
			end
			
			
			my_Opp:
			begin
				state<=get_OC;
			end
		endcase
		end
	end

endmodule