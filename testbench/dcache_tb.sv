/*
    Aakash Vadhanam
    avadhana@purdue.edu

    dcache test bench
*/

// mapped needs this
`include "datapath_cache_if.vh"
`include "caches_if.vh"
`include "cache_control_if.vh"
`include "cpu_ram_if.vh"

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
    caches_if cif0();
    caches_if cif1();

    datapath_cache_if dcif0();
    datapath_cache_if dcif1();
    cache_control_if ccif(cif0, cif1);
    cpu_ram_if ramif();

    //test program
    test #(.PERIOD(PERIOD)) PROG (CLK);

    // clock
    always #(PERIOD/2) CLK++;

    //DUT
    dcache DC0 (CLK, nRST, dcif0, cif0);
    dcache DC1 (CLK, nRST, dcif1, cif1);
    memory_control MC (CLK, nRST, ccif);
    ram LINK (CLK, nRST, ramif);

    //connect cache input/output and ram input/output
    assign ramif.ramaddr = ccif.ramaddr;
    assign ramif.ramstore = ccif.ramstore;
    assign ramif.ramREN = ccif.ramREN;
    assign ramif.ramWEN = ccif.ramWEN;
    assign ccif.ramstate = ramif.ramstate;
    assign ccif.ramload = ramif.ramload;

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
            dcif0.halt = 0;
            dcif0.dmemREN = 0;
            dcif0.dmemWEN = 0;
            dcif0.datomic = 0;
            dcif0.dmemstore = 0;
            dcif0.dmemaddr = 0;
            dcif1.halt = 0;
            dcif1.dmemREN = 0;
            dcif1.dmemWEN = 0;
            dcif1.datomic = 0;
            dcif1.dmemstore = 0;
            dcif1.dmemaddr = 0;
        end
    endtask


    task testcases;
        input  integer testcase;
        input  string testdesc;
        begin
            $display("\nTESTCASE %0d: %s\n", testcase, testdesc);
        end
    endtask
