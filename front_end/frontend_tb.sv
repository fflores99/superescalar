`timescale 1ns/10ps
module frontend_tb ();
    
wire [31:0] pmem_add;
wire [127:0] pmem_data;
reg clk, rst;

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

rom #(
    .SIZE(256)
) 
PMEM 
(
    .address({16'd0,pmem_add[15:0]}),
    .data(pmem_data)
);

frontend_cluster FRONT_END (
    .clk(clk),
    .rst(rst),
    /*Memory Interface*/
    .d_valid(1'b1),
    .mem_data(pmem_data),
    .abort(),
    .m_rd_en(),
    .mem_addr(pmem_add),
    /*Backend interface*/
    .queue_bus(queue_bus), /*Common signasl to queues*/
    .int_queue_en(int_queue_en),
    .disp_imm(disp_imm),
    .disp_pc(disp_pc),
    .opcode(opcode),
    .funct7(funct7),
    .mult_queue_en(mult_queue_en),
    .div_queue_en(div_queue_en),
    .mem_queue_en(mem_queue_en),
    /*Backend return*/
    .cdb(cdb)
);

frontend_bfm BMF (
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
    @(posedge clk);
    rst = 1'b0;
end

always
begin
    #5 clk = ~clk;
end

endmodule