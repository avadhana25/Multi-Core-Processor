/*
  Eric Villasenor
  evillase@gmail.com

  system test bench, for connected processor (datapath+cache)
  and memory (ram).

*/

// interface
`include "system_if.vh"

// types
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module system_tb;
  // clock period
  parameter PERIOD = 20;

  // signals
  logic CLK = 1, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  system_if syif();

  // test program
  test                                PROG (CLK,nRST,syif);

  // dut
`ifndef MAPPED
  system                              DUT (CLK,nRST,syif);
  /*
  // NOTE: All of these signals MUST be passed all the way through
  // to the write back stage and sampled in the WRITEBACK stage.
  // This means more signals that would normally be necessary
  // for correct execution must be passed along to help with debugging.
  cpu_tracker                         cpu_track0 (
    // No need to change this
    .CLK(DUT.CPU.DP.CLK),
    // This is the enable signal for the write back stage
    .wb_enable(DUT.CPU.DP.pipeline_enable),
    // The 'funct' portion of an instruction. Must be of funct_t type
    .funct(DUT.CPU.DP.MW_o.funct),
    // The 'opcode' portion of an instruction. Must be of opcode_t type
    .opcode(DUT.CPU.DP.MW_o.opcode),
    // The 'rs' portion of an instruction
    .rs(DUT.CPU.DP.MW_o.rs),
    // The 'rt' portion of an instruction
    .rt(DUT.CPU.DP.MW_o.rt),
    // The final wsel
    .wsel(DUT.CPU.DP.MW_o.wsel),
    // The 32 bit instruction
    .instr(DUT.CPU.DP.MW_o.instr),
    // Connect the PC to this
    .pc(DUT.CPU.DP.MW_o.pc),
    // Connect the next PC value (the next registered value) here
    .next_pc_val(DUT.CPU.DP.MW_o.next_pc_val),
    // The final imm/shamt signals
    // This means it should already be extended 
    .imm(DUT.CPU.DP.MW_o.imm_shamt_final),
    .shamt(DUT.CPU.DP.MW_o.imm_shamt_final),
    // the value for lui BEFORE being being shifted
     .lui_pre_shift(DUT.CPU.DP.MW_o.lui_pre_shift),
    // The branch target (aka offset added to npc)
    .branch_addr(DUT.CPU.DP.MW_o.baddr),
    // Port O of the ALU from the M/W register
    .dat_addr(DUT.CPU.DP.MW_o.portO),
    // The value that was stored in memory during MEM stage
    .store_dat(DUT.CPU.DP.MW_o.rdat2),
    // The value selected to be written into register during WB stage
    .reg_dat(DUT.CPU.DP.MW_o.wdat)
  );
  */
