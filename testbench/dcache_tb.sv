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
    test #(.PERIOD(PERIOD)) PROG (CLK);

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

    task check_access;
    input word_t first_load;
    input word_t second_load;
    begin
        cif.dwait = 0;
        @(posedge CLK);
        if (!dcif.dhit && cif.dREN && cif.daddr == dcif.dmemaddr)
        begin
            $display("Initial Miss: Accessing Memory for First Block Element");
        end
        @(posedge CLK);
        cif.dload = first_load;
        @(posedge CLK);
        if (!dcif.dhit && cif.dREN && cif.daddr == dcif.dmemaddr + 4)
        begin
            $display("Initial Miss: Accessing Memory for Second Block Element");
        end
        @(posedge CLK);
        cif.dload = second_load;
        @(posedge CLK);
        @(posedge CLK);
    end
    endtask



endmodule

program test(input logic CLK);
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
    dcif.dmemaddr = {25'h3, 4'h0, 1'h0, 2'h0};
    check_access(32'h444, 32'h152);
    

    //TESTCASE 2: READ FROM 0x30 AND HIT
    testcase += 1;
    testdesc = "READ FROM 0x30 AND HIT";

    testcases(testcase, testdesc);

    reset_inputs;

    dcif.dmemWEN = 0;
    dcif.dmemREN = 1;
    dcif.dmemaddr = {25'h3, 4'h0, 1'h0, 2'h0};
    #(PERIOD)
    if (dcif.dhit && dcif.dmemload == 32'h444)
    begin
        $display("Succesful Hit at 0x30, loaded value: %0x", dcif.dmemload);
    end

    //TESTCASE 3: READ FROM 0x31 AND HIT
    testcase += 1;
    testdesc = "READ FROM 0x31 AND HIT";

    testcases(testcase, testdesc);
    reset_inputs;

    dcif.dmemWEN = 0;
    dcif.dmemREN = 1;
    dcif.dmemaddr = {25'h3, 4'h0, 1'h1, 2'h0};
    #(PERIOD*2)
    if (dcif.dhit && dcif.dmemload == 32'h152)
    begin
        $display("Succesful Hit at 0x31, loaded value: %0x", dcif.dmemload);
    end

    //TESTCASE 4: LOAD FROM SAME SET AND MISS
    testcase += 1;
    testdesc = "LOAD FROM SAME SET AND MISS (0x50)";

    testcases(testcase, testdesc);
    reset_inputs;

    dcif.dmemREN = 1;
    dcif.dmemaddr = {25'h5, 4'h0, 1'h0, 2'h0};
    check_access(32'h555, 32'h352);

    //TESTCASE 5: READ FROM 0x50 AND HIT
    testcase += 1;
    testdesc = "READ FROM 0x50 AND HIT";

    testcases(testcase, testdesc);

    reset_inputs;

    dcif.dmemWEN = 0;
    dcif.dmemREN = 1;
    dcif.dmemaddr = {25'h5, 4'h0, 1'h0, 2'h0};
    #(PERIOD)
    if (dcif.dhit && dcif.dmemload == 32'h555)
    begin
        $display("Succesful Hit at 0x50, loaded value: %0x", dcif.dmemload);
    end

    //TESTCASE 6: READ FROM 0x51 AND HIT
    testcase += 1;
    testdesc = "READ FROM 0x51 AND HIT";

    testcases(testcase, testdesc);
    reset_inputs;

    dcif.dmemWEN = 0;
    dcif.dmemREN = 1;
    dcif.dmemaddr = {25'h5, 4'h0, 1'h1, 2'h0};
    #(PERIOD*2)
    if (dcif.dhit && dcif.dmemload == 32'h352)
    begin
        $display("Succesful Hit at 0x51, loaded value: %0x", dcif.dmemload);
    end

    //TESTCASE 7: LOAD FROM SAME INDEX AND REPLACE TAG 3 (LRU)
    testcase += 1;
    testdesc = "LOAD FROM SAME INDEX AND REPLACE TAG 3 (LRU), READING TAG 3 WILL MISS";

    testcases(testcase, testdesc);
    reset_inputs;

    dcif.dmemREN = 1;
    dcif.dmemaddr = {25'h6, 4'h0, 1'h0, 2'h0};
    check_access(32'h666, 32'h652);

    reset_inputs;

    dcif.dmemWEN = 0;
    dcif.dmemREN = 1;
    dcif.dmemaddr = {25'h3, 4'h0, 1'h0, 2'h0};
    #(PERIOD)
    if (!dcif.dhit)
    begin
        $display("Succesful Miss at 0x30");
    end

    //INDEX 0 now has tags 6 and 3

    //TESTCASE 8: READ FROM 0x50 AND MISS
    testcase += 1;
    testdesc = "READ FROM 0x50 AND MISS: TAG 5 REPLACED BY TAG 3 ABOVE";

    testcases(testcase, testdesc);
    reset_inputs;

    dcif.dmemWEN = 0;
    dcif.dmemREN = 1;
    dcif.dmemaddr = {25'h5, 4'h0, 1'h0, 2'h0};
    #(PERIOD)
    if (!dcif.dhit)
    begin
        $display("Succesful Miss at 0x50");
    end













  end

  endprogram