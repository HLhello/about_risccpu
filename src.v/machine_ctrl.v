`timescale 1ns/1ns
module machine_ctrl(
    clk,
    rst,
    fetch,
    ena
);

input clk;
input rst;
input fetch;
output reg ena;

always@(posedge clk)
    if(!rst)
        ena <= 1'b0;
    else if(fetch)
        ena <= 1'b1;

endmodule 