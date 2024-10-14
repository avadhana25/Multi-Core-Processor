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

    task reset_inputs;
        begin
            dcif.halt = 0;
            dcif.dmemREN = 0;
            dcif.dmemWEN = 0;
            dcif.datomic = 0;
            dcif.dmemstore = 0;
            dcif.dmemaddr = 0;
            cif.dwait = 1;
            cif.dload = 0;
            cif.ccwait = 0;
            cif.ccinv = 0;
            cif.ccsnoopaddr = 0;
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

    //set inputs
    reset_inputs;


    //TESTCASE 1: LOAD FROM 0x30 AND MISS
    testcase = 1;
    testdesc = "LOAD FROM 0x30 AND MISS";

    testcases(testcase, testdesc);

    dcif.dmemWEN  = 0;
    dcif.dmemREN  = 1;
    dcif.dmemaddr = {29'h30, 1'h0, 2'h0};
    cif.dwait = 0;
    #(PERIOD)
    if (!dcif.dhit && cif.dREN && cif.daddr == dcif.dmemaddr)
    begin
        $display("Initial Miss: Accessing Memory for First Set Element");
    end
    #(PERIOD)
    cif.dload = 32'h444;
    #(PERIOD)
    if (!dcif.dhit && cif.dREN && cif.daddr == dcif.dmemaddr + 4)
    begin
        $display("Initial Miss: Accessing Memory for Second Set Element");
    end
    #(PERIOD)
    cif.dload = 32'h444;


   

    //TESTCASE 2: READ FROM 0x30 AND HIT
    testcase += 1;
    testdesc = "READ FROM 0x30 AND HIT";

    testcases(testcase, testdesc);

    reset_inputs;

    dcif.dmemWEN = 0;
    dcif.dmemREN = 1;
    dcif.dmemaddr = {29'h30, 1'h0, 2'h0};
    #(PERIOD)
    if (dcif.dhit)
    begin
        $display("Succesful Hit at 0x30, dmemload: %0d", dcif.dmemload);
    end

    //TESTCASE 3: READ FROM 0x31 AND HIT
    testcase += 1;
    testdesc = "READ FROM 0x31 AND HIT";

    testcases(testcase, testdesc);
    reset_inputs;

    dcif.dmemWEN = 0;
    dcif.dmemREN = 1;
    dcif.dmemaddr = {29'h30, 1'h1, 2'h0};
    #(PERIOD*2)
    if (dcif.dhit)
    begin
        $display("Succesful Hit at 0x31, dmemload: %0d", dcif.dmemload);
    end






  end

  endprogram