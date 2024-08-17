/*
  Eric Villasenor
  evillase@gmail.com

  this block holds the i and d cache
*/


<<<<<<< HEAD
module caches (
  input logic CLK, nRST,
  datapath_cache_if.cache dcif,
  caches_if cif
);
=======
// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"

module caches (
  input logic CLK, nRST,
  datapath_cache_if.cache dcif,
<<<<<<< HEAD
<<<<<<< HEAD
  caches_if.caches cif
);
  // import types
  import cpu_types_pkg::word_t;

  parameter CPUID = 0;
=======
  caches_if cif
);
>>>>>>> c54c166650f4a106c60fd07435109d6e4e177e69

  word_t instr;
  word_t daddr;
=======
  caches_if cif
);
>>>>>>> a7fda6302ce91fbe3f32bf24bbcc6d438b7ec5bf
>>>>>>> 0993c6e9ef29110898425c513d61e32a1032dceb

  // icache
  //icache  ICACHE(dcif, cif);
  // dcache
  //dcache  DCACHE(dcif, cif);

<<<<<<< HEAD
  // dcache invalidate before halt handled by dcache when exists
  assign dcif.flushed = dcif.halt;

=======
  // single cycle instr saver (for memory ops)
  always_ff @(posedge CLK)
  begin
    if (!nRST)
    begin
      instr <= '0;
      daddr <= '0;
    end
    else
    if (dcif.ihit)
    begin
      instr <= cif.iload;
      daddr <= dcif.dmemaddr;
    end
  end
  // dcache invalidate before halt
  assign dcif.flushed = dcif.halt;

<<<<<<< HEAD
  //single cycle
  assign dcif.ihit = (dcif.imemREN) ? ~cif.iwait : 0;
  assign dcif.dhit = (dcif.dmemREN|dcif.dmemWEN) ? ~cif.dwait : 0;
  assign dcif.imemload = (cif.iwait) ? instr : cif.iload;
=======
>>>>>>> 0993c6e9ef29110898425c513d61e32a1032dceb
  //singlecycle
  assign dcif.ihit = (dcif.imemREN) ? ~cif.iwait : 0;
  assign dcif.dhit = (dcif.dmemREN|dcif.dmemWEN) ? ~cif.dwait : 0;
  assign dcif.imemload = cif.iload;
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> c54c166650f4a106c60fd07435109d6e4e177e69
=======
>>>>>>> a7fda6302ce91fbe3f32bf24bbcc6d438b7ec5bf
>>>>>>> 0993c6e9ef29110898425c513d61e32a1032dceb
  assign dcif.dmemload = cif.dload;


  assign cif.iREN = dcif.imemREN;
  assign cif.dREN = dcif.dmemREN;
  assign cif.dWEN = dcif.dmemWEN;
  assign cif.dstore = dcif.dmemstore;
  assign cif.iaddr = dcif.imemaddr;
<<<<<<< HEAD
  assign cif.daddr = dcif.dmemaddr;
=======
<<<<<<< HEAD
<<<<<<< HEAD
  assign cif.daddr = daddr;
=======
  assign cif.daddr = dcif.dmemaddr;
>>>>>>> c54c166650f4a106c60fd07435109d6e4e177e69
=======
  assign cif.daddr = dcif.dmemaddr;
>>>>>>> a7fda6302ce91fbe3f32bf24bbcc6d438b7ec5bf
>>>>>>> 0993c6e9ef29110898425c513d61e32a1032dceb

endmodule
