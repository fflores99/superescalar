module issue_queue #(
    parameter IMM_EN = 1'b1,
    parameter PC_EN = 1'b1
)
(
    input rst,
    input clk,
    /***Dispatch interface***/
    /*QUEUE common*/
    queue_cmn_bus queue_bus, /*Common signasl to queues*/
    /*Integer queue*/
    input int_queue_en,
    input [31:0] disp_imm,
    input [31:0] disp_pc,
    input [6:0] opcode,
    input [6:0] funct7,
    input queue_en,
    output queue_full,
    /*Backend return*/
    cdb_bus cdb,
    /***Excecution Unit interface***/
    output issue_valid,
    /*from ex_unit*/
    input ex_done,
    queue_cmn_bus issue_queue_bus,
    output reg [31:0] issue_pc,
    output reg [31:0] issue_imm
);

/*Barrier for cdb*/

queue_cmn_bus queue_bus_barrier();

queue_cmn_bus queue_bus_reg[4]();

wire [31:0] reg_pc[4], reg_imm[4];

assign queue_bus_barrier.rs1_data       = queue_bus.rs1_data        & {32{queue_en}};
assign queue_bus_barrier.rs1_tag        = queue_bus.rs1_tag         & {6{queue_en}};
assign queue_bus_barrier.rs1_data_valid = queue_bus.rs1_data_valid  & queue_en;
assign queue_bus_barrier.rs2_data       = queue_bus.rs2_data        & {32{queue_en}};
assign queue_bus_barrier.rs2_tag        = queue_bus.rs2_tag         & {6{queue_en}};
assign queue_bus_barrier.rs2_data_valid = queue_bus.rs2_data_valid  & queue_en;
assign queue_bus_barrier.rd_token       = queue_bus.rd_token        & {7{queue_en}};
assign queue_bus_barrier.opcode         = queue_bus.opcode          & {7{queue_en}};
assign queue_bus_barrier.funct7         = queue_bus.funct7          & {7{queue_en}};
assign queue_bus_barrier.funct3         = queue_bus.funct3          & {3{queue_en}};

wire [5:0] rs1_tag[4], rs2_tag[4];
wire rs1_data_valid[4], rs2_data_valid[4], ready[4], valid[4];
wire rs1_updt_en[4];
wire rs1_updt_from_cdb[4];
wire rs2_updt_en[4];
wire rs2_updt_from_cdb[4];
wire updt_cmn[4];
wire reg_we[4];
wire [1:0] output_selector;

assign valid[0] = queue_bus_reg[0].rd_token[6];
assign valid[1] = queue_bus_reg[1].rd_token[6];
assign valid[2] = queue_bus_reg[2].rd_token[6];
assign valid[3] = queue_bus_reg[3].rd_token[6];

genvar j;
generate
 for (j = 0; j < 4; j+=1 ) begin : bus_filling
    assign rs1_tag[j] = queue_bus_reg[j].rs1_tag;
    assign rs1_data_valid[j] = queue_bus_reg[j].rs1_data_valid;
    assign rs2_tag[j] = queue_bus_reg[j].rs2_tag;
    assign rs2_data_valid[j] = queue_bus_reg[j].rs2_data_valid;
 end
endgenerate

/*Control unit*/
issue_ctrl CTRL (
    .rs1_tag(rs1_tag), /*RS1 tag from each register*/
    .rs1_data_valid(rs1_data_valid), /*RS1 data valid from each register*/
    .rs2_tag(rs2_tag), /*RS2 tag from each register*/
    .rs2_data_valid(rs2_data_valid), /*RS2 data valid from each register*/
    .valid(valid), /*RD valid from each register used to track if instruction in register is a valid instruction*/
    .ready(ready),
    /*interface inputs*/
    .queue_en(queue_en), /*queue enebale from dispatch*/
    .ex_done(ex_done), /*Excecute done from Excecution Unit*/
    /*CDB inputs*/
    .cdb_tag(cdb.tag), /*Published CDB tag*/
    .cdb_data_valid(cdb.valid), /*Published CDB data valid*/
    /*Update muxes control*/
    .rs1_updt_en(rs1_updt_en),
    .rs1_updt_from_cdb(rs1_updt_from_cdb),
    .rs2_updt_en(rs2_updt_en),
    .rs2_updt_from_cdb(rs2_updt_from_cdb),
    .updt_cmn(updt_cmn),
    /*Register control*/
    .reg_we(reg_we), /*Enable for registers*/
    /*Output control*/
    .output_selector(output_selector), /*Selector for output mux, also used to track which register is being output*/
    /*Back pressure*/
    .queue_full(queue_full), /*Queue full indicator*/
    /*Issue controller*/
    .issue_valid(issue_valid) /*Issue valid bit to indicate excecution unit that data output is valid*/
);

