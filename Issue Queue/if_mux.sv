module if_mux #(parameter N=4)
(
    queue_cmn_bus if_in_0,
    queue_cmn_bus if_in_1,
    queue_cmn_bus if_in_2,
    queue_cmn_bus if_in_3,
    input [$clog2(N) - 1:0] sel,
    queue_cmn_bus if_out
);

always_comb begin
    //if_out = if_in[sel];
    case(sel)
        2'b00: begin
    if_out.rs1_data       = if_in_0.rs1_data;
    if_out.rs1_tag        = if_in_0.rs1_tag;
    if_out.rs1_data_valid = if_in_0.rs1_data_valid;
    if_out.rs2_data       = if_in_0.rs2_data;
    if_out.rs2_tag        = if_in_0.rs2_tag;
    if_out.rs2_data_valid = if_in_0.rs2_data_valid;
    if_out.rd_token       = if_in_0.rd_token;
    if_out.opcode         = if_in_0.opcode;
    if_out.funct7         = if_in_0.funct7;
    if_out.funct3         = if_in_0.funct3;
        end
        2'b01: begin
    if_out.rs1_data       = if_in_1.rs1_data;
    if_out.rs1_tag        = if_in_1.rs1_tag;
    if_out.rs1_data_valid = if_in_1.rs1_data_valid;
    if_out.rs2_data       = if_in_1.rs2_data;
    if_out.rs2_tag        = if_in_1.rs2_tag;
    if_out.rs2_data_valid = if_in_1.rs2_data_valid;
    if_out.rd_token       = if_in_1.rd_token;
    if_out.opcode         = if_in_1.opcode;
    if_out.funct7         = if_in_1.funct7;
    if_out.funct3         = if_in_1.funct3;
        end
        2'b10: begin
    if_out.rs1_data       = if_in_2.rs1_data;
    if_out.rs1_tag        = if_in_2.rs1_tag;
    if_out.rs1_data_valid = if_in_2.rs1_data_valid;
    if_out.rs2_data       = if_in_2.rs2_data;
    if_out.rs2_tag        = if_in_2.rs2_tag;
    if_out.rs2_data_valid = if_in_2.rs2_data_valid;
    if_out.rd_token       = if_in_2.rd_token;
    if_out.opcode         = if_in_2.opcode;
    if_out.funct7         = if_in_2.funct7;
    if_out.funct3         = if_in_2.funct3;
        end
        2'b11: begin
    if_out.rs1_data       = if_in_3.rs1_data;
    if_out.rs1_tag        = if_in_3.rs1_tag;
    if_out.rs1_data_valid = if_in_3.rs1_data_valid;
    if_out.rs2_data       = if_in_3.rs2_data;
    if_out.rs2_tag        = if_in_3.rs2_tag;
    if_out.rs2_data_valid = if_in_3.rs2_data_valid;
    if_out.rd_token       = if_in_3.rd_token;
    if_out.opcode         = if_in_3.opcode;
    if_out.funct7         = if_in_3.funct7;
    if_out.funct3         = if_in_3.funct3;
        end
    endcase
end
endmodule