
.section .text
.globl Read_Data

Read_Data:
	ldr r2, =0x20200000 //base GPIO reg
	ldr r1, [r2, #52] //GPLEV1
	mov r3, #1
	lsl r3, #10
	and r1, r3 //mask everything else
	teq r1, #0
	moveq r0, #0 //return 0
	movne r0, #1 //return 1
	bx lr
