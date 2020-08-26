module data_ctrl(
    ena,
    data_in,
    data
);
input ena;
input [7:0]data_in;
output [7:0]data;

assign data = ena ? data_in : 8'bxxxx_xxxx;

endmodule 
