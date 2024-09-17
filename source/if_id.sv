/*
Aakash Vadhanam
fetch_decode latch source file
9/11/24
*/

//all types
`include "cpu_types_pkg.vh"
`include "if_id_if.vh"

// import types
  import cpu_types_pkg::*;



module if_id(input logic CLK, nRST, if_id_if.ifid fdif);

logic [31:0] next_instr;
logic [31:0] next_npc;
logic [31:0] next_curr_pc;

always_ff @(posedge CLK, negedge nRST)
begin
    if (!nRST)
    begin
        fdif.instr_o   <= 32'b0;
        fdif.npc_o     <= 32'b0;
        fdif.curr_pc_o <= 32'b0;
    end
    else
    begin
        fdif.instr_o    <= next_instr;
        fdif.npc_o      <= next_npc;
        fdif.curr_pc_o <= next_curr_pc;
    end
end

always_comb begin
    next_instr = fdif.instr_o;
    next_npc = fdif.npc_o;
    next_curr_pc = fdif.curr_pc_o;
    if(fdif.flush) begin
        next_instr = '0;
        next_npc = '0;
        next_curr_pc = '0;
    end
    else if(fdif.en) begin
        next_instr = fdif.instr_i;
        next_npc = fdif.npc_i;
        next_curr_pc = fdif.curr_pc_i;
    end
end


endmodule