/*
  Aakash Vadhanam
  avadhana@purdue.edu

  program counter interface
*/
`ifndef PROGRAM_COUNTER_IF_VH
`define PROGRAM_COUNTER_IF_VH

// types
`include "cpu_types_pkg.vh"

interface program_counter_if;
  // import types
  import cpu_types_pkg::*;

word_t curr_pc, new_pc, npc;
logic en;

//pc ports
modport pc (
    input en, new_pc,
    output curr_pc, npc 
);

endinterface

`endif //PROGRAM_COUNTER_IF_VH