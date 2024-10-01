onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ifq_tb/UUT/clk
add wave -noupdate /ifq_tb/UUT/rst
add wave -noupdate /ifq_tb/UUT/d_valid
add wave -noupdate -radix hexadecimal /ifq_tb/UUT/mem_data
add wave -noupdate /ifq_tb/UUT/abort
add wave -noupdate /ifq_tb/UUT/m_rd_en
add wave -noupdate /ifq_tb/UUT/mem_addr
add wave -noupdate /ifq_tb/UUT/jump_branch_valid
add wave -noupdate /ifq_tb/UUT/jump_branch_add
add wave -noupdate /ifq_tb/UUT/d_rd_en
add wave -noupdate /ifq_tb/UUT/empty
add wave -noupdate /ifq_tb/UUT/i_code
add wave -noupdate /ifq_tb/UUT/pc_out
add wave -noupdate /ifq_tb/UUT/BUFF/full
add wave -noupdate -expand /ifq_tb/UUT/BUFF/BUFF_DAT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {239045 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 252
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {77849 ps} {416956 ps}