/*
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
*/
    task automatic dump_memory();
    string filename = "memcpu.hex";
    int memfd;

    cif0.daddr = 0;
    cif0.dWEN = 0;
    cif0.dREN = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      cif0.daddr = i << 2;
      cif0.dREN = 1;
      repeat (4) @(posedge CLK);
      if (cif0.dload === 0)
        continue;
      values = {8'h04,16'(i),8'h00,cif0.dload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),cif0.dload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      cif0.dREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask



endmodule

program test(input logic CLK);
  parameter PERIOD = 10;
  integer testcase;
  string testdesc;
  logic [31:0] temp_load;
  initial 
  begin


    reset_dut;

    //set inputs
    reset_inputs;

    //TESTCASE 1: CORE 0 Write TO 0x30, THEN CORE 1 READ SAME ADDRESS, LRU will pick core0 first, tests if both miss at same time
    testcase = 1;
    testdesc = "CORE 1 SNOOP INTO CORE 0 for 0x30";
    testcases(testcase, testdesc);

    dcif0.dmemWEN = 1'b1;
    dcif0.dmemREN = 1'b0;
    dcif0.dmemaddr = {26'h3, 3'b000, 1'b0, 2'h0};
    dcif0.dmemstore = 32'h1111;

    dcif1.dmemWEN = 1'b0;
    dcif1.dmemREN = 1'b1;
    dcif1.dmemaddr = {26'h3, 3'b000, 1'b0, 2'h0};

    @(posedge dcif0.dhit)
    dcif0.dmemWEN = 1'b0;
    dcif0.dmemREN = 1'b0;





    

    @(posedge dcif1.dhit)                                //core 0 should start in M and then core 0 and core 1 should both be in S
    dcif1.dmemWEN = 1'b0;
    dcif1.dmemREN = 1'b0;

    if (dcif1.dmemload == dcif0.dmemstore)
    begin
        $display("Accurately read from Core 0");
    end

    //TESTCASE 2: CORE 0 Write TO 0x30 again - send CORE 1 to Inavlid
    testcase++;
    testdesc = "CORE 1 WRITE TO 0x30 - INVALIDATE CORE 1";
    testcases(testcase, testdesc);

    reset_inputs;

    dcif0.dmemWEN = 1'b1;
    dcif0.dmemREN = 1'b0;
    dcif0.dmemaddr = {26'h3, 3'b000, 1'b0, 2'h0};
    dcif0.dmemstore = 32'h2222;



    #(PERIOD)
    dcif0.dmemWEN = 1'b0;                        //FAILS NEEDS TO INVALIDATE OTHER CORE
    dcif0.dmemREN = 1'b0;

    #(PERIOD)
    dcif0.dmemWEN = 1'b0;                           //to fix lru until test case fixed
    dcif0.dmemREN = 1'b1;
    dcif0.dmemaddr = {26'h3, 3'b011, 1'b0, 2'h0};
    
    @(posedge dcif0.dhit)


    //TESTCASE 3: BOTH CORES READ MISS AT SAME TIME , ALSO TESTS LRU CORE 1 SHOULD GET BUS FIRST
    testcase++;
    testdesc = "BOTH CORES READ MISS AT SAME TIME";
    testcases(testcase, testdesc);

    reset_inputs;

    dcif0.dmemWEN = 1'b0;
    dcif0.dmemREN = 1'b1;
    dcif0.dmemaddr = {26'h0, 3'b001, 1'b0, 2'h0};


    dcif1.dmemREN = 1'b1;
    dcif1.dmemaddr = {26'h0, 3'b001, 1'b0, 2'h0};

    @(posedge dcif1.dhit)
    dcif1.dmemWEN = 1'b0;
    dcif1.dmemREN = 1'b0;
    temp_load = dcif1.dmemload;






    

    @(posedge dcif0.dhit)                                //both should be in S
    dcif0.dmemWEN = 1'b0;
    dcif0.dmemREN = 1'b0;

    if (dcif0.dmemload == temp_load)
    begin
        $display("Both Cores Accurately Retreived Data");            
    end


    //TESTCASE 4: BOTH CORES WRITE TO 0x50
    testcase++;
    testdesc = "BOTH CORES WRITE TO 0x50";
    testcases(testcase, testdesc);

    reset_inputs;

    dcif0.dmemWEN = 1'b1;
    dcif0.dmemREN = 1'b0;
    dcif0.dmemaddr = {26'h5, 3'b000, 1'b0, 2'h0};
    dcif0.dmemstore = 32'h4444;


    dcif1.dmemWEN = 1'b1;
    dcif1.dmemREN = 1'b0;
    dcif1.dmemaddr = {26'h5, 3'b000, 1'b1, 2'h0};
    dcif1.dmemstore = 32'h4242;

    @(posedge dcif1.dhit)      //core 1 should be in M
    dcif1.dmemWEN = 1'b0;
    dcif1.dmemREN = 1'b0;
   
    
    @(posedge dcif0.dhit)                                //core 0 should be in M, core 1 in I
    dcif0.dmemWEN = 1'b0;
    dcif0.dmemREN = 1'b0;


    //TESTCASE 5: CORE 1 TRIES TO ACCESS CACHE 1 CYCLE AFTER CORE 0               //HAS THE REPLACE DIRTY BACK ISSUE...CORE 1 TAKES OVER POST CORE 0 STORE BACK AND REAL WRITE
    testcase++;
    testdesc = "CORE 1 TRIES TO ACCESS CACHE 1 CYCLE AFTER CORE 0";
    testcases(testcase, testdesc);

    reset_inputs;

    dcif0.dmemWEN = 1'b1;
    dcif0.dmemREN = 1'b0;
    dcif0.dmemaddr = {26'h6, 3'b000, 1'b0, 2'h0};
    dcif0.dmemstore = 32'h5555;

    #(2*PERIOD)
    dcif1.dmemWEN = 1'b0;
    dcif1.dmemREN = 1'b1;
    dcif1.dmemaddr = {26'h6, 3'b000, 1'b1, 2'h0};

    @(posedge dcif0.dhit)      //core 0 should be in M
    dcif0.dmemWEN = 1'b0;
    dcif0.dmemREN = 1'b0;
   
    
    @(posedge dcif1.dhit)                        //core 0 should be in S, core 1 in S
    dcif1.dmemWEN = 1'b0;
    dcif1.dmemREN = 1'b0;

    if (dcif1.dmemload == dcif0.dmemstore)
    begin
        $display("Accurately read from Core 0");
    end


 








    




    testcase = 0;
    testdesc = "done";
    dump_memory();
    $finish;

















  end
endprogram
 










































/*
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

  */