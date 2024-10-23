`timescale 1ns/1ps

module dispatch_unit_smart_bmf (
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


reg [5:0] tag_queue [24];
reg valid_queue [24];
reg [31:0] data_queue [24];


reg [4:0] counter;

assign cdb.tag = tag_queue[counter];
assign cdb.valid = valid_queue[counter];
assign cdb.data = data_queue[counter];
assign cdb.branch = ((counter == 7) || (counter == 11)) ? 1'b1 : 1'b0;
assign cdb.branch_taken = (counter == 11) ? 1'b1 : 1'b0;
assign cdb.jalr = 1'b0;

/*Tags*/
assign tag_queue[0] = 6'd0; /*First filling the queue*/
assign tag_queue[1] = 6'd0; /*Second filling the queue*/
assign tag_queue[2] = 6'd0; /*Third filling the queue*/
assign tag_queue[3] = 6'd0; /*addi x4, x0, 10*/
assign tag_queue[4] = 6'd1; /*addi x5, x0, 11*/
assign tag_queue[5] = 6'd2; /*addi x6, x0, 21*/
assign tag_queue[6] = 6'd3; /*add x7, x5, x4*/
/*Stalling for branch*/
assign tag_queue[7] = 6'd0; /*beq x4, x5, here*/
assign tag_queue[8] = 6'd0; /*beq x4, x5, here*/
/*Branch solved*/
assign tag_queue[9] = 6'd0; /*beq x4, x5, here*/
/*Stalling for branch*/
assign tag_queue[10] = 6'd0; /*beq x4, x5, here*/
assign tag_queue[11] = 6'd0; /*beq x4, x5, here*/
assign tag_queue[12] = 6'd0; /*beq x4, x5, here*/
assign tag_queue[13] = 6'd0; /*beq x4, x5, here*/ /*ADD more stalling cycles*/
/*branch solved*/
assign tag_queue[14] = 6'd0; /*beq x7, x6, here. it branches*/
/*multiplication takes 2 cycles, mul x8, x4, x5 will be assign tag 4*/
assign tag_queue[15] = 6'd5; /*auipc x9 0xfc10, result 0x10010024*/
assign tag_queue[16] = 6'd6; /*lw x9, 0xffffffdc (x9)*/
assign tag_queue[17] = 6'd4; /*mul x8, x4, x5*/
assign tag_queue[18] = 6'd7; /*auipc x10 0xfc10, result 0x1001002c*/
assign tag_queue[19] = 6'd0; /*sw x4, 0xffffffcc(x10)*/
assign tag_queue[20] = 6'd8; /*jal x1 0x0000000c*/
assign tag_queue[21] = 6'd0; /*nop*/
assign tag_queue[22] = 6'd0; /*nop*/
assign tag_queue[23] = 6'd0; /*nop*/

/*valid*/
assign valid_queue[0] = 1'b0; /*First filling the queue*/
assign valid_queue[1] = 1'b0; /*Second filling the queue*/
assign valid_queue[2] = 1'b0; /*Third filling the queue*/
assign valid_queue[3] = 1'b1; /*addi x4, x0, 10*/
assign valid_queue[4] = 1'b1; /*addi x5, x0, 11*/
assign valid_queue[5] = 1'b1; /*addi x6, x0, 21*/
assign valid_queue[6] = 1'b1; /*add x7, x5, x4*/
/*Stalling for branch*/
assign valid_queue[7] = 1'b0; /*beq x4, x5, here*/
assign valid_queue[8] = 1'b0; /*beq x4, x5, here*/
/*Branch solved*/
assign valid_queue[9] = 1'b0; /*beq x4, x5, here*/
/*Stalling for branch*/
assign valid_queue[10] = 1'b0; /*beq x4, x5, here*/
assign valid_queue[11] = 1'b0; /*beq x4, x5, here*/
assign valid_queue[12] = 1'b0; /*beq x4, x5, here*/
assign valid_queue[13] = 1'b0; /*beq x4, x5, here*/
/*branch solved*/
assign valid_queue[14] = 1'b0; /*beq x7, x6, here. it branches*/
/*multiplication takes 2 cycles, mul x8, x4, x5 will be assign tag 4*/
assign valid_queue[15] = 1'b1; /*auipc x9 0xfc10, result 0x10010024*/
assign valid_queue[16] = 1'b1; /*lw x9, 0xffffffdc (x9)*/
assign valid_queue[17] = 1'b1; /*mul x8, x4, x5*/
assign valid_queue[18] = 1'b1; /*auipc x10 0xfc10, result 0x1001002c*/
assign valid_queue[19] = 1'b0; /*sw x4, 0xffffffcc(x10)*/
assign valid_queue[20] = 1'b1; /*jal x1 0x0000000c*/
assign valid_queue[21] = 1'b0; /*nop*/
assign valid_queue[22] = 1'b0; /*nop*/
assign valid_queue[23] = 1'b0; /*nop*/

/*data*/
assign data_queue[0] = 32'h00000000; /*First filling the queue*/
assign data_queue[1] = 32'h00000000; /*Second filling the queue*/
assign data_queue[2] = 32'h00000000; /*Third filling the queue*/
assign data_queue[3] = 32'h0000000A; /*addi x4, x0, 10*/
assign data_queue[4] = 32'h0000000B; /*addi x5, x0, 11*/
assign data_queue[5] = 32'h00000015; /*addi x6, x0, 21*/
assign data_queue[6] = 32'h00000015; /*add x7, x5, x4*/
/*Stalling for branch*/
assign data_queue[7] = 32'h00000000; /*beq x4, x5, here*/
assign data_queue[8] = 32'h00000000; /*beq x4, x5, here*/
/*Branch solved*/
assign data_queue[9] = 32'h00000000; /*beq x4, x5, here*/
/*Stalling for branch*/
assign data_queue[10] = 32'h00000000; /*beq x4, x5, here*/
assign data_queue[11] = 32'h00000000; /*beq x4, x5, here*/
assign data_queue[12] = 32'h00000000; /*beq x4, x5, here*/
assign data_queue[13] = 32'h00000000; /*beq x4, x5, here*/
/*branch solved*/
assign data_queue[14] = 32'h00000000; /*beq x7, x6, here. it branches*/
/*multiplication takes 2 cycles, mul x8, x4, x5 will be assign tag 4*/
assign data_queue[15] = 32'h10010024; /*auipc x9 0xfc10, result 0x10010024*/
assign data_queue[16] = 32'hFFFFFFFF; /*lw x9, 0xffffffdc (x9)*/
assign data_queue[17] = 32'h0000006E; /*mul x8, x4, x5*/
assign data_queue[18] = 32'h1001002C; /*auipc x10 0xfc10, result 0x1001002c*/
assign data_queue[19] = 32'h00000000; /*sw x4, 0xffffffcc(x10)*/
assign data_queue[20] = 32'h00400038; /*jal x1 0x0000000c*/
assign data_queue[21] = 32'h00000000; /*nop*/
assign data_queue[22] = 32'h00000000; /*nop*/
assign data_queue[23] = 32'h00000000; /*nop*/



always_ff @( posedge clk, posedge rst ) begin : sequential
    if(rst)
    begin
        counter <= 5'd0;
    end else
    begin
            if(counter < 23)
                counter <= counter + 1'b1;
            else
                counter <= 5'd0;
    end    
end

endmodule