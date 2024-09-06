/*
  Aakash Vadhanam
  avadhana@purdue.edu

  memory control test bench
*/

// mapped needs this
`include "cache_control_if.vh"
`include "cpu_ram_if.vh"

//all types
`include "cpu_types_pkg.vh"

// import types
  import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;

//instantiations
parameter PERIOD = 10;

logic CLK = 0, nRST;
caches_if cif0();
caches_if cif1();

// interfaces
cache_control_if ccif(cif0, cif1);
cpu_ram_if ramif();

//test program
test #(.PERIOD(PERIOD)) PROG ();

// clock
always #(PERIOD/2) CLK++;

//DUT
  memory_control DUT(ccif);

  ram LINK(CLK, nRST, ramif);

  //connect cache input/output and ram input/output
  assign ramif.ramaddr = ccif.ramaddr;
  assign ramif.ramstore = ccif.ramstore;
  assign ramif.ramREN = ccif.ramREN;
  assign ramif.ramWEN = ccif.ramWEN;
  assign ccif.ramstate = ramif.ramstate;
  assign ccif.ramload = ramif.ramload;

//tasks 

task testcases;
    input  integer testcase;
    input  string testdesc;
    begin
        $display("\nTESTCASE %0d: %s\n", testcase, testdesc);
    end
endtask

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

//add paremter i******
task readn_instruction;
input integer i;
begin
    cif0.iaddr = cif0.iaddr + 4;
    cif0.dREN = 0;
    cif0.dWEN = 0;
    #(PERIOD)
    if ((ccif.ramaddr == cif0.iaddr) && (ccif.ramload == cif0.iload))
    begin
        $display("Instruction %0d succesfully read", i + 1);
    end
    else
    begin
        $display("Instruction %0d UNSUCCESFULLY read", i + 1);
    end
end
endtask

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

program test;
  parameter PERIOD = 10;
  integer testcase;
  string testdesc;
  initial 
  begin

    //TESTCASE 1: Intruction read
    testcase = 1;
    testdesc = "INSTRUCTION READS";
    testcases(testcase, testdesc);

    reset_dut;

    //inputs
    cif0.iREN = 1'b1;
    cif0.dREN = 1'b0;
    cif0.dWEN = 1'b0;
    cif0.iaddr = '0;
    cif0.daddr = '0;


    for (int i = 0; i <= 5 ; i++) 
    begin
        readn_instruction(i);
    end

    //TESTACASE 2: LOAD MEMORY
    testcase = 2;
    testdesc = "LOADS TO MEMORY";
    testcases(testcase, testdesc);

    reset_dut;

    //inputs
    cif0.iREN = 1'b1;
    cif0.dREN = 1'b0;
    cif0.dWEN = 1'b0;
    cif0.iaddr = '0;
    cif0.daddr = '0;

    for (int i = 0; i <= 5 ; i++) 
    begin
        readn_instruction(i);

        cif0.daddr = cif0.daddr + 4;
        cif0.dREN = 1'b1;
        #(PERIOD * 2)
        if ((ccif.ramaddr == cif0.daddr) && (ccif.ramload == cif0.dload) && (ccif.dwait == 0))
        begin
            $display("Data in Memory %0d succesfully read: %h", i + 1, ccif.ramload);
        end
        else
        begin
            $display("Data in Memory %0d UNSUCCESFULLY read", i + 1);
        end

    end

    //TESTCASE 3: STORE MEMORY
    testcase = 3;
    testdesc = "STORES TO MEMORY";
    testcases(testcase, testdesc);

    reset_dut;

    //inputs
    cif0.iREN = 1'b1;
    cif0.dREN = 1'b0;
    cif0.dWEN = 1'b0;
    cif0.iaddr = '0;
    cif0.daddr = 32'h400;

    for (int i = 0; i <= 5 ; i++) 
    begin
        readn_instruction(i);

        cif0.daddr = cif0.daddr + 4;
        cif0.dWEN = 1'b1;
        cif0.dstore = 32'hA;
        #(PERIOD*2)
        if ((ccif.ramaddr == cif0.daddr) && (ccif.ramstore == cif0.dstore) && (ccif.dwait == 0))
        begin
            $display("Data in Memory %0d succesfully loaded", i + 1);
        end
        else
        begin
            $display("Data in Memory %0d UNSUCCESFULLY loaded", i + 1);
        end
    end
    dump_memory();
    $finish;

  end
  endprogram