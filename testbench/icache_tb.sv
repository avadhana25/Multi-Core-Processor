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

module icache_tb;

    //instantiations
    parameter PERIOD = 10;

    logic CLK = 0, nRST;

    // interfaces
    caches_if cif();
    datapath_cache_if dcif();

    //test program
    test #(.PERIOD(PERIOD)) PROG (CLK, dcif, cif);

    // clock
    always #(PERIOD/2) CLK++;

    //DUT
    icache DUT (CLK, nRST, dcif, cif);

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

program test(input logic CLK, datapath_cache_if.icache dcif, caches_if.icache cif);
  parameter PERIOD = 10;
  integer testcase;
  string testdesc;
  initial 
  begin


    //initialize values
    dcif.imemREN = '1;
    dcif.imemaddr = '0;
    cif.iwait = '1;
    cif.iload = '0;

    reset_dut;
    //TESTCASE 1: read from address with tag aa and miss
    testcase = 1;
    testdesc = "read from address with tag aa and miss";

    testcases(testcase, testdesc);

    dcif.imemREN = 1'b1;
    dcif.imemaddr = {26'haa,4'h5,2'b0} ;
    @(posedge CLK);
    @(posedge CLK);
    if(cif.iREN != 1'b1) begin
        $display("iREN not asserted!");
    end
    if(cif.iaddr != {26'haa,4'h5,2'b0}) begin
        $display("iaddr incorrect!");
    end

    @(posedge CLK);

    cif.iwait = 1'b0;
    cif.iload = 32'h92a7b913;

    @(posedge CLK);
    cif.iwait = 1'b1;
    @(posedge CLK)
    if(dcif.ihit != 1'b1) begin
        $display("ihit not asserted!");
    end
    if(dcif.imemload != 32'h92a7b913) begin
        $display("incorrect instruction!");
    end

    //reset values
    dcif.imemREN = '1;
    dcif.imemaddr = '0;
    cif.iwait = '1;
    cif.iload = '0;
    @(posedge CLK)

    //TESTCASE 2: read from address with tag aa and hit
    testcase = 2;
    testdesc = "read from address with tag aa and hit";

    testcases(testcase, testdesc);

    dcif.imemREN = 1'b1;
    dcif.imemaddr = {26'haa,4'h5,2'b0} ;
    #(1);
    if(cif.iREN != 1'b0) begin
        $display("iREN not asserted!");
    end
    if(cif.iaddr != '0) begin
        $display("iaddr incorrect!");
    end
    if(dcif.ihit != 1'b1) begin
        $display("ihit not asserted!");
    end
    if(dcif.imemload != 32'h92a7b913) begin
        $display("incorrect instruction!");
    end
    #(10);
    
    //reset values
    dcif.imemREN = '1;
    dcif.imemaddr = '0;
    cif.iwait = '1;
    cif.iload = '0;
    @(posedge CLK)

    //TESTCASE 3: read from address with tag bb and miss
    testcase = 3;
    testdesc = "read from address with tag bb and miss";

    testcases(testcase, testdesc);

    dcif.imemREN = 1'b1;
    dcif.imemaddr = {26'hbb,4'ha,2'b0} ;
    @(posedge CLK);
    @(posedge CLK);
    if(cif.iREN != 1'b1) begin
        $display("iREN not asserted!");
    end
    if(cif.iaddr != {26'hbb,4'ha,2'b0}) begin
        $display("iaddr incorrect!");
    end

    @(posedge CLK);

    cif.iwait = 1'b0;
    cif.iload = 32'ha9102b3f;

    @(posedge CLK);
    cif.iwait = 1'b1;
    @(posedge CLK)
    if(dcif.ihit != 1'b1) begin
        $display("ihit not asserted!");
    end
    if(dcif.imemload != 32'ha9102b3f) begin
        $display("incorrect instruction!");
    end

    //reset values
    dcif.imemREN = '1;
    dcif.imemaddr = '0;
    cif.iwait = '1;
    cif.iload = '0;
    @(posedge CLK)

    //TESTCASE 4: read from address with tag cc and index 5 to overwrite aa
    testcase = 4;
    testdesc = "read from address with tag cc and index 5 to overwrite aa";

    testcases(testcase, testdesc);

    dcif.imemREN = 1'b1;
    dcif.imemaddr = {26'hcc,4'h5,2'b0} ;
    @(posedge CLK);
    @(posedge CLK);
    if(cif.iREN != 1'b1) begin
        $display("iREN not asserted!");
    end
    if(cif.iaddr != {26'hcc,4'h5,2'b0}) begin
        $display("iaddr incorrect!");
    end

    @(posedge CLK);

    cif.iwait = 1'b0;
    cif.iload = 32'h1234abcd;

    @(posedge CLK);
    cif.iwait = 1'b1;
    @(posedge CLK)
    if(dcif.ihit != 1'b1) begin
        $display("ihit not asserted!");
    end
    if(dcif.imemload != 32'h1234abcd) begin
        $display("incorrect instruction!");
    end

    //reset values
    dcif.imemREN = '1;
    dcif.imemaddr = '0;
    cif.iwait = '1;
    cif.iload = '0;
    @(posedge CLK)

    //TESTCASE 5: read from address with tag aa and miss
    testcase = 5;
    testdesc = "read from address with tag aa and miss";

    testcases(testcase, testdesc);

    dcif.imemREN = 1'b1;
    dcif.imemaddr = {26'haa,4'h7,2'b0} ;
    @(posedge CLK);
    @(posedge CLK);
    if(cif.iREN != 1'b1) begin
        $display("iREN not asserted!");
    end
    if(cif.iaddr != {26'haa,4'h7,2'b0}) begin
        $display("iaddr incorrect!");
    end

    @(posedge CLK);

    cif.iwait = 1'b0;
    cif.iload = 32'h1234abcd;

    @(posedge CLK);
    cif.iwait = 1'b1;
    @(posedge CLK)
    if(dcif.ihit != 1'b1) begin
        $display("ihit not asserted!");
    end
    if(dcif.imemload != 32'h1234abcd) begin
        $display("incorrect instruction!");
    end

    #(20);

  end

  endprogram