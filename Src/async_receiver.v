// RS-232 RX module

module async_receiver(
	input clk,
	input rst,
	input RxD,
	input [1:0] BaudSelect,
	output reg RxD_data_ready,  // one clock pulse when RxD_data is valid
	output reg [7:0] RxD_data,
	output reg RxD_endofpacket,  // one clock pulse, when no more data is received (RxD_idle is going high)
	output RxD_idle  // no data is being received
	);
	
	parameter ClkFrequency = 24_000_000;  // 24MHz_xillinx_spartan6_lx9
	//parameter ClkFrequency = 50000000;  // 50MHz_altera_cyclone4
	parameter Baud_0 = 1200;
	parameter Baud_1 = 9600;
	parameter Baud_2 = 38400;
	parameter Baud_3 = 115200;
	parameter Baud8_0 = Baud_0*8;
	parameter Baud8_1 = Baud_1*8;
	parameter Baud8_2 = Baud_2*8;
	parameter Baud8_3 = Baud_3*8;
	parameter Baud8GeneratorAccWidth = 16;
	parameter Baud8GeneratorInc_0 = ( (Baud8_0 << (Baud8GeneratorAccWidth-7)) + (ClkFrequency>>8) ) / (ClkFrequency>>7);
	parameter Baud8GeneratorInc_1 = ( (Baud8_1 << (Baud8GeneratorAccWidth-7)) + (ClkFrequency>>8) ) / (ClkFrequency>>7);
	parameter Baud8GeneratorInc_2 = ( (Baud8_2 << (Baud8GeneratorAccWidth-7)) + (ClkFrequency>>8) ) / (ClkFrequency>>7);
	parameter Baud8GeneratorInc_3 = ( (Baud8_3 << (Baud8GeneratorAccWidth-7)) + (ClkFrequency>>8) ) / (ClkFrequency>>7);

	reg [Baud8GeneratorAccWidth:0] Baud8GeneratorAcc;
	reg [1:0] RxD_sync_inv;
	reg [1:0] RxD_cnt_inv;
	reg RxD_bit_inv;
	reg [3:0] state;
	reg [3:0] bit_spacing;
	reg RxD_data_error;
	reg [4:0] gap_count;
	
	wire [Baud8GeneratorAccWidth:0] Baud8GeneratorInc;
	wire Baud8Tick;
	wire next_bit;
	
/* We also detect if a gap occurs in the received stream of characters
   That can be useful if multiple characters are sent in burst
   so that multiple characters can be treated as a "packet" */

// Baud generator (we use 8 times oversampling)
	assign Baud8GeneratorInc = (BaudSelect==2'b00) ? Baud8GeneratorInc_0 :
		                       (BaudSelect==2'b01) ? Baud8GeneratorInc_1 :
		                       (BaudSelect==2'b10) ? Baud8GeneratorInc_2 : Baud8GeneratorInc_3;
	
	always @(posedge clk)
		Baud8GeneratorAcc <= Baud8GeneratorAcc[Baud8GeneratorAccWidth-1:0] + Baud8GeneratorInc;
	
	assign Baud8Tick = Baud8GeneratorAcc[Baud8GeneratorAccWidth];

	always @(posedge clk) 
		if(Baud8Tick) 
		     RxD_sync_inv <= {RxD_sync_inv[0], ~RxD};
		
// we invert RxD, so that the idle becomes "0", to prevent a phantom character to be received at startup

	always @(posedge clk)
		if(Baud8Tick) begin
			if(RxD_sync_inv[1] && RxD_cnt_inv!=2'b11) 
			          RxD_cnt_inv <= RxD_cnt_inv + 2'h1;
			else if(~RxD_sync_inv[1] && RxD_cnt_inv!=2'b00) 
			          RxD_cnt_inv <= RxD_cnt_inv - 2'h1;

			if(RxD_cnt_inv==2'b00) 
			     RxD_bit_inv <= 1'b0;
			else if(RxD_cnt_inv==2'b11) 
			     RxD_bit_inv <= 1'b1;
		end

/* "next_bit" controls when the data sampling occurs
   depending on how noisy the RxD is, different values might work better
   with a clean connection, values from 8 to 11 work */

	assign next_bit = (bit_spacing==4'd10);

	always @(posedge clk)
		if(state==0) 
		    bit_spacing <= 4'b0000;
		else if(Baud8Tick) 
		    bit_spacing <= {bit_spacing[2:0] + 4'b0001} | {bit_spacing[3], 3'b000};

	always @(posedge clk)
		if(rst) state <= 4'b0000;
		else if(Baud8Tick)
			case(state)
				4'b0000: if(RxD_bit_inv) state <= 4'b1000;  // start bit found?
				4'b1000: if(next_bit) state <= 4'b1001;  // bit 0
				4'b1001: if(next_bit) state <= 4'b1010;  // bit 1
				4'b1010: if(next_bit) state <= 4'b1011;  // bit 2
				4'b1011: if(next_bit) state <= 4'b1100;  // bit 3
				4'b1100: if(next_bit) state <= 4'b1101;  // bit 4
				4'b1101: if(next_bit) state <= 4'b1110;  // bit 5
				4'b1110: if(next_bit) state <= 4'b1111;  // bit 6
				4'b1111: if(next_bit) state <= 4'b0001;  // bit 7
				4'b0001: if(next_bit) state <= 4'b0000;  // stop bit
				default: state <= 4'b0000;
			endcase

	always @(posedge clk)
		if(Baud8Tick && next_bit && state[3]) 
		        RxD_data <= {~RxD_bit_inv, RxD_data[7:1]};

	always @(posedge clk)
		begin
			RxD_data_ready <= (Baud8Tick && next_bit && state==4'b0001 && ~RxD_bit_inv);  // ready only if the stop bit is received
			RxD_data_error <= (Baud8Tick && next_bit && state==4'b0001 &&  RxD_bit_inv);  // error if the stop bit is not received
		end

	always @(posedge clk)
		if (state!=0) 
		        gap_count<=5'h00; 
		else if(Baud8Tick & ~gap_count[4]) 
		        gap_count <= gap_count + 5'h01;
		
	assign RxD_idle = gap_count[4];
	
	always @(posedge clk) 
	        RxD_endofpacket <= Baud8Tick & (gap_count==5'h0F);

endmodule
