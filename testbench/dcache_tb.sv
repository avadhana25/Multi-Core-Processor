/*
    Aakash Vadhanam
    avadhana@purdue.edu

    dcache test bench
*/

// mapped needs this
`include "datapath_cache_if.vh"
`include "caches_if.vh"

//all types
`include "cpu_types_pkg.vh"

// import types
  import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module dcache_tb;

    //instantiations
    parameter PERIOD = 10;

    logic CLK = 0, nRST;

    // interfaces
    caches_if cif();
    datapath_cache_if dcif();

    //test program
    test #(.PERIOD(PERIOD)) PROG ();

    // clock
    always #(PERIOD/2) CLK++;

    //DUT
    dcache DUT (CLK, nRST, dcif, cif);

    //tasks
    task reset_dut;
        begin

        nRST = 1'b0;
        @(posedge CLK);
        @(posedge CLK);
        @(negedge CLK);
        nRST = 1'b1;
        @(posedge CLK);
        @(posedge CLK);
        end
    endtask

    task testcases;
        input  integer testcase;
        input  string testdesc;
        begin
            $display("\nTESTCASE %0d: %s\n", testcase, testdesc);
        end
    endtask



endmodule

program test;
  parameter PERIOD = 10;
  integer testcase;
  string testdesc;
  initial 
  begin


    reset_dut;

    //TESTCASE 1: LOAD FROM 0x30 AND MISS
    testcase = 1;
    testdesc = "LOAD FROM 0x30 AND MISS";

    testcases(testcase, testdesc);
    



  end

  endprogram