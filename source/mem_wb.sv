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

word_t next_npc, next_curr_pc, next_port_out, next_dmemload, next_zeroExt, next_jumpAddr, next_branchAddr, next_instr, next_imm;
logic [4:0] next_rs1, next_rs2, next_rd;
logic next_regWr, next_halt;
logic [2:0] next_rdSel, next_func3;
logic [6:0] next_func7;
opcode_t next_opcode;

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
        mwif.jumpAddr_o   <= 32'b0;
        mwif.branchAddr_o <= 32'b0;
        mwif.instr_o      <= 32'b0;
        mwif.func3_o      <= 3'b0;
        mwif.func7_o      <= 7'b0;
        mwif.opcode_o     <= RTYPE;
        mwif.imm_o        <= 32'b0; 
    end
    else
    begin
        mwif.npc_o        <= next_npc;
        mwif.curr_pc_o    <= next_curr_pc;
        mwif.port_out_o   <= next_port_out;
        mwif.dmemload_o   <= next_dmemload;
        mwif.zeroExt_o    <= next_zeroExt;
        mwif.rs1_o        <= next_rs1;
        mwif.rs2_o        <= next_rs2;
        mwif.rd_o         <= next_rd;
        mwif.regWr_o      <= next_regWr;
        mwif.halt_o       <= next_halt;
        mwif.rdSel_o      <= next_rdSel;
        mwif.jumpAddr_o   <= next_jumpAddr;
        mwif.branchAddr_o <= next_branchAddr;
        mwif.instr_o      <= next_instr;
        mwif.func3_o      <= next_func3;
        mwif.func7_o      <= next_func7;
        mwif.opcode_o     <= next_opcode;
        mwif.imm_o        <= next_imm; 
    end
end

always_comb begin
    next_npc = mwif.npc_o; 
    next_curr_pc = mwif.curr_pc_o; 
    next_port_out = mwif.port_out_o; 
    next_dmemload = mwif.dmemload_o; 
    next_zeroExt = mwif.zeroExt_o;
    next_rs1 = mwif.rs1_o; 
    next_rs2 = mwif.rs2_o; 
    next_rd = mwif.rd_o;
    next_regWr = mwif.regWr_o; 
    next_halt = mwif.halt_o;
    next_rdSel = mwif.rdSel_o;
    next_jumpAddr = mwif.jumpAddr_o;
    next_branchAddr = mwif.branchAddr_o;
    next_instr = mwif.instr_o;
    next_func3 = mwif.func3_o;
    next_func7 = mwif.func7_o;
    next_opcode = mwif.opcode_o;
    next_imm = mwif.imm_o;
    if(mwif.flush) begin
        next_npc = '0; 
        next_curr_pc = '0; 
        next_port_out = '0; 
        next_dmemload = '0; 
        next_zeroExt = '0;
        next_rs1 = '0; 
        next_rs2 = '0; 
        next_rd = '0;
        next_regWr = '0; 
        next_halt = '0;
        next_rdSel = '0;
        next_jumpAddr = '0;
        next_branchAddr = '0;
        next_instr = '0;
        next_func3 = '0;
        next_func7 = '0;
        next_opcode = RTYPE;
        next_imm = '0;
    end
 //   else if (mwif.dhit)
 //   begin
 //       next_dmemload = mwif.dmemload_i;
 //   end
    else if (mwif.en) begin
        next_npc = mwif.npc_i; 
        next_curr_pc = mwif.curr_pc_i; 
        next_port_out = mwif.port_out_i; 
        next_dmemload = mwif.dmemload_i; 
        next_zeroExt = mwif.zeroExt_i;
        next_rs1 = mwif.rs1_i; 
        next_rs2 = mwif.rs2_i; 
        next_rd = mwif.rd_i;
        next_regWr = mwif.regWr_i; 
        next_halt = mwif.halt_i;
        next_rdSel = mwif.rdSel_i;
        next_jumpAddr = mwif.jumpAddr_i;
        next_branchAddr = mwif.branchAddr_i;
        next_instr = mwif.instr_i;
        next_func3 = mwif.func3_i;
        next_func7 = mwif.func7_i;
        next_opcode = mwif.opcode_i;
        next_imm = mwif.imm_i;
    end
end

endmodule