onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -divider fetch_decode
add wave -noupdate /system_tb/DUT/CPU/DP0/IFID/fdif/instr_i
add wave -noupdate /system_tb/DUT/CPU/DP0/IFID/fdif/npc_i
add wave -noupdate /system_tb/DUT/CPU/DP0/IFID/fdif/curr_pc_i
add wave -noupdate /system_tb/DUT/CPU/DP0/IFID/fdif/instr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/IFID/fdif/npc_o
add wave -noupdate /system_tb/DUT/CPU/DP0/IFID/fdif/curr_pc_o
add wave -noupdate /system_tb/DUT/CPU/DP0/IFID/fdif/en
add wave -noupdate /system_tb/DUT/CPU/DP0/IFID/fdif/flush
add wave -noupdate /system_tb/DUT/CPU/DP0/IFID/fdif/freeze
add wave -noupdate -divider decode_execute
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/instr_i
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/npc_i
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/instr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/npc_o
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/rdat1_i
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/rdat1_o
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/rdat2_i
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/rdat2_o
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/curr_pc_i
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/curr_pc_o
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/en
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/flush
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/freeze
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/regWr_i
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/regWr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/dWEN_i
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/dWEN_o
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/dREN_i
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/dREN_o
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/atomic_i
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/atomic_o
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/jpSel_i
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/jpSel_o
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/aluSrc_i
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/aluSrc_o
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/halt_i
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/halt_o
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/aluOp_i
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/aluOp_o
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/rdSel_i
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/rdSel_o
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/pcSrc_i
add wave -noupdate /system_tb/DUT/CPU/DP0/IDEX/dxif/pcSrc_o
add wave -noupdate -divider execute_memory
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/branchAddr_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/branchAddr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/jumpAddr_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/jumpAddr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/zeroExt_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/zeroExt_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/npc_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/npc_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/port_out_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/port_out_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/rdat2_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/rdat2_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/curr_pc_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/curr_pc_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/instr_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/instr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/imm_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/imm_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/dmemstore_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/dmemstore_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/rs1_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/rs1_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/rs2_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/rs2_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/rd_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/rd_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/en
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/flush
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/dhit
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/atomic_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/atomic_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/halt_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/halt_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/branch_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/branch_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/regWr_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/regWr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/jpSel_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/jpSel_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/dWEN_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/dWEN_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/dREN_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/dREN_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/pcSrc_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/pcSrc_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/rdSel_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/rdSel_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/func3_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/func3_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/func7_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/func7_o
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/opcode_i
add wave -noupdate /system_tb/DUT/CPU/DP0/EXMEM/xmif/opcode_o
add wave -noupdate -divider memory_writeback
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/npc_i
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/npc_o
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/port_out_i
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/port_out_o
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/dmemload_i
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/dmemload_o
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/zeroExt_i
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/zeroExt_o
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/curr_pc_i
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/curr_pc_o
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/jumpAddr_i
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/jumpAddr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/branchAddr_i
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/branchAddr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/instr_i
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/instr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/imm_i
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/imm_o
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/dmemstore_i
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/dmemstore_o
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/en
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/flush
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/dhit
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/dhit_o
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/rs1_i
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/rs1_o
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/rs2_i
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/rs2_o
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/rd_i
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/rd_o
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/regWr_i
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/regWr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/halt_i
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/halt_o
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/rdSel_i
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/rdSel_o
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/func3_i
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/func3_o
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/func7_i
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/func7_o
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/opcode_i
add wave -noupdate /system_tb/DUT/CPU/DP0/MEMWB/mwif/opcode_o
add wave -noupdate -divider {fourwarding unit}
add wave -noupdate /system_tb/DUT/CPU/DP0/FRWDU/fuif/xm_rd
add wave -noupdate /system_tb/DUT/CPU/DP0/FRWDU/fuif/mw_rd
add wave -noupdate /system_tb/DUT/CPU/DP0/FRWDU/fuif/dx_rs1
add wave -noupdate /system_tb/DUT/CPU/DP0/FRWDU/fuif/dx_rs2
add wave -noupdate /system_tb/DUT/CPU/DP0/FRWDU/fuif/xm_regWr
add wave -noupdate /system_tb/DUT/CPU/DP0/FRWDU/fuif/mw_regWr
add wave -noupdate /system_tb/DUT/CPU/DP0/FRWDU/fuif/forwardA
add wave -noupdate /system_tb/DUT/CPU/DP0/FRWDU/fuif/forwardB
add wave -noupdate -divider {hazard detection unit}
add wave -noupdate /system_tb/DUT/CPU/DP0/HDU/hduif/memRead
add wave -noupdate /system_tb/DUT/CPU/DP0/HDU/hduif/freeze
add wave -noupdate /system_tb/DUT/CPU/DP0/HDU/hduif/branch
add wave -noupdate /system_tb/DUT/CPU/DP0/HDU/hduif/jump
add wave -noupdate /system_tb/DUT/CPU/DP0/HDU/hduif/threeInstrFlush
add wave -noupdate /system_tb/DUT/CPU/DP0/HDU/hduif/fd_rs1
add wave -noupdate /system_tb/DUT/CPU/DP0/HDU/hduif/fd_rs2
add wave -noupdate /system_tb/DUT/CPU/DP0/HDU/hduif/dx_rd
add wave -noupdate -divider {Program Counter}
add wave -noupdate /system_tb/DUT/CPU/DP0/PCNT/pcif/curr_pc
add wave -noupdate /system_tb/DUT/CPU/DP0/PCNT/pcif/new_pc
add wave -noupdate /system_tb/DUT/CPU/DP0/PCNT/pcif/npc
add wave -noupdate /system_tb/DUT/CPU/DP0/PCNT/pcif/en
add wave -noupdate -divider {Register File}
add wave -noupdate /system_tb/DUT/CPU/DP0/REGFILE/rfif/wen
add wave -noupdate /system_tb/DUT/CPU/DP0/REGFILE/rfif/wsel
add wave -noupdate /system_tb/DUT/CPU/DP0/REGFILE/rfif/rsel1
add wave -noupdate /system_tb/DUT/CPU/DP0/REGFILE/rfif/rsel2
add wave -noupdate /system_tb/DUT/CPU/DP0/REGFILE/rfif/wdat
add wave -noupdate /system_tb/DUT/CPU/DP0/REGFILE/rfif/rdat1
add wave -noupdate /system_tb/DUT/CPU/DP0/REGFILE/rfif/rdat2
add wave -noupdate -divider DCACHE
add wave -noupdate -divider fetch_decode
add wave -noupdate /system_tb/DUT/CPU/DP1/IFID/fdif/instr_i
add wave -noupdate /system_tb/DUT/CPU/DP1/IFID/fdif/npc_i
add wave -noupdate /system_tb/DUT/CPU/DP1/IFID/fdif/curr_pc_i
add wave -noupdate /system_tb/DUT/CPU/DP1/IFID/fdif/instr_o
add wave -noupdate /system_tb/DUT/CPU/DP1/IFID/fdif/npc_o
add wave -noupdate /system_tb/DUT/CPU/DP1/IFID/fdif/curr_pc_o
add wave -noupdate /system_tb/DUT/CPU/DP1/IFID/fdif/en
add wave -noupdate /system_tb/DUT/CPU/DP1/IFID/fdif/flush
add wave -noupdate /system_tb/DUT/CPU/DP1/IFID/fdif/freeze
add wave -noupdate -divider decode_execute
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/instr_i
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/npc_i
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/instr_o
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/npc_o
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/rdat1_i
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/rdat1_o
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/rdat2_i
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/rdat2_o
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/curr_pc_i
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/curr_pc_o
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/en
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/flush
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/freeze
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/regWr_i
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/regWr_o
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/dWEN_i
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/dWEN_o
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/dREN_i
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/dREN_o
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/atomic_i
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/atomic_o
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/jpSel_i
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/jpSel_o
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/aluSrc_i
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/aluSrc_o
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/halt_i
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/halt_o
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/aluOp_i
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/aluOp_o
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/rdSel_i
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/rdSel_o
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/pcSrc_i
add wave -noupdate /system_tb/DUT/CPU/DP1/IDEX/dxif/pcSrc_o
add wave -noupdate -divider execute_memory
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/branchAddr_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/branchAddr_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/jumpAddr_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/jumpAddr_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/zeroExt_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/zeroExt_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/npc_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/npc_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/port_out_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/port_out_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/rdat2_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/rdat2_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/curr_pc_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/curr_pc_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/instr_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/instr_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/imm_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/imm_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/dmemstore_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/dmemstore_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/rs1_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/rs1_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/rs2_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/rs2_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/rd_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/rd_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/en
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/flush
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/dhit
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/atomic_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/atomic_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/halt_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/halt_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/branch_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/branch_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/regWr_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/regWr_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/jpSel_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/jpSel_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/dWEN_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/dWEN_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/dREN_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/dREN_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/pcSrc_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/pcSrc_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/rdSel_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/rdSel_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/func3_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/func3_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/func7_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/func7_o
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/opcode_i
add wave -noupdate /system_tb/DUT/CPU/DP1/EXMEM/xmif/opcode_o
add wave -noupdate -divider memory_writeback
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/npc_i
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/npc_o
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/port_out_i
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/port_out_o
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/dmemload_i
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/dmemload_o
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/zeroExt_i
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/zeroExt_o
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/curr_pc_i
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/curr_pc_o
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/jumpAddr_i
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/jumpAddr_o
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/branchAddr_i
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/branchAddr_o
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/instr_i
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/instr_o
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/imm_i
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/imm_o
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/dmemstore_i
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/dmemstore_o
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/en
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/flush
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/dhit
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/dhit_o
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/rs1_i
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/rs1_o
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/rs2_i
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/rs2_o
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/rd_i
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/rd_o
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/regWr_i
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/regWr_o
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/halt_i
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/halt_o
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/rdSel_i
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/rdSel_o
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/func3_i
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/func3_o
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/func7_i
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/func7_o
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/opcode_i
add wave -noupdate /system_tb/DUT/CPU/DP1/MEMWB/mwif/opcode_o
add wave -noupdate -divider {fourwarding unit}
add wave -noupdate /system_tb/DUT/CPU/DP1/FRWDU/fuif/xm_rd
add wave -noupdate /system_tb/DUT/CPU/DP1/FRWDU/fuif/mw_rd
add wave -noupdate /system_tb/DUT/CPU/DP1/FRWDU/fuif/dx_rs1
add wave -noupdate /system_tb/DUT/CPU/DP1/FRWDU/fuif/dx_rs2
add wave -noupdate /system_tb/DUT/CPU/DP1/FRWDU/fuif/xm_regWr
add wave -noupdate /system_tb/DUT/CPU/DP1/FRWDU/fuif/mw_regWr
add wave -noupdate /system_tb/DUT/CPU/DP1/FRWDU/fuif/forwardA
add wave -noupdate /system_tb/DUT/CPU/DP1/FRWDU/fuif/forwardB
add wave -noupdate -divider {hazard detection unit}
add wave -noupdate /system_tb/DUT/CPU/DP1/HDU/hduif/memRead
add wave -noupdate /system_tb/DUT/CPU/DP1/HDU/hduif/freeze
add wave -noupdate /system_tb/DUT/CPU/DP1/HDU/hduif/branch
add wave -noupdate /system_tb/DUT/CPU/DP1/HDU/hduif/jump
add wave -noupdate /system_tb/DUT/CPU/DP1/HDU/hduif/threeInstrFlush
add wave -noupdate /system_tb/DUT/CPU/DP1/HDU/hduif/fd_rs1
add wave -noupdate /system_tb/DUT/CPU/DP1/HDU/hduif/fd_rs2
add wave -noupdate /system_tb/DUT/CPU/DP1/HDU/hduif/dx_rd
add wave -noupdate -divider {Program Counter}
add wave -noupdate /system_tb/DUT/CPU/DP1/PCNT/pcif/curr_pc
add wave -noupdate /system_tb/DUT/CPU/DP1/PCNT/pcif/new_pc
add wave -noupdate /system_tb/DUT/CPU/DP1/PCNT/pcif/npc
add wave -noupdate /system_tb/DUT/CPU/DP1/PCNT/pcif/en
add wave -noupdate -divider {Register File}
add wave -noupdate /system_tb/DUT/CPU/DP1/REGFILE/rfif/wen
add wave -noupdate /system_tb/DUT/CPU/DP1/REGFILE/rfif/wsel
add wave -noupdate /system_tb/DUT/CPU/DP1/REGFILE/rfif/rsel1
add wave -noupdate /system_tb/DUT/CPU/DP1/REGFILE/rfif/rsel2
add wave -noupdate /system_tb/DUT/CPU/DP1/REGFILE/rfif/wdat
add wave -noupdate /system_tb/DUT/CPU/DP1/REGFILE/rfif/rdat1
add wave -noupdate /system_tb/DUT/CPU/DP1/REGFILE/rfif/rdat2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {421329 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {571 ns}
