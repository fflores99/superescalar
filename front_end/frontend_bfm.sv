`timescale 1ns/10ps
module frontend_bfm (
    input clk,
    input rst,
    cdb_bus cdb,
    queue_cmn_bus queue_bus,
    /*Integer queue*/
    input int_queue_en,
    input disp_imm,
    input [31:0] disp_pc,
    input [6:0] opcode,
    input [6:0] funct7,
    /*Multiplication queue*/
    input mult_queue_en,
    /*Division queue*/
    input div_queue_en,
    /*Memory queue*/
    input mem_queue_en
);

typedef struct packed {
    logic [5:0] tag;
    logic valid;
    logic [31:0] data;
    logic branch;
    logic branch_taken;
    logic jalr;
} cdb_reg_t;

typedef struct packed {
    logic [31:0] rs1_data;
    logic [5:0] rs1_tag;
    logic rs1_data_valid;
    logic [31:0] rs2_data;
    logic [5:0] rs2_tag;
    logic rs2_data_valid;
    logic [6:0] rd_token;
    logic [2:0] funct3;
} queue_reg_t;

cdb_reg_t cdb_reg[32];

logic [1:0] queue_branch[32];

queue_reg_t queues_reg[32];

logic [4:0] cdb_count, queue_count, cdb_read_count;

always begin
integer i;
    @(posedge clk);
    if(!rst) begin
        if(mem_queue_en | div_queue_en | mult_queue_en | int_queue_en)
        begin
            if(queue_bus.rs1_data_valid == 1'b1 && queue_bus.rs2_data_valid == 1'b1) begin
                /*No dependency*/
                cdb_reg[cdb_count].tag = queue_bus.rd_token[5:0];
                cdb_reg[cdb_count].valid = (queue_bus.rd_token[6]);
                cdb_reg[cdb_count].branch = (opcode == 7'b1100011) ? 1'b1: 1'b0;
                cdb_reg[cdb_count].branch_taken = (queue_bus.rs1_data == queue_bus.rs1_data && opcode == 7'b1100011) ? 1'b1: 1'b0; /*Always BEQ*/
                cdb_reg[cdb_count].data = (disp_pc);
                cdb_count = cdb_count + 1;
            end 
            else begin
                /*Dependency*/
                queues_reg[queue_count].rs1_data = queue_bus.rs1_data;
                queues_reg[queue_count].rs1_tag = queue_bus.rs1_tag;
                queues_reg[queue_count].rs1_data_valid = queue_bus.rs1_data_valid;
                queues_reg[queue_count].rs2_data = (disp_pc);
                queues_reg[queue_count].rs2_tag = queue_bus.rs2_tag;
                queues_reg[queue_count].rs2_data_valid = queue_bus.rs2_data_valid;
                queues_reg[queue_count].rd_token = queue_bus.rd_token;
                queues_reg[queue_count].funct3 = queue_bus.funct3;
                queue_branch[queue_count][1] = (opcode == 7'b1100011) ? 1'b1: 1'b0;
                queue_branch[queue_count][0] = (queue_bus.rs1_data == queue_bus.rs2_data && opcode == 7'b1100011) ? 1'b1: 1'b0;
                queue_count = queue_count + 1;
            end
        end
        for(i=0;i<32;i+=1) begin /*Checks if a instruction can be pulled from the queue*/
            if((queues_reg[i].rs1_data_valid == 1'b1)
            && (queues_reg[i].rs2_data_valid == 1'b1))
            begin
                /*Instruction solved from queue to cdb queue*/
                cdb_reg[cdb_count].tag = queues_reg[i].rd_token[5:0];
                cdb_reg[cdb_count].valid = (queues_reg[i].rd_token[6]);
                cdb_reg[cdb_count].branch = queue_branch[i][1];
                cdb_reg[cdb_count].branch_taken = queue_branch[i][0];
                cdb_reg[cdb_count].data = queues_reg[i].rs2_data;
                queues_reg[i] = 0;
                cdb_count = cdb_count + 1;
            end
            else if(queues_reg[i].rs1_tag == cdb.tag && cdb.valid == 1'b1) begin
                queues_reg[i].rs1_data_valid = 1'b1;
            end
            else if(queues_reg[i].rs2_tag == cdb.tag && cdb.valid == 1'b1) begin
                queues_reg[i].rs2_data_valid = 1'b1;
            end
        end
    end
end

always @(posedge clk) begin
    if(cdb_read_count == cdb_count) begin
        cdb.tag = 0;
        cdb.valid = 0;
        cdb.data = 0;
        cdb.branch = 0;
        cdb.branch_taken = 0;
        cdb.jalr = 0;
    end else begin
        cdb.tag = cdb_reg[cdb_read_count].tag;
        cdb.valid = cdb_reg[cdb_read_count].valid;
        cdb.data = cdb_reg[cdb_read_count].data;
        cdb.branch = cdb_reg[cdb_read_count].branch;
        cdb.branch_taken = cdb_reg[cdb_read_count].branch_taken;
        cdb.jalr = cdb_reg[cdb_read_count].jalr;
        cdb_read_count = cdb_read_count+1;
    end
end

always @(posedge rst ) begin
    integer i;
    for(i=0;i<32;i+=1) begin
        cdb_reg[i] = 0;
        queues_reg[i] = 0;
        queue_branch[i] = 2'b00;
    end
    cdb_count = 5'd4;
    queue_count = 5'd0;
    cdb_read_count = 5'd0;
end


endmodule