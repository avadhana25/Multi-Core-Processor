/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
<<<<<<< HEAD
  parameter CPUS = 2;
=======
  parameter CPUS = 1;
>>>>>>> 0993c6e9ef29110898425c513d61e32a1032dceb

endmodule
