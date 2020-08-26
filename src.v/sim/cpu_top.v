`timescale 1ns/100ps
`define clk_period 100

module cpu_top;

reg clk;
reg rst;
wire halt;
wire rd, wr;
wire [12:0]addr;
wire [7:0]data;
wire fetch;
wire [2:0]opcode;
wire [12:0]ir_addr;
wire [12:0]pc_addr;
wire ram_sel, rom_sel;


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
    .addr(addr[9:0]),
    .ena(ram_sel),
    .data(data),
    .read(rd),
    .write(wr)
);

rom u_rom(
    .read(rd),
    .ena(rom_sel),
    .addr(addr),
    .data(data)
);

addr_decode u_addr_decode(
    .addr(addr),
    .rom_sel(rom_sel),
    .ram_sel(ram_sel)
);

integer test;
reg [23:0]mnemonic;
reg [12:0]PC_addr,IR_addr;

initial clk = 1'b1;
always#(`clk_period/2) clk = ~clk;

initial begin
    $timeformat(-9, 1, "ns", 12);//display time in nanoseconds
    display_debug_message;
    sys_reset;
    test1;
    $stop;
    test2;
    $stop;
    test3;
    $stop;
end

task display_debug_message;
    begin
        $display("\n**************************************************");
        $display("\n*   THE FOLLOWING DEBUG TASK ARE AVAILABLE:    *");
        $display("\n* \"test1\" to load the 1st diagnostic program. *");
        $display("\n* \"test2\" to load the 2nd diagnostic program. *");
        $display("\n* \"test3\" to load the Fibonacci program.      *");
        $display("\n**************************************************");
    end
endtask

task test1;
    begin
        test = 0;
        disable MONITOR;
        $readmemb("test1.pro", u_rom.memory);
        $display("rom loaded successfully");
        $readmemb("test1.dat", u_ram.ram);
        $display("ram loaded successfully");
        #1 test = 1;
        #14800;
        sys_reset;
    end
endtask

task test2;
    begin
        test = 0;
        disable MONITOR;
        $readmemb("test2.pro", u_rom.memory);
        $display("rom loaded successfully");
        $readmemb("test2.dat", u_ram.ram);
        $display("ram loaded successfully");
        #1 test = 2;
        #11600;
        sys_reset;
    end
endtask

task test3;
    begin
        test = 0;
        disable MONITOR;
        $readmemb("test3.pro", u_rom.memory);
        $display("rom loaded successfully");
        $readmemb("test3.dat", u_ram.ram);
        $display("ram loaded successfully");
        #1 test = 3;
        #94000;
        sys_reset;
    end
endtask

task sys_reset;
    begin
        rst= 1;
        #(`clk_period*0.7)rst = 0;
        #(`clk_period*1.5)rst = 1;
    end
endtask

always@(test)
    begin: MONITOR
        case(test)
            1 : begin 
                    $display("\nRUNING CPUtest1 - The Basic CPU Diagnostic Program");
                    $display("      TIME      PC    INSTR  ADDR   DATA");
                    $display("  ----------   ----   ---    ----   --");
                    while(test == 1)
                        @(u_cpu.pc_addr)
                        if ( (u_cpu.pc_addr%2==1)&&(u_cpu.fetch==1) )
                            begin
                                #60 PC_addr <= u_cpu.pc_addr-1;
                                    IR_addr <= u_cpu.ir_addr;
                                #340 $strobe("%t,  %h,  %s,   %h,  %h", $time, PC_addr, mnemonic, IR_addr, data);
                            end
                end
            2 : begin 
                    $display("\nRUNING CPUtest2 - The Advanced CPU Diagnostic Program");
                    $display("      TIME      PC    INSTR  ADDR   DATA");
                    $display("  ----------   ----   ---    ----   --");
                    while(test == 2)
                        @(u_cpu.pc_addr)
                        if ( (u_cpu.pc_addr%2==1)&&(u_cpu.fetch==1) )
                            begin
                                #60 PC_addr <= u_cpu.pc_addr-1;
                                    IR_addr <= u_cpu.ir_addr;
                                #340 $strobe("%t,  %h,  %s,   %h,  %h", $time, PC_addr, mnemonic, IR_addr, data);
                            end
                end
            3 : begin 
                    $display("\n** RUNING CPUtest3 - An Executable Program     **");
                    $display("** This program should calculate the fibonacci **");
                    $display("   TIME      FIBONACCI");
                    $display("----------   ---------");
                    while(test == 3)
                        begin
                            wait(u_cpu.opcode == 3'h1)
                            $strobe("%t, %d", $time, u_ram.ram[10'h2]);
                            wait(u_cpu.opcode != 3'h1);
                        end
                end
        endcase
    end

always@(posedge halt)
    begin
        #500
        $display("\n****************************************");
        $display("\n* A HALT INSTRUCTION WAS PROCESSED !!! *");
        $display("\n****************************************");
    end
    
always@(u_cpu.opcode)
    case(u_cpu.opcode)
        3'b000: mnemonic = "HLT";
        3'b001: mnemonic = "SKZ";
        3'b010: mnemonic = "ADD";
        3'b011: mnemonic = "AND";
        3'b100: mnemonic = "XOR";
        3'b101: mnemonic = "LDA";
        3'b110: mnemonic = "STO";
        3'b111: mnemonic = "JMP";
       default: mnemonic = "???";
    endcase
    
endmodule 
