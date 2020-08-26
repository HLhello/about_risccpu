module cpu(
    clk,
    rst,
    halt,
    rd,
    wr,
    addr,
    data,
    fetch,
    opcode,
    ir_addr,
    pc_addr
);

input clk;
input rst;

output halt;
output rd;
output wr;
output [12:0]addr;
inout [7:0]data;

output fetch;
output [2:0]opcode;
output [12:0]ir_addr;
output [12:0]pc_addr;

wire fetch;
wire alu_ena;
wire load_ir;
wire load_acc;
wire [7:0]alu_out;
wire [7:0]accum;
wire zero;
wire load_pc;
wire data_ena;
wire contr_ena;
wire inc_pc;

clk_gen clk_gen(
    .clk(clk),
    .rst(rst),
    .fetch(fetch),
    .alu_ena(alu_ena)
);

inst_reg inst_reg(
    .clk(clk),
    .rst(rst),
    .ena(load_ir),
    .data(data),
    .opc_iraddr({opcode,ir_addr})
);

acc_sum acc_sum(
    .clk(clk),
    .rst(rst),
    .ena(load_acc),
    .data(alu_out),
    .accum(accum)
);

alu alu(
    .clk(clk),
    .ena(alu_ena),
    .opcode(opcode),
    .accum(accum),
    .data(data),
    .zero(zero),
    .alu_out(alu_out)
);

data_ctrl data_ctrl(
    .ena(data_ena),
    .data_in(alu_out),
    .data(data)
);

addr_fetch addr_fetch(
    .fetch(fetch),
    .pc_addr(pc_addr),
    .ir_addr(ir_addr),
    .addr(addr)
);

cnt cnt(
    .clk(inc_pc),
    .rst(rst),
    .load(load_pc),
    .pc_addr(pc_addr),
    .ir_addr(ir_addr)
);

machine_ctrl machine_ctrl(
    .clk(clk),
    .rst(rst),
    .fetch(fetch),
    .ena(contr_ena)
);

machine machine(
    .clk(clk),
    .ena(contr_ena),
    .zero(zero),
    .opcode(opcode),
    .data_ena(data_ena),
    .halt(halt),
    .inc_pc(inc_pc),
    .rd(rd),
    .wr(wr),
    .load_acc(load_acc),
    .load_pc(load_pc),
    .load_ir(load_ir)
);


endmodule 