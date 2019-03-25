`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:33:40 11/15/2017 
// Design Name: 
// Module Name:    single_ram 
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
module ram_single(q, a, d, we, clk);
   output reg[7:0] q;
   input [7:0] d;
   input [15:0] a;
   input we, clk;
   reg [7:0] mem [65025:0];
    always @(posedge clk) begin
        if (we)
		  begin
            mem[a] <= d;
			end
        q <= mem[a];
   end
endmodule
