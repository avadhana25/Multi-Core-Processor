onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/CLK
add wave -noupdate -divider fetch_decode
add wave -noupdate /system_tb/DUT/CPU/DP/fdif/instr_i
add wave -noupdate /system_tb/DUT/CPU/DP/fdif/instr_o
add wave -noupdate /system_tb/DUT/CPU/DP/fdif/npc_i
add wave -noupdate /system_tb/DUT/CPU/DP/fdif/curr_pc_i
add wave -noupdate /system_tb/DUT/CPU/DP/fdif/instr_o
add wave -noupdate /system_tb/DUT/CPU/DP/fdif/npc_o
add wave -noupdate /system_tb/DUT/CPU/DP/fdif/curr_pc_o
add wave -noupdate /system_tb/DUT/CPU/DP/fdif/en
add wave -noupdate /system_tb/DUT/CPU/DP/fdif/flush
add wave -noupdate -divider decode_execute
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/instr_i
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/instr_o
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/rdat1_i
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/rdat1_o
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/rdat2_i
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/rdat2_o
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/curr_pc_i
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/curr_pc_o
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/en
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/flush
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/regWr_i
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/regWr_o
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/dWEN_i
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/dWEN_o
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/dREN_i
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/dREN_o
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/jpSel_i
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/jpSel_o
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/aluSrc_i
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/aluSrc_o
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/halt_i
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/halt_o
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/aluOp_i
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/aluOp_o
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/rdSel_i
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/rdSel_o
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/pcSrc_i
add wave -noupdate /system_tb/DUT/CPU/DP/dxif/pcSrc_o
add wave -noupdate -divider execute_memory
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/branchAddr_i
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/branchAddr_o
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/jumpAddr_i
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/jumpAddr_o
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/zeroExt_i
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/zeroExt_o
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/npc_i
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/npc_o
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/port_out_i
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/port_out_o
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/rdat2_i
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/rdat2_o
add wave -noupdate /system_tb/DUT/CPU/DP/ALU/alu/port_a
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/curr_pc_i
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/curr_pc_o
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/rs1_i
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/rs1_o
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/rs2_i
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/rs2_o
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/rd_i
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/rd_o
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/en
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/flush
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/dhit
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/halt_i
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/halt_o
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/branch_i
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/branch_o
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/regWr_i
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/regWr_o
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/jpSel_i
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/jpSel_o
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/dWEN_i
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/dWEN_o
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/dREN_i
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/dREN_o
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/pcSrc_i
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/pcSrc_o
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/rdSel_i
add wave -noupdate /system_tb/DUT/CPU/DP/xmif/rdSel_o
add wave -noupdate -divider memory_writeback
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/npc_i
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/npc_o
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/port_out_i
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/port_out_o
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/dmemload_i
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/dmemload_o
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/zeroExt_i
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/zeroExt_o
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/curr_pc_i
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/curr_pc_o
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/en
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/flush
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/dhit
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/rs1_i
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/rs1_o
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/rs2_i
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/rs2_o
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/rd_i
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/rd_o
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/regWr_i
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/regWr_o
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/halt_i
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/halt_o
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/rdSel_i
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/rdSel_o
add wave -noupdate -divider {fourwarding unit}
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/xm_rd
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/mw_rd
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/dx_rs1
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/dx_rs2
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/xm_regWr
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/mw_regWr
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/forwardA
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/forwardB
add wave -noupdate -divider {hazard detection unit}
add wave -noupdate /system_tb/DUT/CPU/DP/hduif/memRead
add wave -noupdate /system_tb/DUT/CPU/DP/hduif/freeze
add wave -noupdate /system_tb/DUT/CPU/DP/hduif/branch
add wave -noupdate /system_tb/DUT/CPU/DP/hduif/jump
add wave -noupdate /system_tb/DUT/CPU/DP/hduif/threeInstrFlush
add wave -noupdate /system_tb/DUT/CPU/DP/hduif/fd_rs1
add wave -noupdate /system_tb/DUT/CPU/DP/hduif/fd_rs2
add wave -noupdate /system_tb/DUT/CPU/DP/hduif/dx_rd
add wave -noupdate -divider {Program Counter}
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/curr_pc
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/new_pc
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/npc
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/en
add wave -noupdate -divider {Register File}
add wave -noupdate -expand /system_tb/DUT/CPU/DP/REGFILE/register
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1725351 ps} 0}
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
WaveRestoreZoom {1689865 ps} {1761488 ps}
