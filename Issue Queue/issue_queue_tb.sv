`timescale 1ns/10ps
module issue_queue_tb();


queue_cmn_bus queue_bus(); /*Common signasl to queues*/

reg rst, clk;
reg int_queue_en;
reg [31:0] disp_imm;
reg [31:0] disp_pc;
reg [6:0] opcode;
reg [6:0] funct7;
reg queue_en;
wire queue_full;
    /*Backend return*/
cdb_bus cdb();
    /***Excecution Unit interface***/
wire issue_valid;
    /*from ex_unit*/
reg ex_done;
queue_cmn_bus issue_queue_bus();
wire [31:0] issue_pc;
wire [31:0] issue_imm;

issue_queue #(
    .IMM_EN(1'b1),
    .PC_EN(1'b1)
)
UUT
(
    .rst(rst),
    .clk(clk),
    /***Dispatch interface***/
    /*QUEUE common*/
    .queue_bus(queue_bus), /*Common signasl to queues*/
    /*Integer queue*/
    .int_queue_en(int_queue_en),
    .disp_imm(disp_imm),
    .disp_pc(disp_pc),
    .opcode(opcode),
    .funct7(funct7),
    .queue_en(queue_en),
    .queue_full(queue_full),
    /*Backend return*/
    .cdb(cdb),
    /***Excecution Unit interface***/
    .issue_valid(issue_valid),
    /*from ex_unit*/
    .ex_done(ex_done),
    .issue_queue_bus(issue_queue_bus),
    .issue_pc(issue_pc),
    .issue_imm(issue_imm)
);

initial begin
    rst = 1'b1;
    clk = 1'b0;
    int_queue_en = 1'b0;
    disp_imm = 32'd0;
    disp_pc = 32'd0;
    opcode = 7'd0;
    funct7 = 7'd0;
    queue_en = 1'b0;
    cdb.valid = 1'b0;
    cdb.data = 32'd0;
    cdb.tag = 6'd0;
    cdb.branch = 1'b0;
    cdb.branch_taken = 1'b0;
    cdb.jalr = 1'b0;

    queue_bus.rs1_data = 0;
    queue_bus.rs1_tag = 0;
    queue_bus.rs1_data_valid = 0;
    queue_bus.rs2_data = 0;
    queue_bus.rs2_tag = 0;
    queue_bus.rs2_data_valid = 0;
    queue_bus.rd_token = 0;
    queue_bus.opcode = 0;
    queue_bus.funct7 = 0;
    queue_bus.funct3 = 0;

    ex_done = 1'b0;
end

always begin
    #5 clk = ~clk;
end

always begin
    @(posedge clk);
    rst = 1'b0;
    fill_queue();
    updt_reg(6'd0);
    updt_reg(6'd9);
    updt_reg(6'd1);
    updt_reg(6'd2);
    updt_reg(6'd10);
    updt_reg(6'd3);
    excec_reg();
end

task fill_queue();
    @(posedge clk);
    queue_en = 1'b1;
    queue_bus.rs1_tag = 6'd0;
    queue_bus.rs2_data_valid = 1'b1;
    queue_bus.rd_token = 7'h45;
    @(posedge clk);
    queue_en = 1'b1;
    queue_bus.rs1_tag = 6'd1;
    queue_bus.rs2_data_valid = 1'b1;
    queue_bus.rd_token = 7'h46;
    @(posedge clk);
    /*Non instruction for this queue*/
    queue_en = 1'b0;
    queue_bus.rs1_tag = 6'd1;
    queue_bus.rs2_data_valid = 1'b1;
    queue_bus.rd_token = 7'h46;
    @(posedge clk);
    queue_en = 1'b1;
    queue_bus.rs1_tag = 6'd2;
    queue_bus.rs2_data_valid = 1'b1;
    queue_bus.rd_token = 7'h47;
    @(posedge clk);
    queue_bus.rs1_tag = 6'd3;
    queue_bus.rs2_data_valid = 1'b1;
    queue_bus.rd_token = 7'h48;
    @(posedge clk);
    queue_en = 1'b0;

endtask

task updt_reg(input [5:0] tag);
    @(posedge clk);
    cdb.valid = 1'b1;
    cdb.data = 32'hFFFF5A5A;
    cdb.tag = tag;
endtask

task excec_reg();
    @(posedge clk);
    ex_done = 1'b1;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    ex_done = 1'b0;
endtask

endmodule
