module dispatch_staller (
    input clk,
    input rst,
    /*FSM inputs*/
    input branch,
    input jalr,
    input branch_solved,
    input jalr_solved,
    input ifq_empty,
    output nstall
);

typedef enum logic [1:0] {NORMAL_OP, STALLINNG_FOR_BRANCH, STALLING_FOR_JALR, STALLING_FOR_IFQ_NOT_EMPTY} fsm_state;

fsm_state state;

assign nstall = (state == NORMAL_OP) ? 1'b1 : 1'b0;

always_ff @( posedge clk, posedge rst ) begin : sequential
    if(rst)  begin
        state <= NORMAL_OP;
    end else begin
        case (state)
            NORMAL_OP: 
                if(branch)
                    state <= STALLINNG_FOR_BRANCH;
                else if(jalr)
                    state <= STALLING_FOR_JALR;
                else if(ifq_empty)
                    state <= STALLING_FOR_IFQ_NOT_EMPTY;
                else
                    state <= NORMAL_OP;
            STALLINNG_FOR_BRANCH:
                if(branch_solved)
                    state <= NORMAL_OP;
                else
                    state <= STALLINNG_FOR_BRANCH;
            STALLING_FOR_JALR:
                if(jalr_solved)
                    state <= NORMAL_OP;
                else
                    state <= STALLING_FOR_JALR;
            STALLING_FOR_IFQ_NOT_EMPTY:
                if(ifq_empty)
                    state <= STALLING_FOR_IFQ_NOT_EMPTY;
                else
                    state <= NORMAL_OP;
            default: state <= NORMAL_OP;
        endcase
    end   
end

endmodule