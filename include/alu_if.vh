/*
  Aakash Vadhanam
  avadhana@purdue.edu

  arithmetic logic unit interface
*/
`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface alu_if;
  // import types
  import cpu_types_pkg::*;

  logic negative, zero, overflow;
  aluop_t aluOp;
  word_t port_a, port_b, port_out;


  // alu ports
  modport alu (
    input   aluOp, port_a, port_b,
    output  port_out, negative, overflow, zero
  );
  // register file tb
  modport tb (
    input   port_out, negative, overflow, zero,
    output  aluOp, port_a, port_b
  );
endinterface

`endif //ALU_IF_VH
