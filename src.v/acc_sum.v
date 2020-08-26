module acc_sum(
    clk,
    rst,
    ena,
    data,
    accum
);

input clk;
input rst;
input ena;
input [7:0]data;
output reg [7:0]accum;

always@(posedge clk)
    if(!rst)
        accum <= 8'b0000_0000;
    else if(ena)
        accum <= data;
        
endmodule 