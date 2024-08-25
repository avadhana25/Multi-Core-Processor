/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/


// mapped needs this
`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;
  logic [31:0] [31:0] register;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  test #(.PERIOD (PERIOD)) PROG ();
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

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


endmodule

program test;
  parameter PERIOD = 10;
  integer testcase;
  string testdesc;
  initial begin
    //initialize inputs
    rfif.wdat = '0;
    rfif.wsel = '0;
    rfif.rsel1 = '0;
    rfif.rsel2 = '0;
    rfif.WEN = 0;

    //TESTCASE 1: ASYNC RESET
    testcase = 1;
    testdesc = "Asynchronous Reset";

    reset_dut;

    $display("TESTCASE %0d: %s", testcase, testdesc);
    for (int i = 0; i < 32; i++) 
    begin
      #(PERIOD)
      #(PERIOD)
      if ((rfif.rdat1 == '0) && (rfif.rdat2 == '0))
      begin
        $display("Register %0d successefully matches", i);
      end
      else
      begin
        $display("Register %0d DOESN'T match", i);
      end
      rfif.rsel1 = rfif.rsel1 + 1;
      rfif.rsel2 = rfif.rsel2 + 1;
    end


    //TESTCASE 2: Write to Register 0
    testcase = 2;
    testdesc = "Write to Register Zero";

    rfif.rsel1 = 0;
    rfif.rsel2 = 0;
    
    reset_dut;

    rfif.WEN = 1;
    rfif.wsel = 0;
    rfif.wdat = $random;

    $display("TESTCASE %0d: %s", testcase, testdesc);
    #(PERIOD)
    #(PERIOD)
    if ((rfif.rdat1 == '0) && (rfif.rdat2 == '0))
    begin
      $display("Register 0 successefully matches");
    end
    else
    begin
      $error("Register 0 DOESN'T match");
    end


    //TESTCASE 3: Writes and Reads to all other registers
    testcase = 3;
    testdesc = "Writes and Reads to All Other Registers";

    reset_dut;

    rfif.WEN = 1;
    rfif.wsel = 5'b1;
    rfif.rsel1 = 5'b1;
    rfif.rsel2 = 5'b1;

    $display("TESTCASE %0d: %s", testcase, testdesc);
    for (int i = 1; i < 32; i++) 
    begin
      rfif.wdat = $random;
      #(PERIOD)
      #(PERIOD)
      if ((rfif.rdat1 == rfif.wdat) && (rfif.rdat2 == rfif.wdat))
      begin
        $display("Register %0d successefully matches random wdat", i);
      end
      else
      begin
        $display("Register %0d DOESN'T match", i);
        $display("Register %0d: %b vs %b", i, rfif.rdat1, rfif.wdat);
      end
      rfif.rsel1 = rfif.rsel1 + 1;
      rfif.rsel2 = rfif.rsel2 + 1;
      rfif.wsel  = rfif.wsel + 1;
    end

    $finish;
      
   
  end
endprogram
