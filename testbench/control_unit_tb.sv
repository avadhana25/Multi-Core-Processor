/*
    Aakash Vadhanam
    avadhana@purdue.edu

    control unit test bench
*/

// mapped needs this
`include "control_unit_if.vh"

//all types
`include "cpu_types_pkg.vh"

// import types
  import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module control_unit_tb;

// interface
control_unit_if cuif ();

//test program
test PROG ();

//DUT
`ifndef MAPPED
  control_unit DUT(cuif);
`else
  control_unit DUT (
    .\cuif.instr (cuif.instr),
    .\cuif.branch (cuif.branch),
    .\cuif.rs1 (cuif.rs1),
    .\cuif.rs2 (cuif.rs2),
    .\cuif.rd (cuif.rd),
    .\cuif.aluOp (cuif.aluOp),
    .\cuif.regWr (cuif.regWr),
    .\cuif.dWEN (cuif.dWEN),
    .\cuif.dREN (cuif.dREN),
    .\cuif.aluSrc (cuif.aluSrc),
    .\cuif.shift (cuif.shift),
    .\cuif.jpSel (cuif.jpSel),
    .\cuif.imm (cuif.imm),
    .\cuif.pcSrc (cuif.pcSrc),
    .\cuif.rdSel (cuif.rdSel),
    .\cuif.halt (cuif.halt),
    .\cuif.iREN (cuif.iREN)

  );
`endif 

task testcases;
    input  integer testcase;
    input  string testdesc;
    begin
        $display("\nTESTCASE %0d: %s\n", testcase, testdesc);
    end
endtask

task check_r_fields;
begin
    if (cuif.rs1 == cuif.instr[19:15])
        begin
            $display("rs1 field is accurate");
        end
        else
        begin
            $display("rs1 field is INACCURATE");
        end

        if (cuif.rs2 == cuif.instr[24:20])
        begin
            $display("rs2 field is accurate");
        end
        else
        begin
            $display("rs2 field is INACCURATE");
        end

        if (cuif.rd == cuif.instr[11:7])
        begin
            $display("rd field is accurate");
        end
        else
        begin
            $display("rd field is INACCURATE");
        end
end

endtask

task check_i_fields;
begin
    if (cuif.rs1 == cuif.instr[19:15])
        begin
            $display("rs1 field is accurate");
        end
        else
        begin
            $display("rs1 field is INACCURATE");
        end

        if (cuif.imm == cuif.instr[31:20])
        begin
            $display("imm field is accurate");
        end
        else
        begin
            $display("imm field is INACCURATE");
        end

        if (cuif.rd == cuif.instr[11:7])
        begin
            $display("rd field is accurate");
        end
        else
        begin
            $display("rd field is INACCURATE");
        end
end

endtask


endmodule

program test;
    integer testcase;
    string testdesc;
    initial begin
        //initialize inputs
        cuif.instr = '0;

        //TESTCASE 1: R-TYPE ADD
        testcase = 1;
        testdesc = "R-TYPE ADD";
        testcases(testcase, testdesc);

        cuif.instr = 32'b0000000_00001_00010_000_00011_0110011;

        #(1ns);    //cycle

        
        check_r_fields;

        if (cuif.regWr && !cuif.aluSrc && (cuif.pcSrc == 2'b0) && (cuif.rdSel == 3'b0) && (cuif.aluOp == ALU_ADD) && !cuif.shift)
        begin
            $display("control signals are accurate");
        end
        else
        begin
            $display("control signals are INACCURATE");
        end

        //TESTCASE 2: R-TYPE SUB
        testcase++;
        testdesc = "R-TYPE SUB";
        testcases(testcase, testdesc);

        cuif.instr = 32'b0100000_00001_00010_000_00011_0110011;

        #(1ns);    //cycle

        
        check_r_fields;

        if (cuif.regWr && !cuif.aluSrc && (cuif.pcSrc == 2'b0) && (cuif.rdSel == 3'b0) && (cuif.aluOp == ALU_SUB) && !cuif.shift)
        begin
            $display("control signals are accurate");
        end
        else
        begin
            $display("control signals are INACCURATE");
        end

        //TESTCASE 3: R-TYPE SLL
        testcase++;
        testdesc = "R-TYPE SLL";
        testcases(testcase, testdesc);

        cuif.instr = 32'b0000000_00001_00010_001_00011_0110011;

        #(1ns);    //cycle

        
        check_r_fields;

        if (cuif.regWr && !cuif.aluSrc && (cuif.pcSrc == 2'b0) && (cuif.rdSel == 3'b0) && (cuif.aluOp == ALU_SLL) && cuif.shift)
        begin
            $display("control signals are accurate");
        end
        else
        begin
            $display("control signals are INACCURATE");
        end

        //TESTCASE 4: I-TYPE ADDI
        testcase++;
        testdesc = "I-TYPE ADDI";
        testcases(testcase, testdesc);

        cuif.instr = 32'b000000000001_00010_000_00011_0010011;

        #(1ns);    //cycle

        
        check_i_fields;

        if (cuif.regWr && cuif.aluSrc && (cuif.pcSrc == 2'b0) && (cuif.rdSel == 3'b0) && (cuif.aluOp == ALU_ADD) && !cuif.shift)
        begin
            $display("control signals are accurate");
        end
        else
        begin
            $display("control signals are INACCURATE");
        end

        //TESTCASE 5: I-TYPE LW
        testcase++;
        testdesc = "I-TYPE LW";
        testcases(testcase, testdesc);

        cuif.instr = 32'b000000000001_00010_010_00011_0000011;

        #(1ns);    //cycle

        
        check_i_fields;

        if (cuif.regWr && cuif.aluSrc && (cuif.pcSrc == 2'b0) && (cuif.rdSel == 3'b1) && (cuif.aluOp == ALU_ADD) && cuif.dREN)
        begin
            $display("control signals are accurate");
        end
        else
        begin
            $display("control signals are INACCURATE");
        end


        //TESTCASE 6: I-TYPE JALR
        testcase++;
        testdesc = "I-TYPE JALR";
        testcases(testcase, testdesc);

        cuif.instr = 32'b000000000001_00010_000_00011_1100111;

        #(1ns);    //cycle

        
        check_i_fields;

        if (cuif.regWr && cuif.aluSrc && (cuif.pcSrc == 2'h2) && (cuif.rdSel == 3'h2) && (cuif.aluOp == ALU_ADD) && !cuif.shift)
        begin
            $display("control signals are accurate");
        end
        else
        begin
            $display("control signals are INACCURATE");
        end

        

        







    end

endprogram
