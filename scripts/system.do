onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -divider DCACHE
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
WaveRestoreCursors {{Cursor 1} {1172539662 ps} 0}
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
WaveRestoreZoom {1172513799 ps} {1172747728 ps}
