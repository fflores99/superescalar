`timescale 1ns/1ps

module dispatch_unit_tb();

logic [31:0] rom [16];

assign rom[0] = 32'h01400213;
assign rom[1] = 32'h01e00293;
assign rom[2] = 32'h03c00313;
assign rom[3] = 32'h00628233;
assign rom[4] = 32'h06400513;
assign rom[5] = 32'h00626333;
assign rom[6] = 32'h00527433;
assign rom[7] = 32'h00000013;
assign rom[8] = 32'h00000013;
assign rom[9] = 32'h00000013;
assign rom[10] = 32'h00000013;
assign rom[11] = 32'h00000013;
assign rom[12] = 32'h00000013;
assign rom[13] = 32'h00000013;
assign rom[14] = 32'h00000013;
assign rom[15] = 32'h00000013;

reg clk, rst;

reg [31:0] ifq_icode;
reg [31:0] ifq_pc;
reg ifq_empty;

wire dispatch_rd;
wire [31:0] jump_branch_add;
wire jump_branch_valid;

cdb_bus cdb();
queue_cmn_bus queue_bus();

wire int_queue_en;
wire disp_imm;
wire [31:0] disp_pc;
wire [6:0] opcode;
wire [6:0] funct7;
wire mult_queue_en;
wire div_queue_en;
wire mem_queue_en;

dispatch_unit UUT (
    .clk(clk),
    .rst(rst),
    .ifq_icode(ifq_icode),
    .ifq_pc(ifq_pc),
    .ifq_empty(ifq_empty),
    .dispatch_rd(dispatch_rd),
    .jump_branch_add(jump_branch_add),
    .jump_branch_valid(jump_branch_valid),
    .cdb(cdb),
    .queue_bus(queue_bus),
    .int_queue_en(int_queue_en),
    .disp_imm(disp_imm),
    .disp_pc(disp_pc),
    .opcode(opcode),
    .funct7(funct7),
    .mult_queue_en(mult_queue_en),
    .div_queue_en(div_queue_en),
    .mem_queue_en(mem_queue_en)
);

dispatch_unit_bmf BMF (
    .clk(clk),
    .rst(rst),
    .cdb(cdb),
    .queue_bus(queue_bus),
    .int_queue_en(int_queue_en),
    .disp_imm(disp_imm),
    .disp_pc(disp_pc),
    .opcode(opcode),
    .funct7(funct7),
    .mult_queue_en(mult_queue_en),
    .div_queue_en(div_queue_en),
    .mem_queue_en(mem_queue_en)
);

initial
begin
    clk = 1'b0;
    rst = 1'b1;
    ifq_icode = rom[0];
    ifq_pc = 32'h00400000;
    ifq_empty = 1;
    @(posedge clk);
    rst = 1'b0;
    @(posedge clk);
    fifo_not_empty();
end

always
begin
    #5 clk = ~clk;
end

always
begin
    if(ifq_empty)
        @(posedge clk);
    else if(!dispatch_rd)
        @(posedge clk);
    else
        fetched_instruction();
end

integer rom_idx = 0;
task fetched_instruction();
    rom_idx++;
    ifq_icode = rom[rom_idx];
    ifq_pc += 32'h4;
    @(posedge clk);
    
endtask

task fifo_not_empty();
    ifq_empty = 0;
endtask
endmodule