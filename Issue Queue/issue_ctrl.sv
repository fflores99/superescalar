module issue_ctrl (
    /*Status of registers*/
    /*Reg inputs*/
    input [5:0] rs1_tag[4]; /*RS1 tag from each register*/
    input rs1_data_valid[4]; /*RS1 data valid from each register*/
    input [5:0] rs2_tag[4]; /*RS2 tag from each register*/
    input rs2_data_valid[4]; /*RS2 data valid from each register*/
    input valid[4]; /*RD valid from each register used to track if instruction in register is a valid instruction*/
    /*interface inputs*/
    input queue_en; /*queue enebale from dispatch*/
    input ex_done; /*Excecute done from Excecution Unit*/
    /*CDB inputs*/
    input [5:0] cdb_tag; /*Published CDB tag*/
    input cdb_data_valid; /*Published CDB data valid*/
    /*Update muxes control*/
    output reg [1:0] rs1_updt_sel[4]; /*Selector for RS1 mux on each register*/
    output reg [1:0] rs2_updt_sel[4]; /*Selector for RS2 mux on each register*/
    /*Register control*/
    output reg reg_we[4]; /*Enable for registers*/
    /*Output control*/
    output reg [1:0] output_selector; /*Selector for output mux, also used to track which register is being output*/
    /*Back pressure*/
    output reg queue_full; /*Queue full indicator*/
    /*Issue controller*/
    output reg issue_valid; /*Issue valid bit to indicate excecution unit that data output is valid*/
);

/*Used to track the state of each register*/
enum reg[1:0] {REG_EMPTY, REG_WAITING, REG_READY} rstatus;
rstatus REG_STATUS[4];

/*Used for update mux selectors*/
localparam UPDT_SEL_PREV_REG    = 2'b00;
localparam UPDT_SEL_CDB         = 2'b01;
localparam UPDT_SEL_NO_UPDT     = 2'b10;
localparam UPDT_SEL_CLEAR       = 2'b11;

/*Used to track register operations*/
reg reg_shift[4], reg_updt_rs1[4], reg_updt_rs2[4];

/*Checks the status of each register*/
always_comb begin : status_decoder
    integer i;
    for (i = 0; i < 4; i++) begin
        if(valid[i]) begin
            /*Register is not empty*/
            if(rs1_data_valid[i] == 1'b1 && rs2_data_valid[i] == 1'b1) begin
                /*Register is ready to be issued*/
                REG_STATUS[i] = REG_READY;
            end else begin
                /*Register is waiting for a cdb entry*/
                REG_STATUS[i] = REG_WAITING;
            end
        end else begin
            /*Register is empty*/
            REG_STATUS[i] = REG_EMPTY;
        end
    end
end

/*Checks if fifo is full*/
always_comb begin : full_control
    if((REG_STATUS[0] != REG_EMPTY) && (REG_STATUS[1] != REG_EMPTY) && (REG_STATUS[2] != REG_EMPTY) && (REG_STATUS[3] != REG_EMPTY))
        queue_full = 1'b1;
    else
        queue_full = 1'b0;
end

/*Output control*/
always_comb begin : output_controller
    /*Decides which register to issue with priority to the oldest*/
    if(REG_STATUS[3] == REG_READY) begin
        issue_valid = 1'b1;
        output_selector = 2'b11;
    end else if(REG_STATUS[2] == REG_READY) begin
        issue_valid = 1'b1;
        output_selector = 2'b10;
    end else if(REG_STATUS[1] == REG_READY) begin
        issue_valid = 1'b1;
        output_selector = 2'b01; 
    end else if(REG_STATUS[0] == REG_READY) begin
        issue_valid = 1'b1;
        output_selector = 2'b00;
    end else begin
        issue_valid = 1'b0;
        output_selector = 2'b00;
    end
end

