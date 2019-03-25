// RS-232 TX module

module async_transmitter(
	input clk,
	input rst,
	input TxD_start,
	input [7:0] TxD_data,
	input [1:0] BaudSelect,
	output reg TxD,
	output TxD_busy
	);
	
	parameter ClkFrequency = 24_000_000;  // 24MHz_xillinx_spartan6_lx9
	//parameter ClkFrequency = 50000000;  // 24MHz_altera_cyclone4
	parameter Baud_0 = 1200;
	parameter Baud_1 = 9600;
	parameter Baud_2 = 38400;
	parameter Baud_3 = 115200;
	parameter RegisterInputData = 1;	// in RegisterInputData mode, the input doesn't have to stay valid while the character is been transmitted
	parameter BaudGeneratorAccWidth = 16;
	parameter BaudGeneratorInc_0 = ( (Baud_0 << (BaudGeneratorAccWidth-4)) + (ClkFrequency>>5) ) / (ClkFrequency>>4);
	parameter BaudGeneratorInc_1 = ( (Baud_1 << (BaudGeneratorAccWidth-4)) + (ClkFrequency>>5) ) / (ClkFrequency>>4);
	parameter BaudGeneratorInc_2 = ( (Baud_2 << (BaudGeneratorAccWidth-4)) + (ClkFrequency>>5) ) / (ClkFrequency>>4);
	parameter BaudGeneratorInc_3 = ( (Baud_3 << (BaudGeneratorAccWidth-4)) + (ClkFrequency>>5) ) / (ClkFrequency>>4);

	reg [BaudGeneratorAccWidth:0] BaudGeneratorAcc;
	reg [3:0] state;
	reg [7:0] TxD_dataReg;
	reg muxbit;

	wire [BaudGeneratorAccWidth:0] BaudGeneratorInc;
	wire BaudTick;
	wire TxD_ready;
	wire [7:0] TxD_dataD;
	
// Baud generator
	assign BaudGeneratorInc = (BaudSelect==2'b00) ? BaudGeneratorInc_0 :
		                      (BaudSelect==2'b01) ? BaudGeneratorInc_1 :
		                      (BaudSelect==2'b10) ? BaudGeneratorInc_2 : BaudGeneratorInc_3;

	always @(posedge clk)
		if(TxD_busy) 
		    BaudGeneratorAcc <= BaudGeneratorAcc[BaudGeneratorAccWidth-1:0] + BaudGeneratorInc;

	assign BaudTick = BaudGeneratorAcc[BaudGeneratorAccWidth];

// Transmitter state machine
	assign TxD_ready = (state==0);
	assign TxD_busy = ~TxD_ready;

	always @(posedge clk)
		if(TxD_ready & TxD_start) 
		      TxD_dataReg <= TxD_data;
	
	assign TxD_dataD = RegisterInputData ? TxD_dataReg : TxD_data;

	always @(posedge clk)
	  if(rst) 
		   state <= 4'b0000;
	  else 
		case(state)
			4'b0000: if(TxD_start) state <= 4'b0001;
			4'b0001: if(BaudTick) state <= 4'b0100;
			4'b0100: if(BaudTick) state <= 4'b1000;  // start
			4'b1000: if(BaudTick) state <= 4'b1001;  // bit 0
			4'b1001: if(BaudTick) state <= 4'b1010;  // bit 1
			4'b1010: if(BaudTick) state <= 4'b1011;  // bit 2
			4'b1011: if(BaudTick) state <= 4'b1100;  // bit 3
			4'b1100: if(BaudTick) state <= 4'b1101;  // bit 4
			4'b1101: if(BaudTick) state <= 4'b1110;  // bit 5
			4'b1110: if(BaudTick) state <= 4'b1111;  // bit 6
			4'b1111: if(BaudTick) state <= 4'b0010;  // bit 7
			4'b0010: if(BaudTick) state <= 4'b0000;  // stop bit
			default: if(BaudTick) state <= 4'b0000;
		endcase

// Output mux
	always @( * )
		case(state[2:0])
			3'd0: muxbit <= TxD_dataD[0];
			3'd1: muxbit <= TxD_dataD[1];
			3'd2: muxbit <= TxD_dataD[2];
			3'd3: muxbit <= TxD_dataD[3];
			3'd4: muxbit <= TxD_dataD[4];
			3'd5: muxbit <= TxD_dataD[5];
			3'd6: muxbit <= TxD_dataD[6];
			3'd7: muxbit <= TxD_dataD[7];
		endcase

// Put together the start, data and stop bits
	always @(posedge clk) 
	      TxD <= (state<4) | (state[3] & muxbit);  // register the output to make it glitch free

endmodule
