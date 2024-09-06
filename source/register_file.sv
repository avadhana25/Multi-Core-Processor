/*
Aakash Vadhanam
register file source file
8/21/24
*/

//all types
`include "cpu_types_pkg.vh"
`include "register_file_if.vh"

// import types
  import cpu_types_pkg::*;



module register_file(input logic CLK, nRST, register_file_if.rf rfif);

word_t [31:0] register, new_register;

//flip flop for all of the registers
always_ff@(posedge CLK or negedge nRST)
begin
    if (nRST == 0)
    begin
        register     <= '0;
    end
    else
    begin
        register[0] = '0;              //register 0 is always all 0s
        for (int i = 1; i < 32; i++) 
        begin
            register[i] = new_register[i];
        end
    end
end

//Combination logic for Write Command
always_comb
begin
    //defeault values
    new_register = register;

    //logic
    if (rfif.wen)
    begin
        new_register[rfif.wsel] = rfif.wdat;        
    end    
end

//Combination logic for Read 1 Command
always_comb
begin
    //default values
    rfif.rdat1 = '0;

    //logic
    if (rfif.rsel1)
    begin
        rfif.rdat1 = register[rfif.rsel1];
    end
end

//Combination logic for Read 2 Command
always_comb
begin
    //default values
    rfif.rdat2 = '0;

    //logic
    if (rfif.rsel2)
    begin
        rfif.rdat2 = register[rfif.rsel2];
    end
end



endmodule