interface cdb_bus ();
    logic [5:0] tag;
    logic valid;
    logic [31:0] data;
    logic branch;
    logic branch_taken;
    logic jalr;
endinterface