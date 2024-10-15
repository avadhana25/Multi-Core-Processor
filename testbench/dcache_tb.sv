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
        word_t start_addr;
        
        if (dcif.dmemaddr[2])
        begin
            start_addr = dcif.dmemaddr - 4;
        end
        else
        begin
            start_addr = dcif.dmemaddr;
        end
        @(posedge CLK);
        cif.dwait = 0;
        if (!dcif.dhit && cif.dREN && cif.daddr == start_addr)
        begin
            $display("Initial Miss: Accessing Memory for First Block Element");
        end
        cif.dload = first_load;
        @(posedge CLK);
        if (!dcif.dhit && cif.dREN && cif.daddr == start_addr + 4)
        begin
            $display("Initial Miss: Accessing Memory for Second Block Element");
        end
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
    dcif.dmemaddr = {26'h3, 3'b000, 1'b0, 2'h0};
    check_access(32'h444, 32'h152);
    

    //TESTCASE 2: READ FROM 0x30 AND HIT
    testcase += 1;
    testdesc = "READ FROM 0x30 AND HIT";

    testcases(testcase, testdesc);

    reset_inputs;

    dcif.dmemWEN = 0;
    dcif.dmemREN = 1;
    dcif.dmemaddr = {26'h3, 3'b000, 1'b0, 2'h0};
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
    dcif.dmemaddr = {26'h3, 3'b000, 1'b1, 2'h0};
    #(PERIOD)
    if (dcif.dhit && dcif.dmemload == 32'h152)
    begin
        $display("Succesful Hit at 0x31, loaded value: %0x", dcif.dmemload);
    end

    //TESTCASE 4: LOAD FROM SAME SET AND MISS
    testcase += 1;
    testdesc = "LOAD FROM SAME SET AND MISS (0x51)";

    testcases(testcase, testdesc);
    reset_inputs;

    dcif.dmemREN = 1;
    dcif.dmemaddr = {26'h5, 3'b000, 1'b1, 2'h0};
    check_access(32'h555, 32'h352);

    //TESTCASE 5: READ FROM 0x50 AND HIT
    testcase += 1;
    testdesc = "READ FROM 0x50 AND HIT";

    testcases(testcase, testdesc);

    reset_inputs;

    dcif.dmemWEN = 0;
    dcif.dmemREN = 1;
    dcif.dmemaddr = {26'h5, 3'b000, 1'b0, 2'h0};
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
    dcif.dmemaddr = {26'h5, 3'b000, 1'b1, 2'h0};
    #(PERIOD)
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
    dcif.dmemaddr = {26'h6, 3'b000, 1'b0, 2'h0};
    check_access(32'h666, 32'h652);

    reset_inputs;

    dcif.dmemWEN = 0;
    dcif.dmemREN = 1;
    dcif.dmemaddr = {26'h3, 3'b000, 1'b0, 2'h0};
    #(PERIOD)
    if (!dcif.dhit)
    begin
        $display("Succesful Miss at 0x30");
    end
    check_access(32'h333, 32'h652);
  


    //INDEX 0 now has tags 6 and 3

    //TESTCASE 8: READ FROM 0x50 AND MISS
    testcase += 1;
    testdesc = "READ FROM 0x50 AND MISS: TAG 5 REPLACED BY TAG 3 ABOVE";

    testcases(testcase, testdesc);
    reset_inputs;

    dcif.dmemWEN = 0;
    dcif.dmemREN = 1;
    dcif.dmemaddr = {26'h5, 3'b000, 1'b0, 2'h0};
    #(PERIOD)
    if (!dcif.dhit)
    begin
        $display("Succesful Miss at 0x50");
    end
    check_access(32'h555, 32'h652);


    //INDEX 0 now has tags 6 and 5

    //TESTCASE 9: STORE DATA INTO 0x32 AND READ
    testcase += 1;
    testdesc = "STORE DATA INTO 0x32 AND READ";

    testcases(testcase, testdesc);
    reset_inputs;

    dcif.dmemWEN = 1;
    dcif.dmemREN = 0;
    dcif.dmemaddr = {26'h3, 3'b001, 1'b0, 2'h0};
    dcif.dmemstore = 32'h999;
    check_access(32'h0, 32'h12);
    $display("Value Stored: %0x", dcif.dmemstore);

    reset_inputs;
    dcif.dmemREN = 1;
    dcif.dmemaddr = {26'h3, 3'b001, 1'b0, 2'h0};
    #(PERIOD)
    if (dcif.dhit && dcif.dmemload == 32'h999)
    begin
        $display("Succesful Hit at 0x32, loaded value: %0x", dcif.dmemload);
    end

    //TESTCASE 10: FILL UP INDEX 1 AND REPLACE 0x32 TO SEE WRITEBACK
    testcase += 1;
    testdesc = "FILL UP INDEX 1 AND REPLACE 0x32 TO SEE WRITEBACK";

    testcases(testcase, testdesc);
    reset_inputs;

    dcif.dmemREN = 1;
    dcif.dmemaddr = {26'h4, 3'b001, 1'b0, 2'h0};
   
    check_access(32'h1234, 32'h5678);

    

    reset_inputs;

    dcif.dmemREN = 1;
    dcif.dmemaddr = {26'h5, 3'b001, 1'b0, 2'h0};
    #(PERIOD)
    cif.dwait = 0;
    if (cif.dWEN && cif.daddr == {26'h3, 3'b001, 1'b0, 2'h0} && cif.dstore == 32'h999)
    begin
        $display("Correct Value Successfully Written Back To Memory");
    end
    #(PERIOD)
    cif.dwait = 0;
    if (cif.dWEN && cif.daddr == {26'h3, 3'b001, 1'b1, 2'h0} && cif.dstore == 32'h12)
    begin
        $display("Correct Value Successfully Written Back To Memory");
    end
    #(4*PERIOD)


    //TESTCASE 11: TEST HALT
    testcase += 1;
    testdesc = "TEST HALT";

   
    reset_inputs;
    testcases(testcase, testdesc);

    dcif.dmemWEN = 1;
    dcif.dmemREN = 0;
    dcif.dmemaddr = {26'h4, 3'b011, 1'b0, 2'h0};
    dcif.dmemstore = 32'h444;
    check_access(32'h0, 32'h12);
    $display("Value Stored: %0x", dcif.dmemstore);



    
    reset_inputs;
    

    dcif.halt = 1;
    #(PERIOD)        
                            //DIRTY_CHECK index 0
    #(PERIOD)
                            //DIRTY_CHECK index 1
    #(PERIOD)
                            //DIRTY_CHECK index 2
    #(PERIOD)
                            //DIRTY_CHECK index 3
    #(PERIOD)
    cif.dwait = 0;            //STORE_2_FLUSH_ONE
    if (cif.dWEN && cif.daddr == {26'h4, 3'b011, 1'b0, 2'h0} && cif.dstore == 32'h444)
    begin
        $display("Correct Value Successfully Written Back To Memory During Flush");
    end
    #(PERIOD)
    if (cif.dWEN && cif.daddr == {26'h4, 3'b011, 1'b1, 2'h0} && cif.dstore == 32'h12)
    begin
        $display("Correct Value Successfully Written Back To Memory During Flush");
    end
    #(PERIOD)
    cif.dwait = 1;         //DIRTY_CHECK index 4
    #(PERIOD)
                     //5
    #(PERIOD)
                  //6
    #(PERIOD)
                  //7
    #(PERIOD)
    
    cif.dwait = 0;
    if (cif.dWEN && cif.daddr == 32'h3100)
    begin
        $display("Hit Counter: %0d", cif.dstore);
    end
    #(2*PERIOD);
    

  end

  endprogram