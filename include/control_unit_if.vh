/*
  Aakash Vadhanam
  avadhana@purdue.edu

  control unit interface
*/
`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

// types
`include "cpu_types_pkg.vh"

interface control_unit_if;
  // import types
  import cpu_types_pkg::*;


word_t instr;
regbits_t rs1, rs2, rd;
aluop_t aluOp;
logic regWr, dWEN, dREN, aluSrc, jpSel, halt, iREN, atomic;
logic [11:0] imm;
logic [1:0] pcSrc;
logic [2:0] rdSel;

//cu ports
modport cu (
    input instr,
    output rs1, rs2, rd, aluOp, regWr, dWEN, dREN, 
           aluSrc, jpSel, imm, pcSrc, rdSel, halt, iREN, atomic
);

//cu tb
modport tb (
    input rs1, rs2, rd, aluOp, regWr, dWEN, dREN, 
           aluSrc, jpSel, imm, pcSrc, rdSel, halt, iREN, atomic,
    output instr
);
endinterface

`endif //CONTROL_UNIT_IF_VH
