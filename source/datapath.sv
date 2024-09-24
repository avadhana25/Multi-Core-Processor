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
`include "alu_if.vh"
`include "register_file_if.vh"
`include "if_id_if.vh"
`include "id_ex_if.vh"
`include "ex_mem_if.vh"
`include "mem_wb_if.vh"
`include "forwarding_unit_if.vh"
`include "hazard_detection_unit_if.vh"




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
  alu_if             aluif();
  register_file_if   rfif();
  if_id_if           fdif();
  id_ex_if           dxif();
  ex_mem_if          xmif();
  mem_wb_if          mwif();
  forwarding_unit_if fuif();
  hazard_detection_unit_if hduif();


  //DUTS
  control_unit    CTRLU    (cuif);
  program_counter PCNT     (CLK, nRST, pcif);
  alu             ALU      (aluif);
  register_file   REGFILE  (CLK, nRST, rfif);
  if_id           IFID     (CLK, nRST, fdif);
  id_ex           IDEX     (CLK, nRST, dxif);
  ex_mem          EXMEM    (CLK, nRST, xmif);
  mem_wb          MEMWB    (CLK, nRST, mwif);
  forwarding_unit FRWDU    (fuif);
  hazard_detection_unit HDU (hduif);



  // pc init
  parameter PC_INIT = 0;



  //logic instantiation
  word_t jumpAddr, branchAddr, signExt, zeroExt;
  funct3_b_t func3;
  word_t xm_auipc_dest, mw_aupic_dest, xm_replace, mw_replace;

  //func3 for branch
  assign func3 = funct3_b_t'(dxif.instr_o[14:12]);
  logic branch;

  //Setup Immediate values
  assign xm_auipc_dest = xmif.curr_pc_o + xmif.zeroExt_o;
  assign wm_auipc_dest = mwif.curr_pc_o + mwif.zeroExt_o;
  assign jumpAddr = (dxif.instr_o[31] == 1) ? {19'h7ffff, dxif.instr_o[31], dxif.instr_o[19:12], dxif.instr_o[20], dxif.instr_o[30:21], 1'b0} : {19'h0, dxif.instr_o[31], dxif.instr_o[19:12], dxif.instr_o[20], dxif.instr_o[30:21], 1'b0};
  assign branchAddr = (dxif.instr_o[31] == 1) ? {19'h7ffff, dxif.instr_o[31], dxif.instr_o[7], dxif.instr_o[30:25], dxif.instr_o[11:8], 1'b0} : {19'h0, dxif.instr_o[31], dxif.instr_o[7], dxif.instr_o[30:25], dxif.instr_o[11:8], 1'b0};
  assign zeroExt = {dxif.instr_o[31:12], 12'b0};    //for u type
  always_comb
  begin
    //default (I-types)
    signExt = (dxif.instr_o[31] == 1) ? {20'hfffff, dxif.instr_o[31:20]} : {20'h00000, dxif.instr_o[31:20]};

    //if S type (immmedtiave value in diff location)
    if (opcode_t'(dxif.instr_o[6:0]) == STYPE)
    begin
      signExt = (dxif.instr_o[31] == 1) ? {20'hfffff, dxif.instr_o[31:25], dxif.instr_o[11:7]} : {20'h00000, dxif.instr_o[31:25], dxif.instr_o[11:7]};
    end
  end

  //set up forwarding replacement values
  always_comb
  begin

    //default values
    xm_replace = '0;
    mw_replace = '0;

        casez (xmif.rdSel_o)

          3'h0:
          begin
            xm_replace = xmif.port_out_o;
          end

          3'h1:
          begin
            xm_replace = '0;           //this case should never happen
          end

          3'h2:
          begin
            xm_replace = xmif.npc_o;
          end

          3'h3:
          begin
            xm_replace = xmif.zeroExt_o;
          end

          3'h4:
          begin
            xm_replace = xmif.curr_pc_o + xmif.zeroExt_o;
          end

          endcase


          casez (mwif.rdSel_o)

          3'h0:
          begin
            mw_replace = mwif.port_out_o;
          end

          3'h1:
          begin
            mw_replace = mwif.dmemload_o;           
          end

          3'h2:
          begin
            mw_replace = mwif.npc_o;
          end

          3'h3:
          begin
            mw_replace = mwif.zeroExt_o;
          end

          3'h4:
          begin
            mw_replace = mwif.curr_pc_o + mwif.zeroExt_o;
          end

          endcase
    end



  //setup fetch decode latch
  assign fdif.instr_i   = dpif.imemload;
  assign fdif.npc_i     = pcif.npc;
  assign fdif.curr_pc_i = pcif.curr_pc;
  assign fdif.en        = dpif.ihit;
  assign fdif.flush     = hduif.threeInstrFlush;
  assign fdif.freeze    = hduif.freeze;      

  //set up decode execute latch
  assign dxif.instr_i   = fdif.instr_o;
  assign dxif.npc_i     = fdif.npc_o;
  assign dxif.curr_pc_i = fdif.curr_pc_o;
  assign dxif.rdat1_i   = rfif.rdat1;
  assign dxif.rdat2_i   = rfif.rdat2;
  assign dxif.regWr_i   = cuif.regWr;
  assign dxif.dWEN_i    = cuif.dWEN;
  assign dxif.dREN_i    = cuif.dREN;
  assign dxif.jpSel_i   = cuif.jpSel;
  assign dxif.aluSrc_i  = cuif.aluSrc;
  assign dxif.aluOp_i   = cuif.aluOp;
  assign dxif.rdSel_i   = cuif.rdSel;
  assign dxif.pcSrc_i   = cuif.pcSrc;
  assign dxif.halt_i    = cuif.halt;
  assign dxif.en        = dpif.ihit;
  assign dxif.flush     = hduif.threeInstrFlush;

  //set up execute memory latch
  assign xmif.branchAddr_i = branchAddr;
  assign xmif.zeroExt_i    = zeroExt;
  assign xmif.npc_i        = dxif.npc_o;
  assign xmif.curr_pc_i    = dxif.curr_pc_o;
  assign xmif.port_out_i   = aluif.port_out;
  always_comb
  begin
    //default
    xmif.rdat2_i      = dxif.rdat2_o;

    //forwarding exception
      if (fuif.forwardB == 2'b10)          //forward from xm latch
      begin
        xmif.rdat2_i = xm_replace;
      end

      else if (fuif.forwardB == 2'b01)        //forward from mw latch     
      begin
        xmif.rdat2_i = mw_replace;
      end
  end
  
  assign xmif.rs1_i        = regbits_t'(dxif.instr_o[19:15]);
  assign xmif.rs2_i        = regbits_t'(dxif.instr_o[24:20]);
  assign xmif.rd_i         = regbits_t'(dxif.instr_o[11:7]);
  assign xmif.halt_i       = dxif.halt_o;
  assign xmif.branch_i     = branch;
  assign xmif.regWr_i      = dxif.regWr_o;
  assign xmif.jpSel_i      = dxif.jpSel_o;
  assign xmif.dWEN_i       = dxif.dWEN_o;
  assign xmif.dREN_i       = dxif.dREN_o;
  assign xmif.pcSrc_i      = dxif.pcSrc_o;
  assign xmif.rdSel_i      = dxif.rdSel_o;
  assign xmif.jumpAddr_i   = jumpAddr;
  assign xmif.dhit         = dpif.dhit;
  assign xmif.en           = dpif.ihit;
  assign xmif.flush        = hduif.threeInstrFlush;


  //set memory writeback latch
  assign mwif.port_out_i = xmif.port_out_o;
  assign mwif.npc_i      = xmif.npc_o;
  assign mwif.curr_pc_i  = xmif.curr_pc_o;

  //latch dmemload
  always_ff @( posedge CLK, negedge nRST )
  begin
    if (!nRST)
    begin
      mwif.dmemload_i <= 32'b0;
    end
    else
    begin
      if (dpif.dmemload != 0)
      begin
        mwif.dmemload_i <= dpif.dmemload;
      end
    end
  end
 // assign mwif.dmemload_i = dpif.dmemload;
  assign mwif.zeroExt_i  = xmif.zeroExt_o;
  assign mwif.rs1_i      = xmif.rs1_o;
  assign mwif.rs2_i      = xmif.rs2_o;
  assign mwif.rd_i       = xmif.rd_o;
  assign mwif.regWr_i    = xmif.regWr_o;
  assign mwif.halt_i     = xmif.halt_o;
  assign mwif.rdSel_i    = xmif.rdSel_o;
  assign mwif.dhit       = dpif.dhit;
  assign mwif.en         = dpif.ihit;
  assign mwif.flush      = 1'b0;



  //connect forwarding unit
  assign fuif.xm_rd    = xmif.rd_o;
  assign fuif.mw_rd    = mwif.rd_o;
  assign fuif.xm_regWr = xmif.regWr_o;
  assign fuif.mw_regWr = mwif.regWr_o;
  assign fuif.dx_rs1   = regbits_t'(dxif.instr_o[19:15]);
  assign fuif.dx_rs2   = regbits_t'(dxif.instr_o[24:20]);

  //connect hazard detection unit
  assign hduif.memRead = dxif.dREN_o;
  assign hduif.fd_rs1 = regbits_t'(fdif.instr_o[19:15]);
  assign hduif.fd_rs2 = regbits_t'(fdif.instr_o[24:20]);
  assign hduif.dx_rd = regbits_t'(dxif.instr_o[11:7]);
  assign hduif.branch = xmif.pcSrc_o == 2'b1 & xmif.branch_o;
  //assign hduif.branch = 1'b0;
  assign hduif.jump = xmif.jpSel_o;

  //connect register file
  assign rfif.wen   = mwif.regWr_o;
  assign rfif.wsel  = mwif.rd_o;
  assign rfif.rsel1 = cuif.rs1;
  assign rfif.rsel2 = cuif.rs2;
  always_comb 
  begin

    //default
    rfif.wdat = mwif.port_out_o;
    
    casez (mwif.rdSel_o)

    3'h0:
    begin
      rfif.wdat = mwif.port_out_o;
    end

    3'h1:
    begin
      rfif.wdat = mwif.dmemload_o;
    end

    3'h2:
    begin
      rfif.wdat = mwif.npc_o;
    end

    3'h3:
    begin
      rfif.wdat = mwif.zeroExt_o;
    end

    3'h4:
    begin
      rfif.wdat = mwif.curr_pc_o + mwif.zeroExt_o;
    end


    endcase

  end

  //connect alu
  assign aluif.aluOp  = dxif.aluOp_o;

  always_comb //porta logic
  begin
    //default
    aluif.port_a = dxif.rdat1_o;

    //forward logic
    if (fuif.forwardA == 2'b10)          //forward from xm latch
    begin
      aluif.port_a = xm_replace;
    end

    else if (fuif.forwardA == 2'b01)        //forward from mw latch     
    begin
      aluif.port_a = mw_replace;
    end
  end


  always_comb  //portb logic
  begin

    //logic
    if (dxif.aluSrc_o)
    begin
        aluif.port_b = signExt;
    end

      else
      begin
        //no hazard
        aluif.port_b = dxif.rdat2_o;

        //forward logic
        if (fuif.forwardB == 2'b10)          //forward from xm latch
        begin
          aluif.port_b = xm_replace;
        end
        else if (fuif.forwardB == 2'b01)        //forward from mw latch     
        begin
          aluif.port_b = mw_replace;
        end

      end
    end

  //connect control unit
  assign cuif.instr = fdif.instr_o;

  //branch logic
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
    else if ((func3 == BLT ) || (func3 == BLTU))
    begin
      branch = aluif.port_out[0];
    end
    else if ((func3 == BGE) || (func3 == BGEU))
    begin
      branch = ~(aluif.port_out[0]);
    end
  end

  //connect program counter
  assign pcif.en = dpif.ihit & ~hduif.freeze;
  always_comb
  begin
    //default
    pcif.new_pc = pcif.npc;

    //logic
    if (xmif.pcSrc_o == 2'b1)
    begin
      if (xmif.jpSel_o)
      begin
        pcif.new_pc = xmif.curr_pc_o + xmif.jumpAddr_o;
      end
      else if (xmif.branch_o)
      begin
        pcif.new_pc = xmif.curr_pc_o + xmif.branchAddr_o;
      end
    end
    else if (xmif.pcSrc_o == 2'b10)
    begin
      pcif.new_pc = xmif.port_out_o;
    end
  end



  //connect datapath
  always_ff @( posedge CLK, negedge nRST )
  begin
    if (!nRST)
    begin
      dpif.halt <= 1'b0;
    end
    else
    begin
      dpif.halt <= mwif.halt_i;
    end
  end
  assign dpif.imemREN   = 1;
  assign dpif.imemaddr  = pcif.curr_pc;
  assign dpif.dmemREN   = xmif.dREN_o;
  assign dpif.dmemWEN   = xmif.dWEN_o;
  assign dpif.dmemstore = xmif.rdat2_o;
  assign dpif.dmemaddr  = xmif.port_out_o;  






endmodule
