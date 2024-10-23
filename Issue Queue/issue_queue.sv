module issue_queue (
    /*QUEUE common*/
    queue_cmn_bus queue_bus, /*Common signasl to queues*/
    /*Integer queue*/
    output int_queue_en,
    output disp_imm,
    output [31:0] disp_pc,
    output [6:0] opcode,
    output [6:0] funct7,
    /*Multiplication queue*/
    output mult_queue_en,
    /*Division queue*/
    output div_queue_en,
    /*Memory queue*/
    output mem_queue_en,
    /*Backend return*/
    cdb_bus cdb
);
    
endmodule