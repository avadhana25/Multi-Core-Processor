/*
  Aakash Vadhanam
  avadhana@purdue.edu

  arithmetic logic unit test bench
*/

// mapped needs this
`include "alu_if.vh"

//all types
`include "cpu_types_pkg.vh"

// import types
  import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module alu_tb;

// interface
alu_if alu ();

//test program
test PROG ();

//DUT
`ifndef MAPPED
  alu DUT(alu);
`else
  alu DUT (
    .\alu.port_out (alu.port_out),
    .\alu.negative (alu.negative),
    .\alu.overflow (alu.overflow),
    .\alu.zero (alu.zero),
    .\alu.aluOp (alu.aluOp),
    .\alu.port_out (alu.port_out),
    .\alu.port_a (alu.port_a),
    .\alu.port_b (alu.port_b)
  );
`endif 

task testcases;
    input  integer testcase;
    input  string testdesc;
    begin
        $display("\nTESTCASE %0d: %s\n", testcase, testdesc);
    end
endtask


endmodule

program test;
  integer testcase;
  string testdesc;
  initial begin
    //initialize inputs
    alu.port_a = '0;
    alu.port_b = '0;


    //TESTCASE 1: ADD
    testcase = 1;
    testdesc = "ADD TEST CASES";


    alu.aluOp = ALU_ADD;

    testcases(testcase, testdesc);
    
    for (int i = 1 ;i < 33 ; i++ ) 
    begin
        alu.port_a = $random;
        alu.port_b = $random;
        #(1ns)                  //need to let signals change
        if (alu.port_out == ($signed(alu.port_a) + $signed(alu.port_b)))
        begin
            $display("Test Case %0d for ADD Passed", i);
        end
        else 
        begin
            $display("Test Case %0d for ADD Failed", i);
        end 
    end

    //TESTCASE 2: SUB
    testcase = 2;
    testdesc = "SUB TEST CASES";

    alu.aluOp = ALU_SUB;

    testcases(testcase, testdesc);
    
    for (int i = 1 ;i < 33 ; i++ ) 
    begin
        alu.port_a = $random;
        alu.port_b = $random;
        #(1ns)                  //need to let signals change
        if (alu.port_out == ($signed(alu.port_a) - $signed(alu.port_b)))
        begin
            $display("Test Case %0d for SUB Passed", i);
        end
        else 
        begin
            $display("Test Case %0d for SUB Failed", i);
        end 
    end

    //TESTCASE 3: SLL
    testcase = 3;
    testdesc = "SHIFT LOGIC LEFT TEST CASES";

    alu.aluOp = ALU_SLL;

    testcases(testcase, testdesc);

    for (int i = 0 ; i < 31 ; i++ ) 
    begin
        alu.port_a = $random;
        alu.port_b = i;
        #(1ns)
        if (alu.port_out == (alu.port_a << i))
        begin
            $display("Test Case %0d for SLL Passed", i+1);
        end
        else 
        begin
            $display("Test Case %0d for SLL Failed", i+1);
        end   
    end

    //TESTCASE 4: SRL
    testcase = 4;
    testdesc = "SHIFT LOGIC RIGHT TEST CASES";

    alu.aluOp = ALU_SRL;

    testcases(testcase, testdesc);

    for (int i = 0 ; i < 32 ; i++ ) 
    begin
        alu.port_a = $random;
        alu.port_b = i;
        #(1ns)
        if (alu.port_out == (alu.port_a >> i))
        begin
            $display("Test Case %0d for SRL Passed", i+1);
        end
        else 
        begin
            $display("Test Case %0d for SRL Failed", i+1);
        end   
    end

    //TESTCASE 5: SRA
    testcase = 5;
    testdesc = "SHIFT ARITHMETIC RIGHT TEST CASES";

    alu.aluOp = ALU_SRA;

    testcases(testcase, testdesc);

    for (int i = 0 ; i < 32 ; i++ ) 
    begin
        alu.port_a = $random;
        alu.port_b = i;
        #(1ns)
        //ask why signed was needed for port_out
        if ($signed(alu.port_out) == ($signed(alu.port_a) >>> i))
        begin
            $display("Test Case %0d for SRA Passed", i+1);
        end
        else 
        begin
            $display("Test Case %0d for SRA Failed: %b vs %b", i+1, alu.port_out, $signed(alu.port_a) >>> i);
        end   
    end

    //TESTCASE 6: AND
    testcase = 6;
    testdesc = "AND TEST CASES";

    alu.aluOp = ALU_AND;

    testcases(testcase, testdesc);
    
    for (int i = 1 ;i < 33 ; i++ ) 
    begin
        alu.port_a = $random;
        alu.port_b = $random;
        #(1ns)                  
        if (alu.port_out == (alu.port_a & alu.port_b))
        begin
            $display("Test Case %0d for AND Passed", i);
        end
        else 
        begin
            $display("Test Case %0d for AND Failed", i);
        end 
    end

    //TESTCASE 7: OR
    testcase = 7;
    testdesc = "OR TEST CASES";

    alu.aluOp = ALU_OR;

    testcases(testcase, testdesc);
    
    for (int i = 1 ;i < 33 ; i++ ) 
    begin
        alu.port_a = $random;
        alu.port_b = $random;
        #(1ns)                  
        if (alu.port_out == (alu.port_a | alu.port_b))
        begin
            $display("Test Case %0d for OR Passed", i);
        end
        else 
        begin
            $display("Test Case %0d for OR Failed", i);
        end 
    end

    //TESTCASE 8: XOR
    testcase = 8;
    testdesc = "XOR TEST CASES";

    alu.aluOp = ALU_XOR;

    testcases(testcase, testdesc);
    
    for (int i = 1 ;i < 33 ; i++ ) 
    begin
        alu.port_a = $random;
        alu.port_b = $random;
        #(1ns)                  
        if (alu.port_out == (alu.port_a ^ alu.port_b))
        begin
            $display("Test Case %0d for XOR Passed", i);
        end
        else 
        begin
            $display("Test Case %0d for XOR Failed", i);
        end 
    end

    //TESTCASE 9: SLT
    testcase = 9;
    testdesc = "SET LESS THAN SIGNED TEST CASES";

    alu.aluOp = ALU_SLT;

    testcases(testcase, testdesc);
    
    for (int i = 1 ;i < 33 ; i++ ) 
    begin
        alu.port_a = $random;
        alu.port_b = $random;
        #(1ns)                  
        if (alu.port_out == ($signed(alu.port_a) < $signed(alu.port_b)))
        begin
            $display("Test Case %0d for SLT Passed", i);
        end
        else 
        begin
            $display("Test Case %0d for SLT Failed", i);
        end 
    end

    //TESTCASE 10: SLTU
    testcase = 10;
    testdesc = "SET LESS THAN UNSIGNED TEST CASES";

    alu.aluOp = ALU_SLTU;

    testcases(testcase, testdesc);
    
    for (int i = 1 ;i < 33 ; i++ ) 
    begin
        alu.port_a = $random;
        alu.port_b = $random;
        #(1ns)                  
        if (alu.port_out == (alu.port_a < alu.port_b))
        begin
            $display("Test Case %0d for SLTU Passed", i);
        end
        else 
        begin
            $display("Test Case %0d for SLTU Failed", i);
        end 
    end


    //TESTCASE 11: OVERFLOW
    testcase = 11;
    testdesc = "OVERFLOW TEST CASES";

    testcases(testcase, testdesc);

    alu.aluOp = ALU_ADD;

    alu.port_a = 32'h0FFFFFFF;
    alu.port_b = 32'h7FF00000;

    #(1ns)

    if (alu.overflow == 1)
    begin
        $display("Test Case 1 for OVERFLOW Passed (ADD)");
    end 
    else
    begin
        $display("Test Case 1 for OVERFLOW Failed (ADD): %b", alu.port_out);
    end

    alu.aluOp = ALU_SUB;

    alu.port_a = 32'h80000000;
    alu.port_b = 32'h1;

    #(1ns)

    if (alu.overflow == 1)
    begin
        $display("Test Case 2 for OVERFLOW Passed (SUB)");
    end 
    else
    begin
        $display("Test Case 2 for OVERFLOW Failed (SUB): %b", alu.port_out);
    end


    //TESTCASE 12: NEGATIVE
    testcase = 12;
    testdesc = "NEGATIVE TEST CASE";

    testcases(testcase, testdesc);

    alu.aluOp = ALU_SUB;

    alu.port_a = 0;
    alu.port_b = 1000;
    #(1ns)                  
    if (alu.negative)
    begin
        $display("Test Case 1 for NEGATIVE Passed");
    end
    else 
    begin
        $display("Test Case 1 for NEGATIVE Failed: %b", alu.port_out);
    end 

    //TESTCASE 13: ZERO
    testcase = 13;
    testdesc = "ZERO TEST CASE";

    testcases(testcase, testdesc);

    alu.aluOp = ALU_SUB;

    alu.port_a = 1000;
    alu.port_b = 1000;
    #(1ns)

    if (alu.zero)
    begin
        $display("Test Case 1 for ZERO Passed\n");
    end
    else 
    begin
        $display("Test Case 1 for ZERO Failed: %b\n", alu.port_out);
    end 

  end





endprogram