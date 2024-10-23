module dispatch_unit (
    input clk,
    input rst,
    /*IFQ interface*/
    input [31:0] ifq_icode,
    input [31:0] ifq_pc,
    input ifq_empty,
    output dispatch_rd,
    output [31:0] jump_branch_add,
    output jump_branch_valid,
    /*CDB*/
    cdb_bus cdb,
    /*queues*/
    queue_cmn_bus queue_bus,
    /*Integer queue*/
    output int_queue_en,
    output disp_imm,
    output [31:0] disp_pc,
    output [6:0] funct7,
    /*Multiplication queue*/
    output mult_queue_en,
    /*Division queue*/
    output div_queue_en,
    /*Memory queue*/
    output mem_queue_en
);

wire [6:0] opcode,
wire [6:0] funct7,

wire [31:0] IMM;
wire [31:0] JMP_ADD, JMP_OR_BRANCH_ADD, BRANCH_ADD;
/*Instruction formater*/
assign opcode = ifq_icode[6:0];
wire [4:0] rd = ifq_icode[11:7];
wire [2:0] funct3 = ifq_icode[14:12];
wire [4:0] rs1 = ifq_icode[19:15];
wire [4:0] rs2 = ifq_icode[24:20];
assign funct7 = ifq_icode[31:25];
/*Decoder signals*/
wire dec_jmp;
wire dec_reg_write;
wire dec_branch;
wire dec_jalr;
wire dec_int_queue_en;
wire dec_multip_queue_en;
wire dec_div_queue_en;
wire dec_memory_queue_en;
/*staller*/
wire nstall;
/*fifo*/
wire [6:0] rd_token;
/*RST*/
wire [4:0] rf_rd;
wire [5:0] rs1_tag, rs2_tag;
wire rs1_tag_valid, rs2_tag_valid;
wire rf_we;
/*Register File*/
wire [31:0] rf_rs1_data, rf_rs2_data;
wire fw_cdb_rs1, fwd_cdb_rs2;
wire rs1_tag_eq_cdb, rs2_tag_eq_cdb;
/*Zero register bypass*/
wire rd_is_not_zero;

wire branch_add_reg_en;

assign rd_is_not_zero = (rd == 5'd0) ? 1'b0: 1'b1;

/*Immediate generator*/
imm_gen IMM_GEN (
    .inst(ifq_icode),
    .imm(IMM)
);
/*Jump Resolving*/
adder_param #(
    .WIDTH(32)
) 
JMP_ADD_ADDER
(
    .A(ifq_pc),
    .B(IMM),
    .S(JMP_OR_BRANCH_ADD),
    .carry()
);
/* JMP_ADDRESS_MUX
 *
 * SEL = 0, JUMP_BRANCH_ADDR = PC + IMM
 * SEL = 1, JUMP_BRANCH_ADDR = CDB_DATA
*/
mux_param #(
    .WIDTH(32), 
    .N(2)
)
JMP_ADDRESS_MUX
(
    .X('{cdb.data,JMP_ADD}),
    .SEL(cdb.jalr),
    .Y(jump_branch_add)
);



/*Branch Register*/
reg_param #(
	.LENGTH(32),
	.RESET_VALUE(32'h00400000)
)
BRANCH_ADD_REG
(
/*Inputs*/
	/*Control*/
	.clk(clk), /*System Clock*/
	.en(branch_add_reg_en), /*Enable next fetch if ifq not empty or a jump/branch*/
	.rst(rst), /*REset on high*/
	/*Data*/
	.DATA_IN(JMP_OR_BRANCH_ADD), /*Data input of LENGTH bits*/
/*Outputs*/
	.DATA_OUT(BRANCH_ADD) /*Data output of LENGTH bits*/
);

/* JMP_BRANCH
 *
 * SEL = 0, jump_branch_add = PC + IMM
 * SEL = 1, JUMP = CDB_DATA
*/
mux_param #(
    .WIDTH(32), 
    .N(2)
)
JMP_ABRANCH_MUX
(
    .X('{JMP_OR_BRANCH_ADD,BRANCH_ADD}),
    .SEL(dec_jmp),
    .Y(JMP_ADD)
);

/*Instruction decoder*/
inst_decoder DECODER (
.opcode(opcode),
.funct3(funct3),
.funct7(funct7),
.jmp(dec_jmp),
.reg_write(dec_reg_write),
.branch(dec_branch),
.jalr(dec_jalr),
.int_queue_en(dec_int_queue_en),
.multip_queue_en(dec_multip_queue_en),
.div_queue_en(dec_div_queue_en),
.memory_queue_en(dec_memory_queue_en)
);

/*Jump branch valid if jump instruction or branch resolved taken, or jalr solved*/
assign jump_branch_valid = dec_jmp | cdb.jalr | cdb.branch_taken;

/*Staller*/
dispatch_staller STALLER (
    .clk(clk),
    .rst(rst),
    /*FSM inputs*/
    .branch(dec_branch),
    .jalr(dec_jalr),
    .branch_solved(cdb.branch),
    .jalr_solved(cdb.jalr),
    .ifq_empty(ifq_empty),
    .nstall(nstall),
    .branch_add_reg_en(branch_add_reg_en)
);

/**********Register Renaming**********/
/*FIFO*/
assign rd_token[6] = dec_reg_write & nstall & rd_is_not_zero;
tag_fifo #(.SIZE(64)) FIFO (
    .clk(clk),
    .rst(rst),
    /*CDB IF*/
    .tag_in(cdb.tag),
    .tag_push(cdb.valid),
    /*Register Status Table IF*/
    .tag_out(rd_token[5:0]),
    .tag_pull(dec_reg_write & nstall & rd_is_not_zero),
    /*FIFO indicators*/
    .fifo_full(),
    .fifo_empty()
);
/*RST*/

