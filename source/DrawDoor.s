// r0 and r1 conain the coords of the apple and are returned 

.section .text


.globl	DrawDoor
DrawDoor:

	push {r2, r5, r6, r7, lr}
	
redraw:
	ldr r2, =0x20003004			//clock address
	ldr r2, [r2]	
	ldr r6, =0x0000003F
	ldr r7, =0x20003004			//clock address
	ldr r7, [r7]	
	and r2, r6
	and r7, r6
loopBack:	
	cmp r2, #21
	ble continue2
	sub r2, r2, #21
	b loopBack

continue2:
	cmp r7, #31
	ble continue3
	sub r7, r7, #31
	b continue2

continue3:
	mov r5, #32
	add	r2, #2
	mov r0, r7 //x coordinate
	mov r1, r2// y coordinate
	bl HitDetection
	cmp	r0, #1
	beq redraw
	
	mov r0, r7 //x coordinate
	mov r1, r2// y coordinate
	push {r2}
	mul r0, r5
	mul r1, r5
	ldr r2, =Door // this is the randomly generated apple
	mov r3, #32
	mov r4, #32
	bl drawImage
	pop {r2}
	mov r0, r7 //Curent apple storage
	mov r1, r2
	pop {r2, r5, r6, r7, lr}
	bx lr
