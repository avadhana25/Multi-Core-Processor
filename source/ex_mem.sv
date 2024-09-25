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

word_t next_npc, next_curr_pc, next_rdat2, next_branchAddr, next_jumpAddr, next_zeroExt, next_port_out, next_instr, next_imm, next_dmemstore;
logic [4:0] next_rs1, next_rs2, next_rd;
logic next_branch, next_regWr, next_dWEN, next_dREN, next_jpSel;
logic [2:0] next_rdSel, next_func3;
logic [1:0] next_pcSrc;
logic next_halt;
logic [6:0] next_func7;
opcode_t next_opcode;

always_ff @(posedge CLK, negedge nRST)
begin
    if (!nRST)
    begin
        xmif.npc_o        <= 32'b0;
        xmif.curr_pc_o    <= 32'b0;
        xmif.rdat2_o      <= 32'b0;
        xmif.branchAddr_o <= 32'b0;
        xmif.jumpAddr_o   <= 32'b0;
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
        xmif.instr_o      <= 32'b0;
        xmif.func3_o      <= 3'b0;
        xmif.func7_o      <= 7'b0;
        xmif.opcode_o     <= RTYPE;
        xmif.imm_o        <= 32'b0;
        xmif.dmemstore_o  <= 32'b0;
    end
    else
    begin
        xmif.npc_o        <= next_npc;
        xmif.curr_pc_o    <= next_curr_pc;
        xmif.rdat2_o      <= next_rdat2;
        xmif.branchAddr_o <= next_branchAddr;
        xmif.jumpAddr_o   <= next_jumpAddr;
        xmif.zeroExt_o    <= next_zeroExt;
        xmif.port_out_o   <= next_port_out;
        xmif.rs1_o        <= next_rs1;
        xmif.rs2_o        <= next_rs2;
        xmif.rd_o         <= next_rd;
        xmif.branch_o     <= next_branch;
        xmif.regWr_o      <= next_regWr;
        xmif.dWEN_o       <= next_dWEN;
        xmif.dREN_o       <= next_dREN;
        xmif.jpSel_o      <= next_jpSel;
        xmif.rdSel_o      <= next_rdSel;
        xmif.pcSrc_o      <= next_pcSrc;
        xmif.halt_o       <= next_halt;
        xmif.instr_o      <= next_instr;
        xmif.func3_o      <= next_func3;
        xmif.func7_o      <= next_func7;
        xmif.opcode_o     <= next_opcode;
        xmif.imm_o        <= next_imm;
        xmif.dmemstore_o  <= next_dmemstore;
    end
end

always_comb begin
    next_npc = xmif.npc_o; 
    next_curr_pc = xmif.curr_pc_o;
    next_rdat2 = xmif.rdat2_o; 
    next_branchAddr = xmif.branchAddr_o; 
    next_jumpAddr = xmif.jumpAddr_o; 
    next_zeroExt = xmif.zeroExt_o; 
    next_port_out = xmif.port_out_o;
    next_rs1 = xmif.rs1_o; 
    next_rs2 = xmif.rs2_o; 
    next_rd = xmif.rd_o;
    next_branch = xmif.branch_o; 
    next_regWr = xmif.regWr_o; 
    next_dWEN = xmif.dWEN_o; 
    next_dREN = xmif.dREN_o; 
    next_jpSel = xmif.jpSel_o;
    next_rdSel = xmif.rdSel_o;
    next_pcSrc = xmif.pcSrc_o;
    next_halt = xmif.halt_o;
    next_instr = xmif.instr_o;
    next_func3 = xmif.func3_o;
    next_func7 = xmif.func7_o;
    next_imm = xmif.imm_o;
    next_opcode = xmif.opcode_o;
    next_dmemstore = xmif.dmemstore_o;
    if(xmif.flush) begin
        next_npc = '0; 
        next_curr_pc = '0;
        next_rdat2 = '0; 
        next_branchAddr = '0; 
        next_jumpAddr = '0; 
        next_zeroExt = '0; 
        next_port_out = '0;
        next_rs1 = '0; 
        next_rs2 = '0; 
        next_rd = '0;
        next_branch = '0; 
        next_regWr = '0; 
        next_dWEN = '0; 
        next_dREN = '0; 
        next_jpSel = '0;
        next_rdSel = '0;
        next_pcSrc = '0;
        next_halt = '0;
        next_instr = '0;
        next_func3 = '0;
        next_func7 = '0;
        next_opcode = RTYPE;
        next_imm = '0;
        next_dmemstore = '0;
    end
    else if(xmif.dhit) begin
        next_dWEN = '0; 
        next_dREN = '0; 
    end
    else if (xmif.en) begin
        next_npc = xmif.npc_i; 
        next_curr_pc = xmif.curr_pc_i;
        next_rdat2 = xmif.rdat2_i; 
        next_branchAddr = xmif.branchAddr_i; 
        next_jumpAddr = xmif.jumpAddr_i; 
        next_zeroExt = xmif.zeroExt_i; 
        next_port_out = xmif.port_out_i;
        next_rs1 = xmif.rs1_i; 
        next_rs2 = xmif.rs2_i; 
        next_rd = xmif.rd_i;
        next_branch = xmif.branch_i; 
        next_regWr = xmif.regWr_i; 
        next_dWEN = xmif.dWEN_i; 
        next_dREN = xmif.dREN_i; 
        next_jpSel = xmif.jpSel_i;
        next_rdSel = xmif.rdSel_i;
        next_pcSrc = xmif.pcSrc_i;
        next_halt = xmif.halt_i;
        next_instr = xmif.instr_i;
        next_func3 = xmif.func3_i;
        next_func7 = xmif.func7_i;
        next_opcode = xmif.opcode_i;
        next_imm = xmif.imm_i;
        next_dmemstore = xmif.dmemstore_i;
    end
    
    
end

endmodule