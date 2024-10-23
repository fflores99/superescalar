.data
	a: .word 
	b: .word
	c: .word

.text
	addi s0, zero, 10
	addi s1, zero, 2
	addi s2, zero, 0
	lw s0, a
	lw s1, b
	lw s2, c
	sub s0, s0, s1
	beq s0, s2, END
	sub s0, s0, s1
	beq s2, zero, END
	nop
	nop
	nop
	nop
	nop
END:
	jal END
	nop
	nop
	nop
	nop
	nop
	
	