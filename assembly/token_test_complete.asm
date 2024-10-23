.data
	X: .word
.text
begining:
	addi x4, x0, 10 # tag = 0, valid = 1, data = 10
	addi x5, x0, 11  # tag = 1, valid = 1, data = 11
	addi x6, x0, 21  # tag = 2, valid = 1, data = 21
	add x7, x5, x4  # tag = 3, valid = 1, data = 21
	beq x4, x5, here  # tag = 0, valid = 0, data = 0, branch = 1, btaken = 0
	beq x7, x6, here  # tag = 0, valid = 0, data = 0, branch = 1, btaken = 1
	nop #dc
	nop #dc
here:
	mul x8, x4, x5  # tag = 4, valid = 1, data = 110, branch = 0, btaken = 0
	lw x9, X # tag = 5, valid = 1, data = 0xFFFFFFFF, branch = 0, btaken = 0
	sw x4, X, x10 # tag = 0, valid = 0, data = 0, branch = 0, btaken = 0
	jal end # tag = 6, valid = 1, data = pc, jalr = 0
	nop
	nop
end:
	nop
	nop
	nop
	
	
	
	
	
	
	