reservation_reg #(
    .imm_en(IMM_EN),
    .pc_en(PC_EN)
)
RES_REG_0
(
    .clk(clk),
    .rst(rst),
    /*control signals*/
    .we(reg_we[0]),
    .updt_cmn_block(updt_cmn[0]),
    .updt_rs1(rs1_updt_en[0]),
    .updt_rs1_from_cdb(rs1_updt_from_cdb[0]),
    .updt_rs2(rs2_updt_en[0]),
    .updt_rs2_from_cdb((rs1_updt_from_cdb[0])),
    /*queue bus*/
    .queue_bus_in(queue_bus_barrier),
    .imm(disp_imm),
    .pc(disp_pc),
    /*CDB data*/
    .cdb_data_valid(cdb.valid),
    .cdb_data(cdb.data),
    /*Output*/
    .queue_bus_out(queue_bus_reg[0]),
    .imm_out(reg_imm[0]),
    .pc_out(reg_pc[0]),
    .res_reg_ready(ready[0])
);

genvar i;
generate
    for (i = 1; i < 4; i += 1) begin : reg_station
        reservation_reg #(
            .imm_en(IMM_EN),
            .pc_en(PC_EN)
        )
        RES_REG
        (
            .clk(clk),
            .rst(rst),
            /*control signals*/
            .we(reg_we[i]),
            .updt_cmn_block(updt_cmn[i]),
            .updt_rs1(rs1_updt_en[i]),
            .updt_rs1_from_cdb(rs1_updt_from_cdb[i]),
            .updt_rs2(rs2_updt_en[i]),
            .updt_rs2_from_cdb((rs1_updt_from_cdb[i])),
            /*queue bus*/
            .queue_bus_in(queue_bus_reg[i-1]),
            .imm(reg_imm[i-1]),
            .pc(reg_pc[i-1]),
            /*CDB data*/
            .cdb_data_valid(cdb.valid),
            .cdb_data(cdb.data),
            /*Output*/
            .queue_bus_out(queue_bus_reg[i]),
            .imm_out(reg_imm[i]),
            .pc_out(reg_pc[i]),
            .res_reg_ready(ready[i])
        );
    end
endgenerate


if_mux #(.N(4)) MUX_OUT (
    .if_in_0(queue_bus_reg[0]),
    .if_in_1(queue_bus_reg[1]),
    .if_in_2(queue_bus_reg[2]),
    .if_in_3(queue_bus_reg[3]),
    .sel(output_selector),
    .if_out(issue_queue_bus)
);

always_comb begin : output_mux
/*    issue_queue_bus.rs1_data       = queue_bus_reg[output_selector].rs1_data;
    issue_queue_bus.rs1_tag        = queue_bus_reg[output_selector].rs1_tag;
    issue_queue_bus.rs1_data_valid = queue_bus_reg[output_selector].rs1_data_valid;
    issue_queue_bus.rs2_data       = queue_bus_reg[output_selector].rs2_data;
    issue_queue_bus.rs2_tag        = queue_bus_reg[output_selector].rs2_tag;
    issue_queue_bus.rs2_data_valid = queue_bus_reg[output_selector].rs2_data_valid;
    issue_queue_bus.rd_token       = queue_bus_reg[output_selector].rd_token;
    issue_queue_bus.opcode         = queue_bus_reg[output_selector].opcode;
    issue_queue_bus.funct7         = queue_bus_reg[output_selector].funct7;
    issue_queue_bus.funct3         = queue_bus_reg[output_selector].funct3;*/
    issue_pc = reg_pc[output_selector];
    issue_imm = reg_imm[output_selector];
end

endmodule