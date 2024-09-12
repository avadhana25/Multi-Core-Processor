/*
Aakash Vadhanam
execute_memory latch source file
9/12/24
*/

//all types
`include "cpu_types_pkg.vh"
`include "ex_mem_if.vh"

// import types
  import cpu_types_pkg::*;



module ex_mem(input logic CLK, nRST, ex_mem_if.exmem xmif);

always_ff @(posedge CLK, negedge nRST)
begin
    if (!nRST)
    begin
        xmif.npc_o        <= 32'b0;
        xmif.rdat2_o      <= 32'b0;
        xmif.branchAddr_o <= 32'b0;
        xmif.zeroExt_o    <= 32'b0;
        xmif.port_out_o   <= 32'b0;
        xmif.rs1_o        <= 5'b0;
        xmif.rs2_o        <= 5'b0;
        xmif.rd_o         <= 5'b0;
        xmif.branch_o     <= 1'b0;
        xmif.regWr_o      <= 1'b0;
        xmif.dWEN_o       <= 1'b0;
        xmif.dREN_o       <= 1'b0;
        xmif.jpSel_o      <= 1'b0;
        xmif.rdSel_o      <= 3'b0;
        xmif.pcSrc_o      <= 2'b0;
        xmif.halt_o       <= 1'b0;
    end
    else if (xmif.dhit)
    begin
        xmif.npc_o        <= 32'b0;
        xmif.rdat2_o      <= 32'b0;
        xmif.branchAddr_o <= 32'b0;
        xmif.zeroExt_o    <= 32'b0;
        xmif.port_out_o   <= 32'b0;
        xmif.rs1_o        <= 5'b0;
        xmif.rs2_o        <= 5'b0;
        xmif.rd_o         <= 5'b0;
        xmif.branch_o     <= 1'b0;
        xmif.regWr_o      <= 1'b0;
        xmif.dWEN_o       <= 1'b0;
        xmif.dREN_o       <= 1'b0;
        xmif.jpSel_o      <= 1'b0;
        xmif.rdSel_o      <= 3'b0;
        xmif.pcSrc_o      <= 2'b0;
        xmif.halt_o       <= 1'b0;
    end
    else if (xmif.en)
    begin
        xmif.npc_o        <= xmif.npc_i;
        xmif.rdat2_o      <= xmif.rdat2_i;
        xmif.branchAddr_o <= xmif.branchAddr_i;
        xmif.zeroExt_o    <= xmif.zeroExt_i;
        xmif.port_out_o   <= xmif.port_out_i;
        xmif.rs1_o        <= xmif.rs1_i;
        xmif.rs2_o        <= xmif.rs2_i;
        xmif.rd_o         <= xmif.rd_i;
        xmif.branch_o     <= xmif.branch_i;
        xmif.regWr_o      <= xmif.regWr_i;
        xmif.dWEN_o       <= xmif.dWEN_i;
        xmif.dREN_o       <= xmif.dREN_i;
        xmif.jpSel_o      <= xmif.jpSel_i;
        xmif.rdSel_o      <= xmif.rdSel_i;
        xmif.pcSrc_o      <= xmif.pcSrc_i;
        xmif.halt_o       <= xmif.halt_i;
    end
    else if (xmif.flush)
    begin
        xmif.npc_o        <= 32'b0;
        xmif.rdat2_o      <= 32'b0;
        xmif.branchAddr_o <= 32'b0;
        xmif.zeroExt_o    <= 32'b0;
        xmif.port_out_o   <= 32'b0;
        xmif.rs1_o        <= 5'b0;
        xmif.rs2_o        <= 5'b0;
        xmif.rd_o         <= 5'b0;
        xmif.branch_o     <= 1'b0;
        xmif.regWr_o      <= 1'b0;
        xmif.dWEN_o       <= 1'b0;
        xmif.dREN_o       <= 1'b0;
        xmif.jpSel_o      <= 1'b0;
        xmif.rdSel_o      <= 3'b0;
        xmif.pcSrc_o      <= 2'b0;
        xmif.halt_o       <= 1'b0;
    end
end

endmodule