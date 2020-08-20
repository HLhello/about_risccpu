`timescale 1ms/1ns
module alu(
    clk,
    alu_ena,
    opcode,
    accum,
    data,
    zero,
    alu_out
);
/*
 * 1. HLT：停机操作，该操作将空一个指令周期，即8个时钟周期
 * 2. LDA：读数据，该操作将指令中给出地址的数据放入累加器
 * 3. STO：写数据，该操作将累加器中的数据放入指令中给出的地址
 * 4. SKZ：为0跳过下一条语句，该操作先判断当前的ALU中的结果是否为0，为0跳过下一条语句，否则继续执行
 * 5. JMP：无条件跳转语句，该操作将跳转至指令给出的目的地址，继续执行
 * 6. ADD：相加，该操作将累加器中的值与地址所指的存储器或端口的数据相加，结果仍送回累加器中
 * 7. AND：相与，该操作将累加器中的值与地址所指的存储器或端口的数据相与，结果仍送回累加器中
 * 8. XOR：相异或，该操作将累加器中的值与地址所指的存储器或端口的数据相异或，结果仍送回累加器中
 */

parameter   HLT = 8'b000,
            LDA = 8'b101,
            STO = 8'b110,
            SKZ = 8'b001,
            JMP = 8'b111,
            ADD = 8'b010,
            AND = 8'b011,
            XOR = 8'b100;

input clk;
input alu_ena;
input [7:0]opcode;
input [7:0]accum;
input [7:0]data;
output zero;
output reg [7:0]alu_out;

assign zero = !accum;

always@(posedge clk)
    if(alu_ena)
        begin
            casex(opcode)
                HLT: alu_out <= accum;
                LDA: alu_out <= data;
                STO: alu_out <= accum;
                SKZ: alu_out <= accum;
                JMP: alu_out <= accum;
                ADD: alu_out <= data + accum;
                AND: alu_out <= data & accum;
                XOR: alu_out <= data ^ accum;
            default: alu_out <= 8'bxxxx_xxxx;
            endcase
        end

        

endmodule 