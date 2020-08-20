module ram(
    addr,
    ena,
    data,
    read,
    write
);

input addr;
input ena;
input read,
input write

inout data,

reg [7:0]xram[10'h3ff:0];

assign data (read && ena) ? xram[addr] : 8'hzz;

always@(posedge write)
    xram[addr]  <= data;
    
endmodule