/*
  Aakash Vadhanam
  avadhana@purdue.edu

   ID_EX LATCH interface
*/
`ifndef ID_EX_IF_VH
`define ID_EX_IF_VH

// types
`include "cpu_types_pkg.vh"

interface id_ex_if;
  // import types
  import cpu_types_pkg::*;

  word_t instr_i, npc_i, instr_o, npc_o, rdat1_i, rdat1_o, rdat2_i, rdat2_o, curr_pc_i, curr_pc_o;
  logic en, flush, freeze;
  logic regWr_i, regWr_o, dWEN_i, dWEN_o, dREN_i, dREN_o, atomic_i, atomic_o;
  logic jpSel_i, jpSel_o, aluSrc_i, aluSrc_o, halt_i, halt_o; 
  aluop_t aluOp_i, aluOp_o;
  logic [2:0] rdSel_i, rdSel_o;
  logic [1:0] pcSrc_i, pcSrc_o;


  //idex port

  modport idex (
    input instr_i, npc_i, rdat1_i, rdat2_i, regWr_i, dWEN_i, dREN_i, curr_pc_i,
          jpSel_i, aluSrc_i, aluOp_i, rdSel_i, pcSrc_i, halt_i, atomic_i, en, flush, freeze,    
    output instr_o, npc_o, rdat1_o, rdat2_o, regWr_o, dWEN_o, dREN_o, curr_pc_o,
          jpSel_o, aluSrc_o, aluOp_o, rdSel_o, pcSrc_o, halt_o, atomic_o
  );
  endinterface

  `endif //ID_EX INTERFACE