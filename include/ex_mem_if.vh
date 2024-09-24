/*
  Aakash Vadhanam
  avadhana@purdue.edu

   EX_MEM LATCH interface
*/
`ifndef EX_MEM_IF_VH
`define EX_MEM_IF_VH

// types
`include "cpu_types_pkg.vh"

interface ex_mem_if;
  // import types
  import cpu_types_pkg::*;

  word_t branchAddr_i, branchAddr_o, jumpAddr_i, jumpAddr_o, zeroExt_i, zeroExt_o, npc_i, npc_o, port_out_i, port_out_o, rdat2_i, rdat2_o, curr_pc_i, curr_pc_o, instr_i, instr_o, imm_i, imm_o;
  regbits_t rs1_i, rs1_o, rs2_i, rs2_o, rd_i, rd_o;
  logic en, flush, dhit;
  logic halt_i, halt_o, branch_i, branch_o, regWr_i, regWr_o, jpSel_i, jpSel_o, dWEN_i, dWEN_o, dREN_i, dREN_o;
  logic [1:0] pcSrc_i, pcSrc_o;
  logic [2:0] rdSel_i, rdSel_o, func3_i, func3_o;
  logic [6:0] func7_i, func7_o;
  opcode_t opcode_i, opcode_o;



  //exmem port

  modport exmem (
    input en, flush, dhit, branchAddr_i, zeroExt_i, npc_i, port_out_i, rdat2_i, rs1_i, rs2_i, rd_i, func3_i, func7_i, opcode_i,
          halt_i, branch_i, regWr_i, jpSel_i, dWEN_i, dREN_i, pcSrc_i, rdSel_i, jumpAddr_i, curr_pc_i, instr_i, imm_i,
    output branchAddr_o, zeroExt_o, npc_o, port_out_o, rdat2_o, rs1_o, rs2_o, rd_o, func3_o, func7_o, opcode_o, imm_o,
           halt_o, branch_o, regWr_o, jpSel_o, dWEN_o, dREN_o, pcSrc_o, rdSel_o, jumpAddr_o, curr_pc_o, instr_o

  );
  endinterface

  `endif //EX_MEM INTERFACE