/*
  cpu_tracker_rv32 cpu_track0 (
  // No need to change this
  .CLK(DUT.CPU.DP.CLK),
  // Since single cycle, this is just PC enable
  .wb_stall(DUT.CPU.DP.hduif.freeze),
  //dhit signal
  .dhit(DUT.CPU.DP.mwif.dhit_o),
  //funct3 field
  .funct_3(DUT.CPU.DP.mwif.func3_o),
  //funct7 field
  .funct_7(DUT.CPU.DP.mwif.func7_o),
  //funct7 opcode
  .opcode(DUT.CPU.DP.mwif.opcode_o),
  // The 'rs1' portion of an instruction
  .rs1(DUT.CPU.DP.mwif.rs1_o),
  // The 'rs2' portion of an instruction
  .rs2(DUT.CPU.DP.mwif.rs2_o),
  //write select from reg. file
  .wsel(DUT.CPU.DP.rfif.wsel),
  //Instruction loaded from memory
  .instr(DUT.CPU.DP.mwif.instr_o),
  // Connect the PC to this
  .pc(DUT.CPU.DP.mwif.curr_pc_o),
  // Connect the next PC to this
  .next_pc_val(DUT.CPU.DP.mwif.npc_o),
  // Connect branch addr
  .branch_addr(DUT.CPU.DP.mwif.branchAddr_o),
  // Connect jump addr
  .jump_addr(DUT.CPU.DP.mwif.jumpAddr_o),
  // This means it should already be shifted/extended/whatever
  .imm(DUT.CPU.DP.mwif.imm_o),
  //Pre shifted bits from U-type inst.
  .lui_pre_shift(DUT.CPU.DP.mwif.instr_o[31:12]),
  //Data to store to memory
  .store_dat(DUT.CPU.DP.mwif.dmemstore_o),
  //Data to write to reg. file
  .reg_dat(DUT.CPU.DP.rfif.wdat),
  //Data loaded from memory
  .load_dat(DUT.CPU.DP.mwif.dmemload_o),
  //Addr. to load/store from/to memory
  .dat_addr(DUT.CPU.DP.mwif.port_out_o)
  );
  */

  
  cpu_tracker_rv32 #(.CPUID(1)) cpu_track0 (
  // No need to change this
  .CLK(DUT.CPU.DP0.CLK),
  // Since single cycle, this is just PC enable
  .wb_stall(DUT.CPU.DP0.hduif.freeze),
  //dhit signal
  .dhit(DUT.CPU.DP0.mwif.dhit_o),
  //funct3 field
  .funct_3(DUT.CPU.DP0.mwif.func3_o),
  //funct7 field
  .funct_7(DUT.CPU.DP0.mwif.func7_o),
  //funct7 opcode
  .opcode(DUT.CPU.DP0.mwif.opcode_o),
  // The 'rs1' portion of an instruction
  .rs1(DUT.CPU.DP0.mwif.rs1_o),
  // The 'rs2' portion of an instruction
  .rs2(DUT.CPU.DP0.mwif.rs2_o),
  //write select from reg. file
  .wsel(DUT.CPU.DP0.rfif.wsel),
  //Instruction loaded from memory
  .instr(DUT.CPU.DP0.mwif.instr_o),
  // Connect the PC to this
  .pc(DUT.CPU.DP0.mwif.curr_pc_o),
  // Connect the next PC to this
  .next_pc_val(DUT.CPU.DP0.mwif.npc_o),
  // Connect branch addr
  .branch_addr(DUT.CPU.DP0.mwif.branchAddr_o),
  // Connect jump addr
  .jump_addr(DUT.CPU.DP0.mwif.jumpAddr_o),
  // This means it should already be shifted/extended/whatever
  .imm(DUT.CPU.DP0.mwif.imm_o),
  //Pre shifted bits from U-type inst.
  .lui_pre_shift(DUT.CPU.DP0.mwif.instr_o[31:12]),
  //Data to store to memory
  .store_dat(DUT.CPU.DP0.mwif.dmemstore_o),
  //Data to write to reg. file
  .reg_dat(DUT.CPU.DP0.rfif.wdat),
  //Data loaded from memory
  .load_dat(DUT.CPU.DP0.mwif.dmemload_o),
  //Addr. to load/store from/to memory
  .dat_addr(DUT.CPU.DP0.mwif.port_out_o)
  );

  cpu_tracker_rv32 #(.CPUID (2)) cpu_track1  (
  // No need to change this
  .CLK(DUT.CPU.DP1.CLK),
  // Since single cycle, this is just PC enable
  .wb_stall(DUT.CPU.DP1.hduif.freeze),
  //dhit signal
  .dhit(DUT.CPU.DP1.mwif.dhit_o),
  //funct3 field
  .funct_3(DUT.CPU.DP1.mwif.func3_o),
  //funct7 field
  .funct_7(DUT.CPU.DP1.mwif.func7_o),
  //funct7 opcode
  .opcode(DUT.CPU.DP1.mwif.opcode_o),
  // The 'rs1' portion of an instruction
  .rs1(DUT.CPU.DP1.mwif.rs1_o),
  // The 'rs2' portion of an instruction
  .rs2(DUT.CPU.DP1.mwif.rs2_o),
  //write select from reg. file
  .wsel(DUT.CPU.DP1.rfif.wsel),
  //Instruction loaded from memory
  .instr(DUT.CPU.DP1.mwif.instr_o),
  // Connect the PC to this
  .pc(DUT.CPU.DP1.mwif.curr_pc_o),
  // Connect the next PC to this
  .next_pc_val(DUT.CPU.DP1.mwif.npc_o),
  // Connect branch addr
  .branch_addr(DUT.CPU.DP1.mwif.branchAddr_o),
  // Connect jump addr
  .jump_addr(DUT.CPU.DP1.mwif.jumpAddr_o),
  // This means it should already be shifted/extended/whatever
  .imm(DUT.CPU.DP1.mwif.imm_o),
  //Pre shifted bits from U-type inst.
  .lui_pre_shift(DUT.CPU.DP1.mwif.instr_o[31:12]),
  //Data to store to memory
  .store_dat(DUT.CPU.DP1.mwif.dmemstore_o),
  //Data to write to reg. file
  .reg_dat(DUT.CPU.DP1.rfif.wdat),
  //Data loaded from memory
  .load_dat(DUT.CPU.DP1.mwif.dmemload_o),
  //Addr. to load/store from/to memory
  .dat_addr(DUT.CPU.DP1.mwif.port_out_o)
  );
  
`else
  system                              DUT (,,,,//for altera debug ports
    CLK,
    nRST,
    syif.halt,
    syif.load,
    syif.addr,
    syif.store,
    syif.REN,
    syif.WEN,
    syif.tbCTRL
  );
`endif
endmodule

program test(input logic CLK, output logic nRST, system_if.tb syif);
  // import word type
  import cpu_types_pkg::word_t;

  // number of cycles
  int unsigned cycles = 0;

  initial
  begin
    nRST = 0;
    syif.tbCTRL = 0;
    syif.addr = 0;
    syif.store = 0;
    syif.WEN = 0;
    syif.REN = 0;
    @(posedge CLK);
    $display("Starting Processor.");
    nRST = 1;
    // wait for halt
    while (!syif.halt)
    begin
      @(posedge CLK);
      cycles++;
    end
    $display("Halted at %g time and ran for %d cycles.",$time, cycles);
    nRST = 0;
    dump_memory();
    $finish;
  end

  task automatic dump_memory();
    string filename = "memcpu.hex";
    int memfd;

    syif.tbCTRL = 1;
    syif.addr = 0;
    syif.WEN = 0;
    syif.REN = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      syif.addr = i << 2;
      syif.REN = 1;
      repeat (4) @(posedge CLK);
      if (syif.load === 0)
        continue;
      values = {8'h04,16'(i),8'h00,syif.load};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),syif.load,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      syif.tbCTRL = 0;
      syif.REN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask
endprogram
