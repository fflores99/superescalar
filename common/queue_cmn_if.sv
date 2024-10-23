interface queue_cmn_bus();
    logic [31:0] rs1_data;
    logic [5:0] rs1_tag;
    logic rs1_data_valid;
    logic [31:0] rs2_data;
    logic [5:0] rs2_tag;
    logic rs2_data_valid;
    logic [6:0] rd_token;
    logic [6:0] opcode,
    logic [6:0] funct7,
    logic [2:0] funct3;
endinterface