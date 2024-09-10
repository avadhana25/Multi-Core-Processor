/*
  Aakash Vadhanam
  avadhana@purdue.edu

  request unit interface
*/
`ifndef REQUEST_UNIT_IF_VH
`define REQUEST_UNIT_IF_VH

// types
`include "cpu_types_pkg.vh"

interface request_unit_if;
  // import types
  import cpu_types_pkg::*;


logic ihit, dhit, dREN, dWEN, pcen;
logic dmemREN, dmemWEN;

//ru ports
modport ru (
    input ihit, dhit, dREN, dWEN,
    output dmemREN, dmemWEN, pcen
);
endinterface

`endif //REQUEST_UNIT_IF_VH