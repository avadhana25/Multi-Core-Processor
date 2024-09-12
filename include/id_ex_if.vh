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

  word_t instr_i, npc_i, instr_o, npc_o, rdat1_i, rdat1_o, rdat2_i, rdat2_o;
  logic en, flush;
  logic regWr_i, regWr_o, dWEN_i, dWEN_o, dREN_i, dREN_o, shift_i, shift_o;
  logic jpSel_i, jpSel_o, aluSrc_i, aluSrc_o, halt_i, halt_o; 
  logic [3:0] aluOp_i, aluOp_o;
  logic [2:0] rdSel_i, rdSel_o;
  logic [1:0] pcSrc_i, pcSrc_o;


  //idex port

  modport idex (
    input instr_i, npc_i, rdat1_i, rdat2_i, regWr_i, dWEN_i, dREN_i,
          shift_i, jpSel_i, aluSrc_i, aluOp_i, rdSel_i, pcSrc_i, halt_i, en, flush,    
    output instr_o, npc_o, rdat1_o, rdat2_o, regWr_o, dWEN_o, dREN_o,
          shift_o, jpSel_o, aluSrc_o, aluOp_o, rdSel_o, pcSrc_o, halt_o
  );
  endinterface

  `endif //ID_EX INTERFACE