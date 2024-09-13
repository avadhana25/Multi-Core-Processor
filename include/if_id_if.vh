/*
  Aakash Vadhanam
  avadhana@purdue.edu

   IF_ID LATCH interface
*/
`ifndef IF_ID_IF_VH
`define IF_ID_IF_VH

// types
`include "cpu_types_pkg.vh"

interface if_id_if;
  // import types
  import cpu_types_pkg::*;

  word_t instr_i, npc_i, curr_pc_i, instr_o, npc_o, curr_pc_o;
  logic en, flush;

  //ifid port

  modport ifid (
    input instr_i, npc_i, curr_pc_i, en, flush,
    output instr_o, npc_o, curr_pc_o
  );
  endinterface

  `endif //IF_ID INTERFACE