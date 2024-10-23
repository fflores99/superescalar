onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dispatch_unit_tb/clk
add wave -noupdate /dispatch_unit_tb/rst
add wave -noupdate /dispatch_unit_tb/UUT/ifq_pc
add wave -noupdate /dispatch_unit_tb/UUT/ifq_empty
add wave -noupdate /dispatch_unit_tb/UUT/dispatch_rd
add wave -noupdate -divider ICODE
add wave -noupdate /dispatch_unit_tb/UUT/rd
add wave -noupdate /dispatch_unit_tb/UUT/rs1
add wave -noupdate /dispatch_unit_tb/UUT/rs2
add wave -noupdate -divider RST
add wave -noupdate /dispatch_unit_tb/UUT/rs1_tag
add wave -noupdate /dispatch_unit_tb/UUT/rs1_tag_valid
add wave -noupdate /dispatch_unit_tb/UUT/rs2_tag
add wave -noupdate /dispatch_unit_tb/UUT/rs2_tag_valid
add wave -noupdate /dispatch_unit_tb/UUT/rd_token
add wave -noupdate /dispatch_unit_tb/UUT/REG_ST_TBL/REGISTER_STATUS
add wave -noupdate -divider queue
add wave -noupdate /dispatch_unit_tb/UUT/mem_queue_en
add wave -noupdate /dispatch_unit_tb/UUT/div_queue_en
add wave -noupdate /dispatch_unit_tb/UUT/mult_queue_en
add wave -noupdate /dispatch_unit_tb/UUT/int_queue_en
add wave -noupdate /dispatch_unit_tb/UUT/opcode
add wave -noupdate -divider queue_bus
add wave -noupdate /dispatch_unit_tb/UUT/queue_bus/rs1_data
add wave -noupdate /dispatch_unit_tb/UUT/queue_bus/rs1_tag
add wave -noupdate /dispatch_unit_tb/UUT/queue_bus/rs1_data_valid
add wave -noupdate /dispatch_unit_tb/UUT/queue_bus/rs2_data
add wave -noupdate /dispatch_unit_tb/UUT/queue_bus/rs2_tag
add wave -noupdate /dispatch_unit_tb/UUT/queue_bus/rs2_data_valid
add wave -noupdate /dispatch_unit_tb/UUT/queue_bus/rd_token
add wave -noupdate /dispatch_unit_tb/UUT/queue_bus/funct3
add wave -noupdate -radix decimal /dispatch_unit_tb/UUT/IMM
add wave -noupdate -divider cdb
add wave -noupdate /dispatch_unit_tb/UUT/cdb/tag
add wave -noupdate /dispatch_unit_tb/UUT/cdb/valid
add wave -noupdate /dispatch_unit_tb/UUT/cdb/data
add wave -noupdate /dispatch_unit_tb/UUT/cdb/branch
add wave -noupdate /dispatch_unit_tb/UUT/cdb/branch_taken
add wave -noupdate /dispatch_unit_tb/UUT/cdb/jalr
add wave -noupdate -divider {REG FILE}
add wave -noupdate /dispatch_unit_tb/UUT/REG_FILE/REG_OUT_ARRAY
add wave -noupdate -divider debug
add wave -noupdate /dispatch_unit_tb/UUT/FIFO/tag_out
add wave -noupdate /dispatch_unit_tb/UUT/STALLER/nstall
add wave -noupdate /dispatch_unit_tb/UUT/STALLER/state
add wave -noupdate /dispatch_unit_tb/UUT/fw_cdb_rs1
add wave -noupdate /dispatch_unit_tb/UUT/fw_cdb_rs1
add wave -noupdate /dispatch_unit_tb/UUT/rs1_tag_eq_cdb
add wave -noupdate /dispatch_unit_tb/UUT/rs2_tag_eq_cdb
add wave -noupdate /dispatch_unit_tb/UUT/REG_ST_TBL/tag_write_en
add wave -noupdate /dispatch_unit_tb/UUT/REG_ST_TBL/cdb_valid
add wave -noupdate /dispatch_unit_tb/UUT/REG_ST_TBL/rd
add wave -noupdate /dispatch_unit_tb/UUT/REG_ST_TBL/looked_up_rd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {98551 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 99
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
WaveRestoreZoom {0 ps} {210 ns}
