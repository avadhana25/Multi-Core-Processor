`include "forwarding_unit_if.vh"
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

`timescale 1 ns / 1 ns

module forwarding_unit_tb;

forwarding_unit_if fuif();

forwarding_unit DUT(fuif);

test PROG(fuif);
endmodule

task testcases;
    input  integer testcase;
    input  string testdesc;
    begin
        $display("\nTESTCASE %0d: %s\n", testcase, testdesc);
    end
endtask

regbits_t xm_rd, mw_rd, dx_rs1, dx_rs2;        //source and dest regs to check
logic xm_regWr, mw_regWr;                      //to confirm that register is being written to
logic [1:0] forwardA, forwardB;                //signals to change rdat1 and rdat2

program test(forwarding_unit_if.tb fuif);
    integer testcase;
    string testdesc;
    initial begin
        //TESTCASE 1: EX/MEM rd = ID/EX rs1
        testcase = 1;
        testdesc = "EX/MEM rd = ID/EX rs1";

        testcases(testcase, testdesc);

        fuif.xm_rd = 5'b00001;
        fuif.mw_rd = 5'b00000;
        fuif.dx_rs1 = 5'b00001;
        fuif.dx_rs2 = 5'b00010;
        fuif.xm_regWr = 1'b1;
        fuif.mw_regWr = 1'b0;

        #(5);

        if(fuif.forwardA == 2'b10) begin
            $display("Correct forwardA output");
        end
        else begin
            $display("Incorrect forwardA output");
        end
        if(fuif.forwardB == 2'b0) begin
            $display("Correct forwardB output");
        end
        else begin
            $display("Incorrect forwardB output");
        end

        //TESTCASE 2: EX/MEM rd = ID/EX rs2
        testcase = 2;
        testdesc = "EX/MEM rd = ID/EX rs2";

        testcases(testcase, testdesc);

        fuif.xm_rd = 5'b00001;
        fuif.mw_rd = 5'b00000;
        fuif.dx_rs1 = 5'b00010;
        fuif.dx_rs2 = 5'b00001;
        fuif.xm_regWr = 1'b1;
        fuif.mw_regWr = 1'b0;

        #(5);

        if(fuif.forwardA == 2'b0) begin
            $display("Correct forwardA output");
        end
        else begin
            $display("Incorrect forwardA output");
        end
        if(fuif.forwardB == 2'b10) begin
            $display("Correct forwardB output");
        end
        else begin
            $display("Incorrect forwardB output");
        end

        //TESTCASE 3: MEM/WB rd = ID/EX rs1
        testcase = 3;
        testdesc = "MEM/WB rd = ID/EX rs1";

        testcases(testcase, testdesc);

        fuif.xm_rd = 5'b00000;
        fuif.mw_rd = 5'b00001;
        fuif.dx_rs1 = 5'b00001;
        fuif.dx_rs2 = 5'b00010;
        fuif.xm_regWr = 1'b0;
        fuif.mw_regWr = 1'b1;

        #(5);

        if(fuif.forwardA == 2'b01) begin
            $display("Correct forwardA output");
        end
        else begin
            $display("Incorrect forwardA output");
        end
        if(fuif.forwardB == 2'b0) begin
            $display("Correct forwardB output");
        end
        else begin
            $display("Incorrect forwardB output");
        end

        //TESTCASE 4: MEM/WB rd = ID/EX rs2
        testcase = 4;
        testdesc = "MEM/WB rd = ID/EX rs2";

        testcases(testcase, testdesc);

        fuif.xm_rd = 5'b00000;
        fuif.mw_rd = 5'b00001;
        fuif.dx_rs1 = 5'b00010;
        fuif.dx_rs2 = 5'b00001;
        fuif.xm_regWr = 1'b0;
        fuif.mw_regWr = 1'b1;

        #(5);

        if(fuif.forwardA == 2'b0) begin
            $display("Correct forwardA output");
        end
        else begin
            $display("Incorrect forwardA output");
        end
        if(fuif.forwardB == 2'b01) begin
            $display("Correct forwardB output");
        end
        else begin
            $display("Incorrect forwardB output");
        end

        //TESTCASE 5: EX/MEM rd = ID/EX rs1 no regWr
        testcase = 5;
        testdesc = "EX/MEM rd = ID/EX rs1 no regWr";

        testcases(testcase, testdesc);

        fuif.xm_rd = 5'b00001;
        fuif.mw_rd = 5'b00000;
        fuif.dx_rs1 = 5'b00001;
        fuif.dx_rs2 = 5'b00010;
        fuif.xm_regWr = 1'b0;
        fuif.mw_regWr = 1'b0;

        #(5);

        if(fuif.forwardA == 2'b0) begin
            $display("Correct forwardA output");
        end
        else begin
            $display("Incorrect forwardA output");
        end
        if(fuif.forwardB == 2'b0) begin
            $display("Correct forwardB output");
        end
        else begin
            $display("Incorrect forwardB output");
        end

        //TESTCASE 6: EX/MEM rd = ID/EX rs2 no regWr
        testcase = 6;
        testdesc = "EX/MEM rd = ID/EX rs2 no regWr";

        testcases(testcase, testdesc);

        fuif.xm_rd = 5'b00001;
        fuif.mw_rd = 5'b00000;
        fuif.dx_rs1 = 5'b00010;
        fuif.dx_rs2 = 5'b00001;
        fuif.xm_regWr = 1'b0;
        fuif.mw_regWr = 1'b0;

        #(5);

        if(fuif.forwardA == 2'b0) begin
            $display("Correct forwardA output");
        end
        else begin
            $display("Incorrect forwardA output");
        end
        if(fuif.forwardB == 2'b0) begin
            $display("Correct forwardB output");
        end
        else begin
            $display("Incorrect forwardB output");
        end

        //TESTCASE 7: MEM/WB rd = ID/EX rs1 no regWr
        testcase = 7;
        testdesc = "MEM/WB rd = ID/EX rs1 no regWr";

        testcases(testcase, testdesc);

        fuif.xm_rd = 5'b00000;
        fuif.mw_rd = 5'b00001;
        fuif.dx_rs1 = 5'b00001;
        fuif.dx_rs2 = 5'b00010;
        fuif.xm_regWr = 1'b0;
        fuif.mw_regWr = 1'b0;

        #(5);

        if(fuif.forwardA == 2'b0) begin
            $display("Correct forwardA output");
        end
        else begin
            $display("Incorrect forwardA output");
        end
        if(fuif.forwardB == 2'b0) begin
            $display("Correct forwardB output");
        end
        else begin
            $display("Incorrect forwardB output");
        end

        //TESTCASE 8: MEM/WB rd = ID/EX rs2 no regWr
        testcase = 8;
        testdesc = "MEM/WB rd = ID/EX rs2 no regWr";

        testcases(testcase, testdesc);

        fuif.xm_rd = 5'b00000;
        fuif.mw_rd = 5'b00001;
        fuif.dx_rs1 = 5'b00010;
        fuif.dx_rs2 = 5'b00001;
        fuif.xm_regWr = 1'b0;
        fuif.mw_regWr = 1'b0;

        #(5);

        if(fuif.forwardA == 2'b0) begin
            $display("Correct forwardA output");
        end
        else begin
            $display("Incorrect forwardA output");
        end
        if(fuif.forwardB == 2'b0) begin
            $display("Correct forwardB output");
        end
        else begin
            $display("Incorrect forwardB output");
        end


    end

endprogram