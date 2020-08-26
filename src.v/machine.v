module machine(
    clk,
    ena,
    zero,
    opcode,
    data_ena,
    halt,
    inc_pc,
    rd,
    wr,
    load_acc,
    load_pc,
    load_ir
);

parameter   HLT = 8'b000,
            LDA = 8'b101,
            STO = 8'b110,
            SKZ = 8'b001,
            JMP = 8'b111,
            ADD = 8'b010,
            AND = 8'b011,
            XOR = 8'b100;

input clk;
input ena;
input zero;
input [2:0]opcode;
output reg data_ena;
output reg halt;
output reg inc_pc;
output reg rd, wr;
output reg load_acc;
output reg load_pc;
output reg load_ir;

reg [2:0]state;

always@(negedge clk)
    if(!ena)
        begin
            state <= 3'b000;
            {inc_pc, load_acc, load_pc, rd}   <= 4'b0000;
            {wr, load_ir, data_ena, halt} <= 4'b0000;
        end
    else 
        ctrl_cycle;
        
task ctrl_cycle;
    begin
        casex(state)
            3'b000: begin //load high 8bits instruction 
                        state <= 3'b001;
                        {inc_pc, load_acc, load_pc, rd}   <= 4'b0001;
                        {wr, load_ir, data_ena, halt} <= 4'b0100;
                    end
            3'b001: begin //pc increased by one then load low 8bits instruction 
                        state <= 3'b010;
                        {inc_pc, load_acc, load_pc, rd}   <= 4'b1001;
                        {wr, load_ir, data_ena, halt} <= 4'b0100;
                    end
            3'b010: begin //idle
                        state <= 3'b011;
                        {inc_pc, load_acc, load_pc, rd}   <= 4'b0000;
                        {wr, load_ir, data_ena, halt} <= 4'b0000;
                    end
            3'b011: begin //next instruction address setup
                        state <= 3'b100;
                        if(opcode == HLT)
                            begin 
                                {inc_pc, load_acc, load_pc, rd}   <= 4'b1000;
                                {wr, load_ir, data_ena, halt} <= 4'b0001;
                            end
                        else 
                            begin 
                                {inc_pc, load_acc, load_pc, rd}   <= 4'b1000;
                                {wr, load_ir, data_ena, halt} <= 4'b0000;
                            end
                    end
            3'b100: begin //fetch oprand
                        state <= 3'b101;
                        if(opcode == JMP)
                            begin 
                                {inc_pc, load_acc, load_pc, rd}   <= 4'b0010;
                                {wr, load_ir, data_ena, halt} <= 4'b0000;
                            end
                        else if(opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA)
                            begin 
                                {inc_pc, load_acc, load_pc, rd}   <= 4'b0001;
                                {wr, load_ir, data_ena, halt} <= 4'b0000;
                            end
                        else if(opcode == STO)
                            begin 
                                {inc_pc, load_acc, load_pc, rd}   <= 4'b0000;
                                {wr, load_ir, data_ena, halt} <= 4'b0010;
                            end
                        else 
                            begin 
                                {inc_pc, load_acc, load_pc, rd}   <= 4'b0000;
                                {wr, load_ir, data_ena, halt} <= 4'b0000;
                            end
                    end
            3'b101: begin //operation 
                        state <= 3'b110;
                        if(opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA)
                            begin 
                                {inc_pc, load_acc, load_pc, rd}   <= 4'b0101;
                                {wr, load_ir, data_ena, halt} <= 4'b0000;
                            end
                        else if(opcode == SKZ && zero == 1'b1)
                            begin 
                                {inc_pc, load_acc, load_pc, rd}   <= 4'b1000;
                                {wr, load_ir, data_ena, halt} <= 4'b0000;
                            end
                        else if(opcode == JMP)
                            begin 
                                {inc_pc, load_acc, load_pc, rd}   <= 4'b1010;
                                {wr, load_ir, data_ena, halt} <= 4'b0000;
                            end
                        else if(opcode == STO)
                            begin 
                                {inc_pc, load_acc, load_pc, rd}   <= 4'b0000;
                                {wr, load_ir, data_ena, halt} <= 4'b1010;
                            end
                        else 
                            begin 
                                {inc_pc, load_acc, load_pc, rd}   <= 4'b0000;
                                {wr, load_ir, data_ena, halt} <= 4'b0000;
                            end
                    end
            3'b110: begin 
                        state = 3'b111;
                        if(opcode == STO)
                            begin 
                                {inc_pc, load_acc, load_pc, rd}   <= 4'b0000;
                                {wr, load_ir, data_ena, halt} <= 4'b0010;
                            end
                        else if(opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA)
                            begin 
                                {inc_pc, load_acc, load_pc, rd}   <= 4'b0001;
                                {wr, load_ir, data_ena, halt} <= 4'b0000;
                            end
                        else 
                            begin 
                                {inc_pc, load_acc, load_pc, rd}   <= 4'b0000;
                                {wr, load_ir, data_ena, halt} <= 4'b0000;
                            end
                    end
            3'b111: begin 
                        state <= 3'b000;
                        if(opcode == SKZ && zero == 1'b1)
                            begin 
                                {inc_pc, load_acc, load_pc, rd}   <= 4'b1000;
                                {wr, load_ir, data_ena, halt} <= 4'b0000;
                            end
                        else 
                            begin 
                                {inc_pc, load_acc, load_pc, rd}   <= 4'b0000;
                                {wr, load_ir, data_ena, halt} <= 4'b0000;
                            end
                    end
           default: begin 
                        state <= 3'b000;
                        {inc_pc, load_acc, load_pc, rd}   <= 4'b0000;
                        {wr, load_ir, data_ena, halt} <= 4'b0000;
                    end
        endcase 
    end
endtask

endmodule