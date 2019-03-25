 //M1: UART....general
 module M1_UART(
	input        clk,
	input        rst,
	input        TxD_start,//start bit: 1 bit
	input  [7:0] TxD_data,
	output       TxD_busy,
	output       TxD,//stop bit: 2 bits
	input        RxD,//start bit: 1 bit
	output       RxD_data_ready,//valid data
	output [7:0] RxD_data,
	output       RxD_endofpacket,//stop bit: 2 bits
	output       RxD_idle
	
   );
	
	//wire [7:0] RxD_data;
	async_receiver receiver_module (
		.clk(clk),
		.rst(rst),
		.RxD(RxD),//start_bit: 1 bit
		.BaudSelect(2'b11),//baudrate: 115200 b/s
		.RxD_data_ready(RxD_data_ready),//valid_data
		.RxD_data(RxD_data),//data[7:0]
		.RxD_endofpacket(RxD_endofpacket),//stop_bit: 2 bits
		.RxD_idle(RxD_idle)
   );
	
	async_transmitter transmitter_module (
		.clk(clk),
		.rst(rst),
		.TxD_start(TxD_start),//start_bit: 1 bit
		.BaudSelect(2'b11),//baudrate: 115200 b/s
		.TxD_data(TxD_data),//data[7:0]
		.TxD(TxD),//stop_bit: 2 bits
		.TxD_busy(TxD_busy)
   );

endmodule
///////////////////////////////////////////////////////////
 //UART....I(transmitter) transmit for Referee....I(receiver) get from the Referee  
 /*uart uart_ins (
		.clk(clk_50M),
		.rst(rst),
		.RxD(RxD),//input
		.RxD_data_ready(RxD_ready),//input_dataValid
		.RxD_data(RxD_data),//input_data[7:0]
		.RxD_endofpacket(RxD_endofpacket),//input
		.RxD_idle(RxD_idle),//input
		.TxD_start(TxD_start),//output
		.TxD_data(TxD_data),//output_data[7:0]
		.TxD(TxD),//output
		.TxD_busy(TxD_busy)//output
	            );*/
////////////////////////////////////////////////////////////