`timescale 1ns/1ns
module inst_reg(
    clk,
    rst,
    ena,
    data,
    opc_iraddr
);

input clk;
input rst;
input ena;
input [7:0]data;
output reg [15:0]opc_iraddr;

reg state;

always@(posedge clk)
    if(!rst)
        begin
            state <= 1'b0;
            opc_iraddr <= 16'h0000;
        end
    else begin 
        if(ena) 
            begin 
                casex(state)
                    1'b0: begin state <= 1'b1; opc_iraddr[15:8] <= data;end
                    1'b1: begin state <= 1'b0; opc_iraddr[7 :0] <= data;end                
                 default: begin state <= 1'bx; opc_iraddr <= 16'hxxxx;end
                endcase 
            end
        else
            state <= 1'b0;
    end


endmodule 



