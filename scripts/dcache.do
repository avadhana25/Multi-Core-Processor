onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/CLK
add wave -noupdate /dcache_tb/nRST
add wave -noupdate /dcache_tb/PROG/testcase
add wave -noupdate /dcache_tb/PROG/testdesc
add wave -noupdate -divider {datapath 0}
add wave -noupdate /dcache_tb/dcif0/halt
add wave -noupdate /dcache_tb/dcif0/ihit
add wave -noupdate /dcache_tb/dcif0/imemREN
add wave -noupdate /dcache_tb/dcif0/imemload
add wave -noupdate /dcache_tb/dcif0/imemaddr
add wave -noupdate /dcache_tb/dcif0/dhit
add wave -noupdate /dcache_tb/dcif0/datomic
add wave -noupdate /dcache_tb/dcif0/dmemREN
add wave -noupdate /dcache_tb/dcif0/dmemWEN
add wave -noupdate /dcache_tb/dcif0/flushed
add wave -noupdate /dcache_tb/dcif0/dmemload
add wave -noupdate /dcache_tb/dcif0/dmemstore
add wave -noupdate /dcache_tb/dcif0/dmemaddr
add wave -noupdate -divider {datapath 1}
add wave -noupdate /dcache_tb/dcif1/halt
add wave -noupdate /dcache_tb/dcif1/ihit
add wave -noupdate /dcache_tb/dcif1/imemREN
add wave -noupdate /dcache_tb/dcif1/imemload
add wave -noupdate /dcache_tb/dcif1/imemaddr
add wave -noupdate /dcache_tb/dcif1/dhit
add wave -noupdate /dcache_tb/dcif1/datomic
add wave -noupdate /dcache_tb/dcif1/dmemREN
add wave -noupdate /dcache_tb/dcif1/dmemWEN
add wave -noupdate /dcache_tb/dcif1/flushed
add wave -noupdate /dcache_tb/dcif1/dmemload
add wave -noupdate /dcache_tb/dcif1/dmemstore
add wave -noupdate /dcache_tb/dcif1/dmemaddr
add wave -noupdate -divider {cache 0}
add wave -noupdate /dcache_tb/DC0/data_store1
add wave -noupdate -expand /dcache_tb/DC0/data_store2
add wave -noupdate /dcache_tb/DC0/cache_addr
add wave -noupdate /dcache_tb/DC0/snoop_addr
add wave -noupdate /dcache_tb/DC0/LRU_tracker
add wave -noupdate /dcache_tb/DC0/miss
add wave -noupdate /dcache_tb/DC0/real_hit
add wave -noupdate /dcache_tb/DC0/state
add wave -noupdate /dcache_tb/ccif/cif0/iwait
add wave -noupdate /dcache_tb/ccif/cif0/dwait
add wave -noupdate /dcache_tb/ccif/cif0/iREN
add wave -noupdate /dcache_tb/ccif/cif0/dREN
add wave -noupdate /dcache_tb/ccif/cif0/dWEN
add wave -noupdate /dcache_tb/ccif/cif0/iload
add wave -noupdate /dcache_tb/ccif/cif0/dload
add wave -noupdate /dcache_tb/ccif/cif0/dstore
add wave -noupdate /dcache_tb/ccif/cif0/iaddr
add wave -noupdate /dcache_tb/ccif/cif0/daddr
add wave -noupdate /dcache_tb/ccif/cif0/ccwait
add wave -noupdate /dcache_tb/ccif/cif0/ccinv
add wave -noupdate /dcache_tb/ccif/cif0/ccwrite
add wave -noupdate /dcache_tb/ccif/cif0/cctrans
add wave -noupdate /dcache_tb/ccif/cif0/ccsnoopaddr
add wave -noupdate -divider {cache 1}
add wave -noupdate /dcache_tb/DC1/data_store1
add wave -noupdate /dcache_tb/DC1/data_store2
add wave -noupdate /dcache_tb/DC1/cache_addr
add wave -noupdate /dcache_tb/DC1/snoop_addr
add wave -noupdate /dcache_tb/DC1/LRU_tracker
add wave -noupdate /dcache_tb/DC1/miss
add wave -noupdate /dcache_tb/DC1/real_hit
add wave -noupdate /dcache_tb/DC1/state
add wave -noupdate /dcache_tb/ccif/cif1/iwait
add wave -noupdate /dcache_tb/ccif/cif1/dwait
add wave -noupdate /dcache_tb/ccif/cif1/iREN
add wave -noupdate /dcache_tb/ccif/cif1/dREN
add wave -noupdate /dcache_tb/ccif/cif1/dWEN
add wave -noupdate /dcache_tb/ccif/cif1/iload
add wave -noupdate /dcache_tb/ccif/cif1/dload
add wave -noupdate /dcache_tb/ccif/cif1/dstore
add wave -noupdate /dcache_tb/ccif/cif1/iaddr
add wave -noupdate /dcache_tb/ccif/cif1/daddr
add wave -noupdate /dcache_tb/ccif/cif1/ccwait
add wave -noupdate /dcache_tb/ccif/cif1/ccinv
add wave -noupdate /dcache_tb/ccif/cif1/ccwrite
add wave -noupdate /dcache_tb/ccif/cif1/cctrans
add wave -noupdate /dcache_tb/ccif/cif1/ccsnoopaddr
add wave -noupdate -divider {Bus Controller}
add wave -noupdate /dcache_tb/MC/state
add wave -noupdate /dcache_tb/MC/next_state
add wave -noupdate /dcache_tb/MC/cpu_lru
add wave -noupdate /dcache_tb/MC/next_cpu_lru
add wave -noupdate /dcache_tb/MC/snooper
add wave -noupdate /dcache_tb/MC/next_snooper
add wave -noupdate /dcache_tb/MC/snoopy
add wave -noupdate /dcache_tb/MC/next_snoopy
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {341352 ps} 0}
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
WaveRestoreZoom {0 ps} {669 ns}
