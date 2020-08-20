module addr_decode(
    addr,
    rom_sel,
    ram_sel
);

input [12:0]addr;
output rom_sel;
output ram_sel;

always@(addr)
    casex(addr)
        13'b11_xxx_xxxx_xxxx: {rom_sel, ram_sel} <= 2'b01;
        13'b0x_xxx_xxxx_xxxx: {rom_sel, ram_sel} <= 2'b10;
        13'b10_xxx_xxxx_xxxx: {rom_sel, ram_sel} <= 2'b10;
    endcase 


endmodule