reg_stat_table REG_ST_TBL(
    .clk(clk),
    .rst(rst),
    /*Tag clearing*/
    .cdb_tag(cdb.tag),
    .cdb_valid(cdb.valid),
    .rf_rd(rf_rd),
    .rf_we(rf_we),
    /*Tag reading*/
    .rs1(rs1),
    .rs1_tag(rs1_tag),
    .rs1_tag_valid(rs1_tag_valid),
    .rs2(rs2),
    .rs2_tag(rs2_tag),
    .rs2_tag_valid(rs2_tag_valid),
    /*Tag writing*/
    .rd(rd),
    .rd_tag(rd_token[5:0]),
    .tag_write_en(dec_reg_write & nstall & rd_is_not_zero)
);

/*Register File*/

register_file REG_FILE (
	.clk(clk),
	.rst(rst),
	.we(rf_we),
	.RS1(rs1),
	.RS2(rs2),
	.RD(rf_rd),
	.DATA_IN(cdb.data),
	.RS1_DATA(rf_rs1_data),
	.RS2_DATA(rf_rs2_data)
);

/*sources are going to use cdb data if tags matches and cdb is writting Register File*/
assign rs1_tag_eq_cdb = (rs1_tag == cdb.tag) ? 1'b1 : 1'b0;
assign rs2_tag_eq_cdb = (rs2_tag == cdb.tag) ? 1'b1 : 1'b0;
assign fw_cdb_rs1 = rs1_tag_eq_cdb & rs1_tag_valid & cdb.valid;
assign fw_cdb_rs2 = rs2_tag_eq_cdb & rs2_tag_valid & cdb.valid;
/*Data is being forwarded from CDB is fw bit is on*/
assign queue_bus.rs1_data = (fw_cdb_rs1) ? cdb.data : rf_rs1_data;
assign queue_bus.rs2_data = (fw_cdb_rs2) ? cdb.data : rf_rs2_data;
/*Queues are using data from register file is  tag is invalid or data is being forwarded from cdb*/
assign queue_bus.rs1_data_valid = fw_cdb_rs1 | ~rs1_tag_valid;
assign queue_bus.rs2_data_valid = fw_cdb_rs2 | ~rs2_tag_valid;
/*queue common outputs*/
assign queue_bus.rs1_tag = rs1_tag;
assign queue_bus.rs2_tag = rs2_tag;
assign queue_bus.rd_token = rd_token;
assign queue_bus.opcode = opcode;
assign queue_bus.funct3 = funct3;
assign queue_bus.funct7 = funct7;
/*Other outputs*/
assign disp_imm = IMM;
assign disp_pc  = ifq_pc;
/*queue enable*/
assign int_queue_en  = dec_int_queue_en    & nstall;
assign mult_queue_en = dec_multip_queue_en & nstall;
assign div_queue_en  = dec_div_queue_en    & nstall;
assign mem_queue_en  = dec_memory_queue_en & nstall;
/*IFQ outputs*/
assign dispatch_rd = nstall;

endmodule