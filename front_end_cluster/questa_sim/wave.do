onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /frontend_tb/pmem_add
add wave -noupdate /frontend_tb/pmem_data
add wave -noupdate -divider IFQ
add wave -noupdate /frontend_tb/clk
add wave -noupdate /frontend_tb/rst
add wave -noupdate /frontend_tb/FRONT_END/i_code
add wave -noupdate /frontend_tb/FRONT_END/disp_pc
add wave -noupdate /frontend_tb/FRONT_END/IFQ/BUFF/BUFF_DAT
add wave -noupdate -divider DISPATCH
add wave -noupdate /frontend_tb/FRONT_END/DISP/REG_ST_TBL/REGISTER_STATUS
add wave -noupdate /frontend_tb/FRONT_END/DISP/ifq_pc
add wave -noupdate /frontend_tb/FRONT_END/DISP/ifq_icode
add wave -noupdate /frontend_tb/FRONT_END/DISP/dispatch_rd
add wave -noupdate /frontend_tb/FRONT_END/DISP/jump_branch_add
add wave -noupdate /frontend_tb/FRONT_END/DISP/jump_branch_valid
add wave -noupdate /frontend_tb/FRONT_END/DISP/rd_token
add wave -noupdate -divider {Queue Common}
add wave -noupdate /frontend_tb/FRONT_END/DISP/queue_bus/rs1_data
add wave -noupdate /frontend_tb/FRONT_END/DISP/queue_bus/rs1_tag
add wave -noupdate /frontend_tb/FRONT_END/DISP/queue_bus/rs1_data_valid
add wave -noupdate /frontend_tb/FRONT_END/DISP/queue_bus/rs2_data
add wave -noupdate /frontend_tb/FRONT_END/DISP/queue_bus/rs2_tag
add wave -noupdate /frontend_tb/FRONT_END/DISP/queue_bus/rs2_data_valid
add wave -noupdate /frontend_tb/FRONT_END/DISP/queue_bus/rd_token
add wave -noupdate /frontend_tb/FRONT_END/DISP/queue_bus/funct3
add wave -noupdate /frontend_tb/FRONT_END/DISP/mult_queue_en
add wave -noupdate /frontend_tb/FRONT_END/DISP/div_queue_en
add wave -noupdate /frontend_tb/FRONT_END/DISP/mem_queue_en
add wave -noupdate /frontend_tb/FRONT_END/DISP/int_queue_en
add wave -noupdate /frontend_tb/FRONT_END/DISP/disp_imm
add wave -noupdate /frontend_tb/FRONT_END/DISP/opcode
add wave -noupdate /frontend_tb/FRONT_END/DISP/funct7
add wave -noupdate -divider CDB
add wave -noupdate /frontend_tb/FRONT_END/DISP/cdb/tag
add wave -noupdate /frontend_tb/FRONT_END/DISP/cdb/valid
add wave -noupdate /frontend_tb/FRONT_END/DISP/cdb/data
add wave -noupdate /frontend_tb/FRONT_END/DISP/cdb/branch
add wave -noupdate /frontend_tb/FRONT_END/DISP/cdb/branch_taken
add wave -noupdate /frontend_tb/FRONT_END/DISP/cdb/jalr
add wave -noupdate -divider {Register File}
add wave -noupdate /frontend_tb/FRONT_END/DISP/REG_FILE/REG_OUT_ARRAY
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3420 ps} 0}
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
WaveRestoreZoom {0 ps} {168 ns}
