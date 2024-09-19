/*
   hazard detection unit interface
*/
`ifndef HAZARD_DETECTION_UNIT_IF_VH
`define HAZARD_DETECTION_UNIT_IF_VH

// types
`include "cpu_types_pkg.vh"

interface hazard_detection_unit_if;
  // import types
  import cpu_types_pkg::*;

  logic memRead, freeze, branch, jump, threeInstrFlush;
  regbits_t rs1, rs2, rd;
  //hdu port

  modport hdu (
    input memRead, rs1, rs2, rd, branch, jump,
    output freeze, threeInstrFlush
  );

  modport tb (
    input freeze, threeInstrFlush,
    output memRead, rs1, rs2, rd, branch, jump
  )
  endinterface

  `endif //HAZARD_DETECTION_UNIT INTERFACE