/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"
`include "control_unit_if.vh"
`include "program_counter_if.vh"
`include "request_unit_if.vh"
`include "alu_if.vh"
`include "register_file_if.vh"




// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;

  //interfaces initializations
  control_unit_if    cuif();
  program_counter_if pcif();
  request_unit_if    ruif();
  alu_if             aluif();
  register_file_if   rfif();

  //DUTS
  control_unit CTRLU    (cuif);
  program_counter PCNT  (CLK, nRST, pcif);
  request_unit REQU     (CLK, nRST, ruif);
  alu        ALU      (aluif);
  register_file REGFILE (CLK, nRST, rfif);

  // pc init
  parameter PC_INIT = 0;



  //logic instantiation
  word_t jumpAddr, branchAddr, signExt, zeroExt;
  funct3_b_t func3;

  //func3 for branch
  assign func3 = funct3_b_t'(dpif.imemload[14:12]);
  logic branch;

  //Setup Immediate values
  assign jumpAddr = {dpif.imemload[31], dpif.imemload[19:12], dpif.imemload[20], dpif.imemload[30:21], 1'b0};
  assign branchAddr = {dpif.imemload[31], dpif.imemload[7], dpif.imemload[30:25], dpif.imemload[11:8], 1'b0};
  assign zeroExt = {dpif.imemload[31:12], 12'b0};    //for u type
  assign signExt = (cuif.imm[11] == 1) ? {20'hfffff, cuif.imm} : {20'h00000, cuif.imm};

  //connect register file
  assign rfif.wen   = cuif.regWr & (dpif.ihit | dpif.dhit);
  assign rfif.wsel  = cuif.rd;
  assign rfif.rsel1 = cuif.rs1;
  assign rfif.rsel2 = cuif.rs2;
  always_comb 
  begin

    //default
    rfif.wdat = aluif.port_out;
    
    casez (cuif.rdSel)

    3'h0:
    begin
      rfif.wdat = aluif.port_out;
    end

    3'h1:
    begin
      rfif.wdat = dpif.dmemload;
    end

    3'h2:
    begin
      rfif.wdat = pcif.npc;
    end

    3'h3:
    begin
      rfif.wdat = zeroExt;
    end

    3'h4:
    begin
      rfif.wdat = pcif.curr_pc + zeroExt;
    end


    endcase

  end

  //connect alu
  assign aluif.aluOp  = cuif.aluOp;
  assign aluif.port_a = rfif.rdat1;
  always_comb
  begin
    //default
    aluif.port_b = rfif.rdat2;

    //logic
    if (cuif.aluSrc)
    begin
      if (cuif.shift)
      begin
        aluif.port_b = {27'b0, signExt[4:0]};
      end
      else
      begin
        aluif.port_b = signExt;
      end
    end
    else
    begin
      if (cuif.shift)
      begin
        aluif.port_b = {27'b0, rfif.rdat2[4:0]};
      end
      else
      begin
        aluif.port_b = rfif.rdat2;
      end
    end
  end

  //connect control unit
  assign cuif.instr = dpif.imemload;
  always_comb
  begin
    //default
    branch = 1'b0;

    //logic 
    if (func3 == BEQ)
    begin
      branch = aluif.zero;
    end
    else if (func3 == BNE)
    begin
      branch = ~aluif.zero;
    end
    else
    begin
      branch = aluif.port_out;
    end
  end

  //connect program counter
  assign pcif.en = dpif.ihit;
  always_comb
  begin
    //default
    pcif.new_pc = pcif.npc;

    //logic
    if (cuif.pcSrc == 2'b1)
    begin
      if (cuif.jpSel)
      begin
        pcif.new_pc = pcif.curr_pc + jumpAddr;
      end
      else if (branch)
      begin
        pcif.new_pc = pcif.curr_pc + branchAddr;
      end
    end
    else if (cuif.pcSrc == 2'b10)
    begin
      pcif.new_pc = aluif.port_out;
    end
  end

  //connect request unit
  assign ruif.ihit = dpif.ihit;
  assign ruif.dhit = dpif.dhit;
  assign ruif.dREN = cuif.dREN;
  assign ruif.dWEN = cuif.dWEN;


  //connect datapath
  always_ff @( posedge CLK, negedge nRST )
  begin
    if (!nRST)
    begin
      dpif.halt <= 1'b0;
    end
    else
    begin
      dpif.halt <= cuif.halt;
    end
  end
  assign dpif.imemREN   = cuif.iREN;
  assign dpif.imemaddr  = pcif.curr_pc;
  assign dpif.dmemREN   = ruif.dmemREN;
  assign dpif.dmemWEN   = ruif.dmemWEN;
  assign dpif.dmemstore = rfif.rdat2;
  assign dpif.dmemaddr  = aluif.port_out;  






endmodule
