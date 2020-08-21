`timescale 1ns/1ns
`define clk_period 10

module cpu_top();

reg clk;
reg rst;

cpu u_cpu(
    .clk(clk),
    .rst(rst),
    .halt(halt),
    .rd(rd),
    .wr(wr),
    .addr(addr),
    .data(data),
    .fetch(fetch),
    .opcode(opcode),
    .ir_addr(ir_addr),
    .pc_addr(pc_addr)
);

ram u_ram(
    addr(addr[9:0]),
    ena(ram_sel),
    data(data),
    read(rd),
    write(wr)
);

rom u_rom(
    read(rd),
    ena(rom_sel),
    addr(addr),
    data(data)
);

addr_decode u_addr_decode(
    .addr(addr),
    .rom_sel(rom_sel),
    .ram_sel(ram_sel)
);

endmodule 
