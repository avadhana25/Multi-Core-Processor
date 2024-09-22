/*
Aakash Vadhanam
program counter source file
9/5/24
*/

//all types
`include "cpu_types_pkg.vh"
`include "program_counter_if.vh"

// import types
  import cpu_types_pkg::*;


module program_counter(input logic CLK, nRST, program_counter_if.pc pcif);

word_t next_pc;
//constant pc + 4 value
assign pcif.npc = pcif.curr_pc + 4;

//updating pc logic
always_ff @(posedge CLK, negedge nRST) 
begin 
    if (!nRST)
    begin
        pcif.curr_pc <= '0;
    end
    else
    begin
        pcif.curr_pc <= next_pc;
    end
end

always_comb begin
    next_pc = pcif.curr_pc;
    if(pcif.en) begin
        next_pc = pcif.new_pc;
    end
end

endmodule