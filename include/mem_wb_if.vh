/*
  Aakash Vadhanam
  avadhana@purdue.edu

   MEM_WB LATCH interface
*/
`ifndef MEM_WB_IF_VH
`define MEM_WB_IF_VH 

// types
`include "cpu_types_pkg.vh"

interface mem_wb_if;
  // import types
  import cpu_types_pkg::*;

  word_t npc_i, npc_o, port_out_i, port_out_o, dmemload_i, dmemload_o, zeroExt_i, zeroExt_o, curr_pc_i, curr_pc_o;
  logic en, flush, dhit;
  regbits_t rs1_i, rs1_o, rs2_i, rs2_o, rd_i, rd_o;
  logic regWr_i, regWr_o, halt_i, halt_o;
  logic [2:0] rdSel_i, rdSel_o;




  //memwb port

  modport memwb (
    input en, flush, dhit, npc_i, port_out_i, dmemload_i, zeroExt_i, rs1_i, rs2_i, rd_i, regWr_i, halt_i, rdSel_i, curr_pc_i,
    output npc_o, port_out_o, dmemload_o, zeroExt_o, rs1_o, rs2_o, rd_o, regWr_o, halt_o, rdSel_o, curr_pc_o

  );
  endinterface

  `endif //MEM_WB INTERFACE