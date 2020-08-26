module ram(
    addr,
    ena,
    data,
    read,
    write
);

input [9:0]addr;
input ena;
input read;
input write;

inout [7:0]data;

reg [7:0]ram[10'h3ff:0];

assign data = (read && ena) ? ram[addr] : 8'hzz;

always@(posedge write)
    ram[addr]  <= data;
    
endmodule