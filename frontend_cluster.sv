module frontend_cluster(
    input clk,
    input rst,
    /*Memory Interface*/
    input d_valid,
    input [127:0] mem_data,
    output abort,
    output m_rd_en,
    output [31:0] mem_addr,
    /*Backend interface*/
    queue_cmn_bus queue_bus, /*Common signasl to queues*/
    /*Integer queue*/
    output int_queue_en,
    output disp_imm,
    output [31:0] disp_pc,
    output [6:0] opcode,
    output [6:0] funct7,
    /*Multiplication queue*/
    output mult_queue_en,
    /*Division queue*/
    output div_queue_en,
    /*Memory queue*/
    output mem_queue_en,
    /*Backend return*/
    cdb_bus cdb
);

/*Dispatch IF*/
wire jump_branch_valid;
wire [31:0] jump_branch_add;
wire d_rd_en;
wire empty;
wire [31:0] i_code;
wire [31:0] pc_out;

ifq IFQ (
    .clk(clk),
    .rst(rst),
    /*Program Memory Interface*/
    .d_valid(d_valid),
    .mem_data(mem_data),
    .abort(abort),
    .m_rd_en(m_rd_en),
    .mem_addr(mem_addr),
    /*Dispatch Interface*/
    .jump_branch_valid(jump_branch_valid),
    .jump_branch_add(jump_branch_add),
    .d_rd_en(d_rd_en),
    .empty(empty),
    .i_code(i_code),
    .pc_out(pc_out)
);

dispatch_unit DISP (
    .clk(clk),
    .rst(rst),
    .ifq_icode(i_code),
    .ifq_pc(pc_out),
    .ifq_empty(empty),
    .dispatch_rd(d_rd_en),
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

endmodule