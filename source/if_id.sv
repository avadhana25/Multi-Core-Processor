/*
Aakash Vadhanam
fetch_decode latch source file
9/11/24
*/

//all types
`include "cpu_types_pkg.vh"
`include "if_id_if.vh"

// import types
  import cpu_types_pkg::*;



module if_id(input logic CLK, nRST, if_id_if.ifid fdif);

always_ff @(posedge CLK, negedge nRST)
begin
    if (!nRST)
    begin
        fdif.instr_o <= 32'b0;
        fdif.npc_o   <= 32'b0;
    end
    else if (fdif.en)
    begin
        fdif.instr_o <= fdif.instr_i;
        fdif.npc_o   <= fdif.npc_i;
    end
    else if (fdif.flush)
    begin
        fdif.instr_o <= 32'b0;
        fdif.npc_o   <= 32'b0;
    end
end

endmodule