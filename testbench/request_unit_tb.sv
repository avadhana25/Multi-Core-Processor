/*
    Aakash Vadhanam
    avadhana@purdue.edu

    request unit test bench
*/

// mapped needs this
`include "request_unit_if.vh"

//all types
`include "cpu_types_pkg.vh"

// import types
  import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module request_unit_tb;

parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

// interface
request_unit_if ruif ();

//test program
test #(.PERIOD (PERIOD)) PROG ();

//DUT
`ifndef MAPPED
  request_unit DUT(CLK, nRST, ruif);
`else
  request_unit DUT (
    .\ruif.ihit(ruif.ihit),
    .\ruif.dhit(ruif.dhit),
    .\ruif.dREN(ruif.dREN),
    .\ruif.dWEN(ruif.dWEN),
    .\ruif.dmemREN(ruif.dmemREN),
    .\ruif.dmemWEN(ruif.dmemWEN)

  );
`endif 

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
    initial begin


      //initializie inputs
      ruif.ihit = 0;
      ruif.dhit = 0;
      ruif.dREN = 0;
      ruif.dWEN = 0;

      reset_dut;
      #(PERIOD)
      #(PERIOD)

      ruif.ihit = 1;
      ruif.dREN = 1;

      #(PERIOD)
      #(PERIOD)

      if (ruif.dmemREN == 1)
      begin
        $display("dmemREN accurately asserted");
      end
      else
      begin
        $display("dmemREN NOT accurately asserted");
      end

      #(PERIOD)
      #(PERIOD)

      ruif.dhit = 1;

      #(PERIOD)
      #(PERIOD)

      if (ruif.dmemREN == 0)
      begin
        $display("dmemREN accurately deasserted");
      end
      else
      begin
        $display("dmemREN NOT accurately deasserted");
      end


      reset_dut;
      ruif.ihit = 0;
      ruif.dhit = 0;
      ruif.dREN = 0;
      ruif.dWEN = 0;

      #(PERIOD)
      #(PERIOD)

      ruif.ihit = 1;
      ruif.dWEN = 1;

      #(PERIOD)
      #(PERIOD)

      if (ruif.dmemWEN == 1)
      begin
        $display("dmemWEN accurately asserted");
      end
      else
      begin
        $display("dmemWEN NOT accurately asserted");
      end

      #(PERIOD)
      #(PERIOD)

      ruif.dhit = 1;

      #(PERIOD)
      #(PERIOD)

      if (ruif.dmemWEN == 0)
      begin
        $display("dmemWEN accurately deasserted");
      end
      else
      begin
        $display("dmemWEN NOT accurately deasserted");
      end



    end
    endprogram
