module inst_decoder (

input [6:0] opcode,
input [14:12] funct3,
input [11:7] funct7,

output reg jmp,
output reg reg_write,
output reg branch,
output reg jalr,
output reg int_queue_en,
output reg multip_queue_en,
output reg div_queue_en,
output reg memory_queue_en

);

always_comb begin : decoder
    case(opcode)
    7'b0110011: begin
        jmp = 1'b0; /*Not a jump instruction*/
        reg_write = 1'b1; /*Instruction writes in register*/
        branch = 1'b0; /*Not a branch instruction*/
        jalr = 1'b0; /*Not a JALR instruction*/
        memory_queue_en = 1'b0; /*Not a memory instruction*/
        if(funct7 != 7'h01) begin
            /*Integer Operation*/
            int_queue_en = 1'b1;
            multip_queue_en = 1'b0;
            div_queue_en = 1'b0;
        end else begin
            if(funct3 < 3'h4) begin
                /*Multiplication*/
                int_queue_en = 1'b0;
                multip_queue_en = 1'b1;
                div_queue_en = 1'b0;
            end else begin
                /*Division*/
                int_queue_en = 1'b0;
                multip_queue_en = 1'b0;
                div_queue_en = 1'b1;
            end
        end      
    end
    7'b0010011, 7'b0110111, 7'b0010111 : begin
        /*Integer operation with immediate, LUI and AUIPC*/
        jmp = 1'b0; /*Not a jump instruction*/
        reg_write = 1'b1; /*Instruction writes in register*/
        branch = 1'b0; /*Not a branch instruction*/
        jalr = 1'b0; /*Not a JALR instruction*/
        memory_queue_en = 1'b0; /*Not a memory instruction*/
        int_queue_en = 1'b1;
        multip_queue_en = 1'b0;
        div_queue_en = 1'b0;
    end
    7'b0000011: begin
        /*Load*/
        jmp = 1'b0; /*Not a jump instruction*/
        reg_write = 1'b1; /*Instruction writes in register*/
        branch = 1'b0; /*Not a branch instruction*/
        jalr = 1'b0; /*Not a JALR instruction*/
        memory_queue_en = 1'b1; /*Memory instruction*/
        int_queue_en = 1'b0;
        multip_queue_en = 1'b0;
        div_queue_en = 1'b0;
    end
    7'b0100011: begin
        /*Store*/
        jmp = 1'b0; /*Not a jump instruction*/
        reg_write = 1'b0; /*Instruction doesn't write in register*/
        branch = 1'b0; /*Not a branch instruction*/
        jalr = 1'b0; /*Not a JALR instruction*/
        memory_queue_en = 1'b1; /*Memory instruction*/
        int_queue_en = 1'b0;
        multip_queue_en = 1'b0;
        div_queue_en = 1'b0;
    end
    7'b1100011: begin
        /*Branch*/
        jmp = 1'b0; /*Not a jump instruction*/
        reg_write = 1'b0; /*Instruction doesn't write in register*/
        branch = 1'b1; /*Branch*/
        jalr = 1'b0; /*Not a JALR instruction*/
        memory_queue_en = 1'b0; /*Not a memory instruction*/
        int_queue_en = 1'b1; /*Branch is solved in integer queue*/
        multip_queue_en = 1'b0;
        div_queue_en = 1'b0;
    end
    7'b1101111: begin
        /*JAL*/
        jmp = 1'b1; /*Jump instruction*/
        reg_write = 1'b1; /*Instruction writes in register*/
        branch = 1'b0; /*Not a Branch*/
        jalr = 1'b0; /*Not a JALR instruction*/
        memory_queue_en = 1'b0; /*Not a memory instruction*/
        int_queue_en = 1'b1; /*JAL uses integer queue to store callback address into memory*/
        multip_queue_en = 1'b0;
        div_queue_en = 1'b0;
    end
    7'b1100111: begin
        /*JALR*/
        jmp = 1'b0; /*Jump instruction*/
        reg_write = 1'b1; /*Instruction writes in register*/
        branch = 1'b0; /*Not a Branch*/
        jalr = 1'b1; /*JALR instruction*/
        memory_queue_en = 1'b0; /*Not a memory instruction*/
        int_queue_en = 1'b1; /*JALR uses integer queue to store callback address into memory and calculate jump address*/
        multip_queue_en = 1'b0;
        div_queue_en = 1'b0;
    end
    default: begin
        /*Invalid OPCODE*/
        jmp = 1'b0; /*Jump instruction*/
        reg_write = 1'b0; /*Instruction doesn't writes in register*/
        branch = 1'b0; /*Not a Branch*/
        jalr = 1'b0; /*Not JALR instruction*/
        memory_queue_en = 1'b0; /*Not a memory instruction*/
        int_queue_en = 1'b0;
        multip_queue_en = 1'b0;
        div_queue_en = 1'b0;
    end
    endcase
end

endmodule