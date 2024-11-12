onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -divider fetch_decode
add wave -noupdate /system_tb/DUT/CPU/DP0/fdif/instr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/fdif/npc_o
add wave -noupdate /system_tb/DUT/CPU/DP0/fdif/curr_pc_o
add wave -noupdate /system_tb/DUT/CPU/DP0/fdif/en
add wave -noupdate /system_tb/DUT/CPU/DP0/fdif/flush
add wave -noupdate /system_tb/DUT/CPU/DP0/fdif/freeze
add wave -noupdate -divider decode_execute
add wave -noupdate /system_tb/DUT/CPU/DP0/dxif/instr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/dxif/npc_o
add wave -noupdate /system_tb/DUT/CPU/DP0/dxif/rdat1_o
add wave -noupdate /system_tb/DUT/CPU/DP0/dxif/rdat2_o
add wave -noupdate /system_tb/DUT/CPU/DP0/dxif/curr_pc_o
add wave -noupdate /system_tb/DUT/CPU/DP0/dxif/en
add wave -noupdate /system_tb/DUT/CPU/DP0/dxif/flush
add wave -noupdate /system_tb/DUT/CPU/DP0/dxif/freeze
add wave -noupdate /system_tb/DUT/CPU/DP0/dxif/regWr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/dxif/dWEN_o
add wave -noupdate /system_tb/DUT/CPU/DP0/dxif/dREN_o
add wave -noupdate /system_tb/DUT/CPU/DP0/dxif/atomic_o
add wave -noupdate /system_tb/DUT/CPU/DP0/dxif/jpSel_i
add wave -noupdate /system_tb/DUT/CPU/DP0/dxif/jpSel_o
add wave -noupdate /system_tb/DUT/CPU/DP0/dxif/aluSrc_o
add wave -noupdate /system_tb/DUT/CPU/DP0/dxif/halt_o
add wave -noupdate /system_tb/DUT/CPU/DP0/dxif/aluOp_o
add wave -noupdate /system_tb/DUT/CPU/DP0/dxif/rdSel_o
add wave -noupdate /system_tb/DUT/CPU/DP0/dxif/pcSrc_o
add wave -noupdate -divider execute_memory
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/branchAddr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/jumpAddr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/zeroExt_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/npc_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/port_out_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/rdat2_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/curr_pc_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/instr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/imm_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/dmemstore_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/rs1_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/rs2_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/rd_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/en
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/flush
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/dhit
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/atomic_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/halt_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/branch_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/regWr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/jpSel_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/dWEN_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/dREN_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/pcSrc_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/rdSel_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/func3_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/func7_o
add wave -noupdate /system_tb/DUT/CPU/DP0/xmif/opcode_o
add wave -noupdate -divider memory_writeback
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/npc_o
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/port_out_o
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/dmemload_o
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/zeroExt_o
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/curr_pc_o
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/jumpAddr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/branchAddr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/instr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/imm_o
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/dmemstore_o
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/en
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/flush
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/dhit
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/dhit_o
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/rs1_o
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/rs2_o
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/rd_o
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/regWr_o
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/halt_o
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/rdSel_o
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/func3_o
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/func7_o
add wave -noupdate /system_tb/DUT/CPU/DP0/mwif/opcode_o
add wave -noupdate -divider DCACHE
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/reserve
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/data_store1
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/data_store2
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/cache_addr
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/snoop_addr
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/LRU_tracker
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/miss
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/state
add wave -noupdate /system_tb/DUT/CPU/cif0/iwait
add wave -noupdate /system_tb/DUT/CPU/cif0/dwait
add wave -noupdate /system_tb/DUT/CPU/cif0/iREN
add wave -noupdate /system_tb/DUT/CPU/cif0/dREN
add wave -noupdate /system_tb/DUT/CPU/cif0/dWEN
add wave -noupdate /system_tb/DUT/CPU/cif0/iload
add wave -noupdate /system_tb/DUT/CPU/cif0/dload
add wave -noupdate /system_tb/DUT/CPU/cif0/dstore
add wave -noupdate /system_tb/DUT/CPU/cif0/iaddr
add wave -noupdate /system_tb/DUT/CPU/cif0/daddr
add wave -noupdate /system_tb/DUT/CPU/cif0/ccwait
add wave -noupdate /system_tb/DUT/CPU/cif0/ccinv
add wave -noupdate /system_tb/DUT/CPU/cif0/ccwrite
add wave -noupdate /system_tb/DUT/CPU/cif0/cctrans
add wave -noupdate /system_tb/DUT/CPU/cif0/ccsnoopaddr
add wave -noupdate -divider dcif
add wave -noupdate /system_tb/DUT/CPU/CM0/dcif/halt
add wave -noupdate /system_tb/DUT/CPU/CM0/dcif/ihit
add wave -noupdate /system_tb/DUT/CPU/CM0/dcif/imemREN
add wave -noupdate /system_tb/DUT/CPU/CM0/dcif/imemload
add wave -noupdate /system_tb/DUT/CPU/CM0/dcif/imemaddr
add wave -noupdate /system_tb/DUT/CPU/CM0/dcif/dhit
add wave -noupdate /system_tb/DUT/CPU/CM0/dcif/datomic
add wave -noupdate /system_tb/DUT/CPU/CM0/dcif/dmemREN
add wave -noupdate /system_tb/DUT/CPU/CM0/dcif/dmemWEN
add wave -noupdate /system_tb/DUT/CPU/CM0/dcif/flushed
add wave -noupdate /system_tb/DUT/CPU/CM0/dcif/dmemload
add wave -noupdate /system_tb/DUT/CPU/CM0/dcif/dmemstore
add wave -noupdate /system_tb/DUT/CPU/CM0/dcif/dmemaddr
add wave -noupdate -divider {CORE CHANGE}
add wave -noupdate -divider DCACHE
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/reserve
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/data_store1
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/data_store2
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/cache_addr
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/snoop_addr
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/LRU_tracker
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/miss
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/state
add wave -noupdate /system_tb/DUT/CPU/cif1/iwait
add wave -noupdate /system_tb/DUT/CPU/cif1/dwait
add wave -noupdate /system_tb/DUT/CPU/cif1/iREN
add wave -noupdate /system_tb/DUT/CPU/cif1/dREN
add wave -noupdate /system_tb/DUT/CPU/cif1/dWEN
add wave -noupdate /system_tb/DUT/CPU/cif1/iload
add wave -noupdate /system_tb/DUT/CPU/cif1/dload
add wave -noupdate /system_tb/DUT/CPU/cif1/dstore
add wave -noupdate /system_tb/DUT/CPU/cif1/iaddr
add wave -noupdate /system_tb/DUT/CPU/cif1/daddr
add wave -noupdate /system_tb/DUT/CPU/cif1/ccwait
add wave -noupdate /system_tb/DUT/CPU/cif1/ccinv
add wave -noupdate /system_tb/DUT/CPU/cif1/ccwrite
add wave -noupdate /system_tb/DUT/CPU/cif1/cctrans
add wave -noupdate /system_tb/DUT/CPU/cif1/ccsnoopaddr
add wave -noupdate -divider dcif
add wave -noupdate /system_tb/DUT/CPU/CM1/dcif/halt
add wave -noupdate /system_tb/DUT/CPU/CM1/dcif/ihit
add wave -noupdate /system_tb/DUT/CPU/CM1/dcif/imemREN
add wave -noupdate /system_tb/DUT/CPU/CM1/dcif/imemload
add wave -noupdate /system_tb/DUT/CPU/CM1/dcif/imemaddr
add wave -noupdate /system_tb/DUT/CPU/CM1/dcif/dhit
add wave -noupdate /system_tb/DUT/CPU/CM1/dcif/datomic
add wave -noupdate /system_tb/DUT/CPU/CM1/dcif/dmemREN
add wave -noupdate /system_tb/DUT/CPU/CM1/dcif/dmemWEN
add wave -noupdate /system_tb/DUT/CPU/CM1/dcif/flushed
add wave -noupdate /system_tb/DUT/CPU/CM1/dcif/dmemload
add wave -noupdate /system_tb/DUT/CPU/CM1/dcif/dmemstore
add wave -noupdate /system_tb/DUT/CPU/CM1/dcif/dmemaddr
add wave -noupdate -divider {bus controller}
add wave -noupdate /system_tb/DUT/CPU/CC/state
add wave -noupdate /system_tb/DUT/CPU/CC/cpu_lru
add wave -noupdate /system_tb/DUT/CPU/CC/snooper
add wave -noupdate /system_tb/DUT/CPU/CC/snoopy
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2656925 ps} 0}
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
WaveRestoreZoom {1501450 ns} {1504050 ns}
