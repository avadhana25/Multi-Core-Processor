/*
Aakash Vadhanam
decode_execute latch source file
9/11/24
*/

//all types
`include "cpu_types_pkg.vh"
`include "id_ex_if.vh"

// import types
  import cpu_types_pkg::*;



module id_ex(input logic CLK, nRST, id_ex_if.idex dxif);

always_ff @(posedge CLK, negedge nRST)
begin
    if (!nRST)
    begin
        dxif.instr_o   <= 32'b0;
        dxif.npc_o     <= 32'b0;
        dxif.rdat1_o   <= 32'b0;
        dxif.rdat2_o   <= 32'b0;
        dxif.regWr_o   <= 1'b0;
        dxif.dWEN_o    <= 1'b0;
        dxif.dREN_o    <= 1'b0;
        dxif.shift_o   <= 1'b0;
        dxif.jpSel_o   <= 1'b0;
        dxif.aluSrc_o  <= 1'b0;
        dxif.aluOp_o   <= 4'b0;
        dxif.rdSel_o   <= 3'b0;
        dxif.pcSrc_o   <= 2'b0;
        dxif.halt_o    <= 1'b0;
    end
    else if (dxif.en)
    begin
        dxif.instr_o   <= dxif.instr_i;
        dxif.npc_o     <= dxif.npc_i;
        dxif.rdat1_o   <= dxif.rdat1_i;
        dxif.rdat2_o   <= dxif.rdat2_i;
        dxif.regWr_o   <= dxif.regWr_i;
        dxif.dWEN_o    <= dxif.dWEN_i;
        dxif.dREN_o    <= dxif.dREN_i;
        dxif.shift_o   <= dxif.shift_i;
        dxif.jpSel_o   <= dxif.jpSel_i;
        dxif.aluSrc_o  <= dxif.aluSrc_i;
        dxif.aluOp_o   <= dxif.aluOp_i;
        dxif.rdSel_o   <= dxif.rdSel_i;
        dxif.pcSrc_o   <= dxif.pcSrc_i;
        dxif.halt_o    <= dxif.halt_i;
    end
    else if (dxif.flush)
    begin
        dxif.instr_o   <= 32'b0;
        dxif.npc_o     <= 32'b0;
        dxif.rdat1_o   <= 32'b0;
        dxif.rdat2_o   <= 32'b0;
        dxif.regWr_o   <= 1'b0;
        dxif.dWEN_o    <= 1'b0;
        dxif.dREN_o    <= 1'b0;
        dxif.shift_o   <= 1'b0;
        dxif.jpSel_o   <= 1'b0;
        dxif.aluSrc_o  <= 1'b0;
        dxif.aluOp_o   <= 4'b0;
        dxif.rdSel_o   <= 3'b0;
        dxif.pcSrc_o   <= 2'b0;
        dxif.halt_o    <= 1'b0;
    end
end

endmodule