module data_ctrl(
    data_ena,
    data_in,
    data
);
input data_ena;
input [7:0]data_in;
output [7:0]data;

assign data = data_ena ? data_in : 8'bxxxx_xxxx;

endmodule 
