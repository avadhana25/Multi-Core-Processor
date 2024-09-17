/*
Aakash Vadhanam
forwarding unit source file
9/17/24
*/

//all types
`include "cpu_types_pkg.vh"
`include "forwarding_unit_if.vh"

// import types
  import cpu_types_pkg::*;

module forwarding_unit(forwarding_unit_if.fu fuif);


//forwardA logic
always_comb
begin
    //default values
    fuif.forwardA = 2'b00;

    //logic
    //if the executed value is going to be written into the rd and it matches the decoded rs1
    if (fuif.xm_regWr && (fuif.xm_rd != 0) && (fuif.xm_rd == fuif.dx_rs1))
    begin
        fuif.forwardA = 2'b10;
    end
    //if the executed value is going to be written into the rd and it matches the decoded rs1
    //and if it wasn't already forwarded from the exectue latch
    else if (fuif.mw_regWr && (fuif.mw_rd != 0) && (fuif.mw_rd == fuif.dx_rs1))
    begin
        fuif.forwardA = 2'b01;
    end 
end

//forwardB logic
always_comb
begin
    //default values
    fuif.forwardB = 2'b00;

    //logic
    //if the executed value is going to be written into the rd and it matches the decoded rs2
    if (fuif.xm_regWr && (fuif.xm_rd != 0) && (fuif.xm_rd == fuif.dx_rs2))
    begin
        fuif.forwardB = 2'b10;
    end
    //if the executed value is going to be written into the rd and it matches the decoded rs2
    //and if it wasn't already forwarded from the exectue latch
    else if (fuif.mw_regWr && (fuif.mw_rd != 0) && (fuif.mw_rd == fuif.dx_rs2))
    begin
        fuif.forwardB = 2'b01;
    end 
end


endmodule