module reservation_reg #(
    parameter imm_en = 1'b1,
    parameter pc_en = 1'b1
)
(
    input clk,
    input rst,
    /*control signals*/
    input we,
    input updt_cmn_block,
    input updt_rs1,
    input updt_rs1_from_cdb,
    input updt_rs2,
    input updt_rs2_from_cdb,
    /*queue bus*/
    queue_cmn_bus queue_bus_in,
    input [31:0] imm,
    input [31:0] pc,
    /*CDB data*/
    input cdb_data_valid,
    input [31:0] cdb_data,
    /*Output*/
    queue_cmn_bus queue_bus_out,
    output [31:0] imm_out,
    output [31:0] pc_out,
    output res_reg_ready
);

wire [31:0] rs1_data_to_reg;
wire rs1_data_valid_to_reg;

wire [31:0] rs2_data_to_reg;
wire rs2_data_valid_to_reg;

assign rs1_data_to_reg = (updt_rs1_from_cdb) ? cdb_data : queue_bus_in.rs1_data;
assign rs1_data_valid_to_reg = (updt_rs1_from_cdb) ? cdb_data_valid : queue_bus_in.rs1_data_valid;

assign rs2_data_to_reg = (updt_rs2_from_cdb) ? cdb_data : queue_bus_in.rs2_data;
assign rs2_data_valid_to_reg = (updt_rs2_from_cdb) ? cdb_data_valid : queue_bus_in.rs2_data_valid;

generate
    if(pc_en)
        reg_param #(
            .LENGTH(32),
            .RESET_VALUE(32'd0)
        )
        PC_REG
        (
            .clk(clk),
            .en(we | updt_cmn_block),
            .rst(rst),
            .DATA_IN(pc),
            .DATA_OUT(pc_out)
        );
    else
        assign pc_out = 32'd0;
endgenerate

generate
    if(imm_en)
        reg_param #(
            .LENGTH(32),
            .RESET_VALUE(32'd0)
        )
        IMM_REG
        (
            .clk(clk),
            .en(we | updt_cmn_block),
            .rst(rst),
            .DATA_IN(imm),
            .DATA_OUT(imm_out)
        );
    else
        assign imm_out = 32'd0;
endgenerate

/*RS1 register*/
reg_param #(
	.LENGTH(32),
	.RESET_VALUE(32'd0)
)
RS1_REG
(
	.clk(clk),
	.en(we | updt_rs1),
	.rst(rst),
	.DATA_IN({rs1_data_to_reg,
            rs1_data_valid_to_reg}),
	.DATA_OUT({queue_bus_out.rs1_data,
            queue_bus_out.rs1_data_valid})
);

/*RS2 register*/
reg_param #(
	.LENGTH(32),
	.RESET_VALUE(32'd0)
)
RS2_REG
(
	.clk(clk),
	.en(we | updt_rs2),
	.rst(rst),
	.DATA_IN({rs2_data_to_reg,
            rs2_data_valid_to_reg}),
	.DATA_OUT({queue_bus_out.rs2_data,
            queue_bus_out.rs2_data_valid})
);

/*Common register*/
reg_param #(
	.LENGTH(36),
	.RESET_VALUE(36'd0)
)
CMN_REG
(
	.clk(clk),
	.en(we | updt_cmn_block),
	.rst(rst),
	.DATA_IN({queue_bus_in.funct3,
            queue_bus_in.funct7,
            queue_bus_in.opcode,
            queue_bus_in.rd_token,
            queue_bus_in.rs2_tag,
            queue_bus_in.rs1_tag}),
	.DATA_OUT({queue_bus_out.funct3,
            queue_bus_out.funct7,
            queue_bus_out.opcode,
            queue_bus_out.rd_token,
            queue_bus_out.rs2_tag,
            queue_bus_out.rs1_tag})
);

/*Ready register*/
reg_param #(
	.LENGTH(1),
	.RESET_VALUE(1'd0)
)
READY_REG
(
	.clk(clk),
	.en(we),
	.rst(rst),
	.DATA_IN(((rs1_data_valid_to_reg & updt_rs1) | queue_bus_out.rs1_data_valid) & ((rs2_data_valid_to_reg & updt_rs2)  | queue_bus_out.rs2_data_valid)),
	.DATA_OUT(res_reg_ready)
);


endmodule