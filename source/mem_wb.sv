/*
Aakash Vadhanam
memory_writeback latch source file
9/12/24
*/

//all types
`include "cpu_types_pkg.vh"
`include "mem_wb_if.vh"

// import types
  import cpu_types_pkg::*;



module mem_wb(input logic CLK, nRST, mem_wb_if.memwb mwif);

always_ff @(posedge CLK, negedge nRST)
begin
    if (!nRST)
    begin
        mwif.npc_o        <= 32'b0;
        mwif.curr_pc_o    <= 32'b0;
        mwif.port_out_o   <= 32'b0;
        mwif.dmemload_o   <= 32'b0;
        mwif.zeroExt_o    <= 32'b0;
        mwif.rs1_o        <= 5'b0;
        mwif.rs2_o        <= 5'b0;
        mwif.rd_o         <= 5'b0;
        mwif.regWr_o      <= 1'b0;
        mwif.halt_o       <= 1'b0;
        mwif.rdSel_o      <= 3'b0; 
    end
    else if (mwif.en | mwif.dhit)
    begin
        mwif.npc_o        <= mwif.npc_i;
        mwif.curr_pc_o    <= mwif.curr_pc_i;
        mwif.port_out_o   <= mwif.port_out_i;
        mwif.dmemload_o   <= mwif.dmemload_i;
        mwif.zeroExt_o    <= mwif.zeroExt_i;
        mwif.rs1_o        <= mwif.rs1_i;
        mwif.rs2_o        <= mwif.rs2_i;
        mwif.rd_o         <= mwif.rd_i;
        mwif.regWr_o      <= mwif.regWr_i;
        mwif.halt_o       <= mwif.halt_i;
        mwif.rdSel_o      <= mwif.rdSel_i; 
    end
    else if (mwif.flush)
    begin
        mwif.npc_o        <= 32'b0;
        mwif.curr_pc_o    <= 32'b0;
        mwif.port_out_o   <= 32'b0;
        mwif.dmemload_o   <= 32'b0;
        mwif.zeroExt_o    <= 32'b0;
        mwif.rs1_o        <= 5'b0;
        mwif.rs2_o        <= 5'b0;
        mwif.rd_o         <= 5'b0;
        mwif.regWr_o      <= 1'b0;
        mwif.halt_o       <= 1'b0;
        mwif.rdSel_o      <= 3'b0; 
    end
end

endmodule