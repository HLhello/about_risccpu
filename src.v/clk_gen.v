`timescale 1ns/1ns
module clk_gen(
    clk,
    rst,
    fetch,
    alu_ena
);

input clk;
input rst;

output reg fetch;
output reg alu_ena;

localparam  s1 = 8'b0000_0001,
            s2 = 8'b0000_0010,
            s3 = 8'b0000_0100,
            s4 = 8'b0000_1000,
            s5 = 8'b0001_0000,
            s6 = 8'b0010_0000,
            s7 = 8'b0100_0000,
            s8 = 8'b1000_0000,
            IDLE = 8'b0000_0000;

reg [7:0]state;

always@(posedge clk)
    if(!rst)
        begin 
            state <= IDLE;
            fetch <= 1'b0;
            alu_ena <= 1'b0;
        end 
    else begin
        case(state)
              IDLE: begin state <= s1; end 
                s1: begin state <= s2; alu_ena <= 1'b1; end
                s2: begin state <= s3; alu_ena <= 1'b0; end
                s3: begin state <= s4; fetch <= 1'b1; end
                s4: begin state <= s5; end
                s5: begin state <= s6; end
                s6: begin state <= s7; end
                s7: begin state <= s8; fetch <= 1'b0;end
                s8: begin state <= s1; end
           default: begin state <= IDLE; end
        endcase 
    end
    
    
endmodule 
            