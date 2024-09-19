//all types
`include "cpu_types_pkg.vh"
`include "hazard_detection_unit_if.vh"

// import types
  import cpu_types_pkg::*;

module hazard_detection_unit
(
    hazard_detection_unit_if.hdu hduif
);

assign hduif.freeze = hduif.memRead == 1'b1 && (hduif.rd == hduif.rs1 || hduif.rd == hduif.rs2);
assign hduif.threeInstrFlush = hduif.branch | hduif.jump;

//evaluate if branch, jalr, or jal true, then flush previous 3 instructions

endmodule

