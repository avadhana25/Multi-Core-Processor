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

word_t next_instr, next_npc, next_curr_pc, next_rdat1, next_rdat2; 
logic next_regWr, next_dWEN, next_dREN, next_jpSel, next_aluSrc;
aluop_t next_aluOp; 
logic [2:0] next_rdSel; 
logic [1:0] next_pcSrc; 
logic next_halt;

always_ff @(posedge CLK, negedge nRST)
begin
    if (!nRST)
    begin
        dxif.instr_o   <= 32'b0;
        dxif.npc_o     <= 32'b0;
        dxif.curr_pc_o <= 32'b0;
        dxif.rdat1_o   <= 32'b0;
        dxif.rdat2_o   <= 32'b0;
        dxif.regWr_o   <= 1'b0;
        dxif.dWEN_o    <= 1'b0;
        dxif.dREN_o    <= 1'b0;
        dxif.jpSel_o   <= 1'b0;
        dxif.aluSrc_o  <= 1'b0;
        dxif.aluOp_o   <= ALU_SLL;
        dxif.rdSel_o   <= 3'b0;
        dxif.pcSrc_o   <= 2'b0;
        dxif.halt_o    <= 1'b0;
    end
    else
    begin
        dxif.instr_o   <= next_instr;
        dxif.npc_o     <= next_npc;
        dxif.curr_pc_o <= next_curr_pc;
        dxif.rdat1_o   <= next_rdat1;
        dxif.rdat2_o   <= next_rdat2;
        dxif.regWr_o   <= next_regWr;
        dxif.dWEN_o    <= next_dWEN;
        dxif.dREN_o    <= next_dREN;
        dxif.jpSel_o   <= next_jpSel;
        dxif.aluSrc_o  <= next_aluSrc;
        dxif.aluOp_o   <= next_aluOp;
        dxif.rdSel_o   <= next_rdSel;
        dxif.pcSrc_o   <= next_pcSrc;
        dxif.halt_o    <= next_halt;
    end
end

always_comb begin
    next_instr = dxif.instr_o;
    next_npc = dxif.npc_o;
    next_curr_pc = dxif.curr_pc_o; 
    next_rdat1 = dxif.rdat1_o; 
    next_rdat2 = dxif.rdat2_o; 
    next_regWr = dxif.regWr_o; 
    next_dWEN = dxif.dWEN_o; 
    next_dREN = dxif.dREN_o;
    next_jpSel = dxif.jpSel_o; 
    next_aluSrc = dxif.aluSrc_o; 
    next_aluOp = dxif.aluOp_o; 
    next_rdSel = dxif.rdSel_o; 
    next_pcSrc = dxif.pcSrc_o; 
    next_halt = dxif.halt_o;
    if(dxif.flush & dxif.en) begin
        next_instr = '0;
        next_npc = '0;
        next_curr_pc = '0; 
        next_rdat1 = '0; 
        next_rdat2 = '0; 
        next_regWr = '0; 
        next_dWEN = '0; 
        next_dREN = '0;
        next_jpSel = '0; 
        next_aluSrc = '0; 
        next_aluOp = ALU_SLL; 
        next_rdSel = '0; 
        next_pcSrc = '0; 
        next_halt = '0;
    end
    else if(dxif.freeze & dxif.en) begin
        next_instr = '0;
        next_npc = '0;
        next_curr_pc = '0; 
        next_rdat1 = '0; 
        next_rdat2 = '0; 
        next_regWr = '0; 
        next_dWEN = '0; 
        next_dREN = '0;
        next_jpSel = '0; 
        next_aluSrc = '0; 
        next_aluOp = ALU_SLL; 
        next_rdSel = '0; 
        next_pcSrc = '0; 
        next_halt = '0;
    end
    else if (dxif.en) begin
        next_instr = dxif.instr_i;
        next_npc = dxif.npc_i;
        next_curr_pc = dxif.curr_pc_i;
        next_rdat1 = dxif.rdat1_i;
        next_rdat2 = dxif.rdat2_i;
        next_regWr = dxif.regWr_i;
        next_dWEN = dxif.dWEN_i;
        next_dREN = dxif.dREN_i;
        next_jpSel = dxif.jpSel_i;
        next_aluSrc = dxif.aluSrc_i;
        next_aluOp  = dxif.aluOp_i;
        next_rdSel  = dxif.rdSel_i;
        next_pcSrc = dxif.pcSrc_i;
        next_halt = dxif.halt_i;
    end
end

endmodule