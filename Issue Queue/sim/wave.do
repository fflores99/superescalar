onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /issue_queue_tb/clk
add wave -noupdate /issue_queue_tb/rst
add wave -noupdate -divider {issue queue out}
add wave -noupdate /issue_queue_tb/issue_queue_bus/rs1_data
add wave -noupdate /issue_queue_tb/issue_queue_bus/rs1_tag
add wave -noupdate /issue_queue_tb/issue_queue_bus/rs1_data_valid
add wave -noupdate /issue_queue_tb/issue_queue_bus/rs2_data
add wave -noupdate /issue_queue_tb/issue_queue_bus/rs2_tag
add wave -noupdate /issue_queue_tb/issue_queue_bus/rs2_data_valid
add wave -noupdate /issue_queue_tb/issue_queue_bus/rd_token
add wave -noupdate /issue_queue_tb/issue_queue_bus/opcode
add wave -noupdate /issue_queue_tb/issue_queue_bus/funct7
add wave -noupdate /issue_queue_tb/issue_queue_bus/funct3
add wave -noupdate /issue_queue_tb/UUT/issue_valid
add wave -noupdate /issue_queue_tb/ex_done
add wave -noupdate -divider {dispatch if}
add wave -noupdate /issue_queue_tb/disp_imm
add wave -noupdate /issue_queue_tb/disp_pc
add wave -noupdate /issue_queue_tb/opcode
add wave -noupdate /issue_queue_tb/funct7
add wave -noupdate /issue_queue_tb/queue_en
add wave -noupdate /issue_queue_tb/queue_full
add wave -noupdate /issue_queue_tb/issue_valid
add wave -noupdate /issue_queue_tb/issue_pc
add wave -noupdate /issue_queue_tb/issue_imm
add wave -noupdate -divider {reg 0}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[0]/rs1_data}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[0]/rs1_tag}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[0]/rs1_data_valid}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[0]/rs2_data}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[0]/rs2_tag}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[0]/rs2_data_valid}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[0]/rd_token}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[0]/opcode}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[0]/funct7}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[0]/funct3}
add wave -noupdate -divider {reg 1}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[1]/rs1_data}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[1]/rs1_tag}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[1]/rs1_data_valid}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[1]/rs2_data}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[1]/rs2_tag}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[1]/rs2_data_valid}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[1]/rd_token}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[1]/opcode}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[1]/funct7}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[1]/funct3}
add wave -noupdate -divider {reg 2}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[2]/rs1_data}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[2]/rs1_tag}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[2]/rs1_data_valid}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[2]/rs2_data}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[2]/rs2_tag}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[2]/rs2_data_valid}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[2]/rd_token}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[2]/opcode}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[2]/funct7}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[2]/funct3}
add wave -noupdate -divider {reg 3}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[3]/rs1_data}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[3]/rs1_tag}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[3]/rs1_data_valid}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[3]/rs2_data}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[3]/rs2_tag}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[3]/rs2_data_valid}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[3]/rd_token}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[3]/opcode}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[3]/funct7}
add wave -noupdate {/issue_queue_tb/UUT/queue_bus_reg[3]/funct3}
add wave -noupdate -divider CDB
add wave -noupdate /issue_queue_tb/cdb/tag
add wave -noupdate /issue_queue_tb/cdb/valid
add wave -noupdate /issue_queue_tb/cdb/data
add wave -noupdate /issue_queue_tb/cdb/branch
add wave -noupdate /issue_queue_tb/cdb/branch_taken
add wave -noupdate /issue_queue_tb/cdb/jalr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19940 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 417
configure wave -valuecolwidth 86
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
WaveRestoreZoom {0 ps} {354490 ps}