/* In this context, shift means request the data from upper register (in case of reg 0 is from dispatch unit)*/
always_comb begin : shift_ctrl
    /*Every register will be shifted if lower register is empty, is being output, or is being shifted as well*/
    /*If a register is empty it will shift, even if upper data is also an empty value*/
    /*Register 3 will be updated if it is being output and excecution unit has finished process its data or if it is empty*/
    if(((output_selector == 2'b11) && (issue_valid == 1'b1) && (ex_done == 1'b1))  || (REG_STATUS[3] == REG_EMPTY))
        reg_shift[3] = 1'b1;
    else 
        reg_shift[3] = 1'b0;
    /*Registers 2, 1 and 0 will be updated if it is being output and excecution unit has finished process its data or if it is empty or if next register is being shifted*/
    if(((output_selector == 2'b10) && (issue_valid == 1'b1) && (ex_done == 1'b1)) || (reg_shift[3] == 1'b1) || (REG_STATUS[2] == REG_EMPTY))
        reg_shift[2] = 1'b1;
    else 
        reg_shift[2] = 1'b0;

    if(((output_selector == 2'b01) && (issue_valid == 1'b1) && (ex_done == 1'b1)) || (reg_shift[2] == 1'b1) || (REG_STATUS[1] == REG_EMPTY) )
        reg_shift[1] = 1'b1;
    else 
        reg_shift[1] = 1'b0;

    if(((output_selector == 2'b00) && (issue_valid == 1'b1) && (ex_done == 1'b1)) || (reg_shift[1] == 1'b1) || (REG_STATUS[0] == REG_EMPTY))
        reg_shift[0] = 1'b1;
    else 
        reg_shift[0] = 1'b0;
end

/*Shift and update control*/
always_comb begin : updt_ctrl
    /*A register is updated if CDB publishes its dependency*/
    integer i;
    for (i = 0; i < 4; i += 1) begin
        if(cdb_valid == 1'b1 && cdb_tag == rs1_tag[0])
            reg_updt_rs1[0] = 1'b1;
        else
            reg_updt_rs1[0] = 1'b0;
        
        if(cdb_valid == 1'b1 && cdb_tag == rs2_tag[0])
            reg_updt_rs2[0] = 1'b1;
        else
            reg_updt_rs2[0] = 1'b0;
    end
end
/*
UPDT_SEL_PREV_REG    = 2'b00;
UPDT_SEL_CDB         = 2'b01;
UPDT_SEL_NO_UPDT     = 2'b10;
UPDT_SEL_CLEAR       = 2'b11;
*/
/*Update selector*/
always_comb begin : update_selector
    integer i;
    /*Reg can have data from dispatch or a fixed 0 if data from dispatch is not valid*/
    if(queue_en) begin
        rs1_updt_sel[0] = UPDT_SEL_CLEAR;
        rs2_updt_sel[0] = UPDT_SEL_CLEAR;
    end
    else begin
        rs1_updt_sel[0] = UPDT_SEL_CLEAR;
        rs2_updt_sel[0] = UPDT_SEL_CLEAR;
    end
    /*Reg 1 and 2 can update its own or the next depending is a shift is requested*/
    for (i = 1; i < 4; i += 1) begin
        if(reg_shift[i] == 1'b1) begin
            /*Reg i is requesting data from reg i-1*/
            /*Compares with prev register operation*/
            if(rs1_updt_sel[i-1] == 1'b1)
            /*Update rs1 with CDB*/
                rs1_updt_sel[1] = UPDT_SEL_CDB;
            else
            /*No update*/
                rs1_updt_sel[1] = UPDT_SEL_PREV_REG;

            if(rs2_updt_sel[i-1] == 1'b1)
            /*Update rs2 with CDB*/
                rs2_updt_sel[i] = UPDT_SEL_CDB;
            else
            /*No update*/
                rs2_updt_sel[i] = UPDT_SEL_PREV_REG;
        end
        else begin
            /*Reg i is not requesting data from reg i-1*/
            if(rs1_updt_sel[i] == 1'b1)
            /*Update rs1 with CDB*/
                rs1_updt_sel[i] = UPDT_SEL_CDB;
            else
            /*No update*/
                rs1_updt_sel[i] = UPDT_SEL_NO_UPDT;

            if(rs2_updt_sel[i] == 1'b1)
            /*Update rs2 with CDB*/
                rs2_updt_sel[i] = UPDT_SEL_CDB;
            else
            /*No update*/
                rs2_updt_sel[i] = UPDT_SEL_NO_UPDT;
        end
    end


end
endmodule