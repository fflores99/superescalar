module dispatch_unit_bmf (
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

reg [5:0] tag_queue [11];
reg valid_queue [11];
reg [31:0] data_queue [11];

reg [3:0] counter;

assign cdb.tag = tag_queue[counter];
assign cdb.valid = valid_queue[counter];
assign cdb.data = data_queue[counter];

always_ff @( posedge clk, posedge rst ) begin : sequential
    if(rst)
    begin
        tag_queue <= '{6'd0,6'd0,6'd0,6'd0,6'd0,6'd1,6'd2,6'd4,6'd3,6'd5,6'd6};
        valid_queue <= '{1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1};
        data_queue <= '{32'd0,32'd0,32'd0,32'd0,32'd20,32'd30,32'd60,32'd100,32'd90,32'd126,32'd26};
        counter <= 4'd0;
    end else
    begin
        if(int_queue_en | mult_queue_en | div_queue_en | mem_queue_en)
            if(counter < 10)
                counter <= counter + 1'b1;
            else
                counter <= 4'd0;
    end    
end
endmodule