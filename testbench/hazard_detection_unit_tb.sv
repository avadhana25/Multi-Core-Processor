/*
  Aakash Vadhanam
  avadhana@purdue.edu

  hazard detectio unit test bench
*/

// mapped needs this
`include "hazard_detection_unit_if.vh"

//all types
`include "cpu_types_pkg.vh"

// import types
  import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module hazard_detection_unit_tb;

hazard_detection_unit_if hduif();

hazard_detection_unit DUT(hduif);

test PROG(hduif);
endmodule

task testcases;
    input  integer testcase;
    input  string testdesc;
    begin
        $display("\nTESTCASE %0d: %s\n", testcase, testdesc);
    end
endtask



program test(hazard_detection_unit_if.tb hduif);
    integer testcase;
    string testdesc;
    initial begin

        //TESTCASE 1: NO HAZARDS
        testcase = 1;
        testdesc = "NO HAZARDS";
        testcases(testcase, testdesc);

        //no register dependencies
        hduif.fd_rs1 = 5'b00001;
        hduif.fd_rs2 = 5'b00010;
        hduif.dx_rd  = 5'b00011;
        hduif.memRead = 1'b1;  
        //no branches or jumps
        hduif.branch = 1'b0;
        hduif.jump = 1'b0;

        #(1)

        if (!hduif.freeze & !hduif.threeInstrFlush)
        begin
            $display("Correct Hazard Detection Signals\n");
        end
        else if (hduif.freeze)
        begin
            $display("Freeze Signal Incorrectly Asserted\n");
        end
        else if (hduif.threeInstrFlush)
        begin
            $display("Flush signal Incorrectly Asserted\n");
        end


        //TESTCASE 2: LOAD USE HAZARD 1
        testcase++;
        testdesc = "LOAD USE HAZARD 1";
        testcases(testcase, testdesc);

        //no register dependencies
        hduif.fd_rs1 = 5'b00001;
        hduif.fd_rs2 = 5'b00011;
        hduif.dx_rd  = 5'b00011;
        hduif.memRead = 1'b1;  
        //no branches or jumps
        hduif.branch = 1'b0;
        hduif.jump = 1'b0;

        #(1)

        if (hduif.freeze & !hduif.threeInstrFlush)
        begin
            $display("Correct Hazard Detection Signals\n");
        end
        else if (!hduif.freeze)
        begin
            $display("Freeze Signal Incorrectly Asserted\n");
        end
        else if (hduif.threeInstrFlush)
        begin
            $display("Flush signal Incorrectly Asserted\n");
        end


        //TESTCASE 3: LOAD USE HAZARD 2
        testcase++;
        testdesc = "LOAD USE HAZARD 2";
        testcases(testcase, testdesc);

        //no register dependencies
        hduif.fd_rs1 = 5'b00011;
        hduif.fd_rs2 = 5'b00001;
        hduif.dx_rd  = 5'b00011;
        hduif.memRead = 1'b1;  
        //no branches or jumps
        hduif.branch = 1'b0;
        hduif.jump = 1'b0;

        #(1)

        if (hduif.freeze & !hduif.threeInstrFlush)
        begin
            $display("Correct Hazard Detection Signals\n");
        end
        else if (!hduif.freeze)
        begin
            $display("Freeze Signal Incorrectly Asserted\n");
        end
        else if (hduif.threeInstrFlush)
        begin
            $display("Flush signal Incorrectly Asserted\n");
        end


        //TESTCASE 4: JUMP HAZARD
        testcase++;
        testdesc = "JUMP HAZARD";
        testcases(testcase, testdesc);

        //no register dependencies
        hduif.fd_rs1 = 5'b00001;
        hduif.fd_rs2 = 5'b00011;
        hduif.dx_rd  = 5'b00011;
        hduif.memRead = 1'b0;  
        //no branches or jumps
        hduif.branch = 1'b0;
        hduif.jump = 1'b1;

        #(1)

        if (!hduif.freeze & hduif.threeInstrFlush)
        begin
            $display("Correct Hazard Detection Signals\n");
        end
        else if (hduif.freeze)
        begin
            $display("Freeze Signal Incorrectly Asserted\n");
        end
        else if (!hduif.threeInstrFlush)
        begin
            $display("Flush signal Incorrectly Asserted\n");
        end


        //TESTCASE 5: BRANCH HAZARD 
        testcase++;
        testdesc = "BRANCH HAZARD";
        testcases(testcase, testdesc);

        //no register dependencies
        hduif.fd_rs1 = 5'b00001;
        hduif.fd_rs2 = 5'b00011;
        hduif.dx_rd  = 5'b00011;
        hduif.memRead = 1'b0;  
        //no branches or jumps
        hduif.branch = 1'b1;
        hduif.jump = 1'b0;

        #(1)

        if (!hduif.freeze & hduif.threeInstrFlush)
        begin
            $display("Correct Hazard Detection Signals\n");
        end
        else if (hduif.freeze)
        begin
            $display("Freeze Signal Incorrectly Asserted\n");
        end
        else if (!hduif.threeInstrFlush)
        begin
            $display("Flush signal Incorrectly Asserted\n");
        end



    end

endprogram