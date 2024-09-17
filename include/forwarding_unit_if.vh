/*
  Aakash Vadhanam
  avadhana@purdue.edu

  forwarding unit interface
*/
`ifndef FORWARDING_UNIT_IF_VH
`define FORWARDING_UNIT_IF_VH

// types
`include "cpu_types_pkg.vh"

interface forwarding_unit_if;
  // import types
  import cpu_types_pkg::*;


regbits_t xm_rd, mw_rd, dx_rs1, dx_rs2;        //source and dest regs to check
logic xm_regWr, mw_regWr;                      //to confirm that register is being written to
logic [1:0] forwardA, forwardB;                //signals to change rdat1 and rdat2


//fu ports
modport fu (
    input xm_rd, mw_rd, dx_rs1, dx_rs2, xm_regWr, mw_regWr,
    output forwardA, forwardB
);

//fu tb
modport tb (
    input forwardA, forwardB,
    output xm_rd, mw_rd, dx_rs1, dx_rs2, xm_regWr, mw_regWr
);
endinterface

`endif //FORWARDING_UNIT_IF_VH


