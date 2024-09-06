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
  input logic CLK, nRST, cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 1;



  //dwait logic
  always_comb
  begin
    //default value
    ccif.dwait = 1'b1;

    //logic
    if ((ccif.dREN || ccif.dWEN) && (ccif.ramstate == ACCESS))
    begin
      ccif.dwait = 1'b0;
    end
  end

  //iwait logic
  always_comb
  begin
    //default value
    ccif.iwait = 1'b1;

    //logic
    if ((!(ccif.dREN || ccif.dWEN)) && (ccif.ramstate == ACCESS))
    begin
      ccif.iwait = 1'b0;
    end
  end

  //ramREN logic
  assign ccif.ramREN = ~ccif.dWEN;

  //ramWEN logic
  assign ccif.ramWEN = ccif.dWEN;

  //ramstore logic
  assign ccif.ramstore = ccif.dstore;

  //iload logic
  assign ccif.iload = ccif.dREN ? 32'b0 : ccif.ramload;

  //dload logic
  assign ccif.dload = ccif.dREN ? ccif.ramload : 32'b0;

  //ramaddr logic
  assign ccif.ramaddr = (ccif.dREN || ccif.dWEN) ? ccif.daddr : ccif.iaddr;


endmodule
