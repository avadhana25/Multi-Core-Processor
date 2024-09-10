/*
Aakash Vadhanam
request unit source file
9/5/24
*/

//all types
`include "cpu_types_pkg.vh"
`include "request_unit_if.vh"

// import types
  import cpu_types_pkg::*;


module request_unit(input logic CLK, nRST, request_unit_if.ru ruif);

//logic
always_ff @ (posedge CLK, negedge nRST)
begin
    if (!nRST)
    begin
        ruif.dmemREN <= 0;
        ruif.dmemWEN <= 0;
    end
    else if (ruif.dhit)                      
    begin
        ruif.dmemREN <= 0;
        ruif.dmemWEN <= 0;
    end
    else if (ruif.ihit)
    begin
        ruif.dmemREN <= ruif.dREN;
        ruif.dmemWEN <= ruif.dWEN;
    end
end

assign ruif.pcen = ruif.ihit;


endmodule