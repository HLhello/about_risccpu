`timescale 1ns/1ns
module cnt(
    clk,
    rst,
    load,
    pc_addr,
    ir_addr
);

input clk;
input rst;
input load;
input [12:0]ir_addr;
output reg [12:0]pc_addr;

always@(posedge clk or negedge rst)
    if(!rst)
        pc_addr <= 13'b0_0000_0000_0000;
    else if(load)
        pc_addr <= ir_addr;
    else 
        pc_addr <= pc_addr + 1'b1;
    
endmodule 