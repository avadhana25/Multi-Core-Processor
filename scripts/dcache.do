onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/CLK
add wave -noupdate /dcache_tb/nRST
add wave -noupdate /dcache_tb/PROG/testcase
add wave -noupdate /dcache_tb/PROG/testdesc
add wave -noupdate /dcache_tb/DUT/cache_addr
add wave -noupdate /dcache_tb/dcif/dhit
add wave -noupdate /dcache_tb/dcif/dmemREN
add wave -noupdate /dcache_tb/dcif/dmemWEN
add wave -noupdate /dcache_tb/dcif/dmemload
add wave -noupdate /dcache_tb/dcif/dmemstore
add wave -noupdate /dcache_tb/dcif/dmemaddr
add wave -noupdate /dcache_tb/cif/dREN
add wave -noupdate /dcache_tb/cif/dWEN
add wave -noupdate /dcache_tb/cif/dwait
add wave -noupdate /dcache_tb/cif/dload
add wave -noupdate /dcache_tb/cif/dstore
add wave -noupdate /dcache_tb/cif/daddr
add wave -noupdate /dcache_tb/DUT/data_store1
add wave -noupdate -expand -subitemconfig {{/dcache_tb/DUT/data_store2[0]} -expand} /dcache_tb/DUT/data_store2
add wave -noupdate /dcache_tb/DUT/state
add wave -noupdate /dcache_tb/DUT/hit_counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {370 ns} 0}
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
WaveRestoreZoom {248 ns} {498 ns}
