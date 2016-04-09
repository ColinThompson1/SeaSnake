.section .text

/* 
 * args: none
 * pre:	controller must be initialized
 * post: the controller has been cycled
 * return: r0, which contains the mask of which buttons were pressed
 */
 
.globl ReadSNES
ReadSNES:


	push	{r4-r5, lr}
	

	count	.req	r4					// a counter
	butns	.req	r5					// address for buttons

	mov		butns, #0					// reseting the register

	mov		r0, #1						// passed arg = 1
	bl		Write_Clock					// write 1 to GPIO clock line
	mov		r0,	#1						// passed arg = 1
	bl		Write_Latch					// write 1 to GPIO latch line
	
	mov		r0, #12						// passed arg = 12
	bl		Wait						// wait 12 micros
	
										// passed arg = 0
	bl		Write_Latch					// write 0
	
	
	mov		count,	#0					// reset the count


	/*
	*	The loop which pulses cycles to read from the SNES
	*/
	
	pulseloop:

	mov		r0, #6						// passed arg = 6
	bl		Wait						// wait 6 micros
	
										// passed arg = 0
	bl		Write_Clock					// write 0
	
	mov		r0, #6						// passed arg = 6
	bl		Wait						// wait 6 micros
	
	bl		Read_Data					// read the GPIO data line
										// returned arg = r0 (0 or 1)
	
	cmp		r0, #1						// check if the data line was high
	
	bne		continue					// branch when data line is not high (r0 = 0)

	/*
	*	Fall to here if data line is high, ie: button pressed
	*/
	
	mov		r2, #1						// make a mask
	lsl		r2, count					// align mask to current button
	orr		butns, r2					// write the current button press


	continue:							// branched here when r0 == 0

	mov		r0, #1						// passed arg = 1
	bl		Write_Clock					// write 1

	add		count, #1					// count++
	
	cmp		count, #16					// test to see if count == 16 yet
	bne		pulseloop					// branch to read next button cycle

	mov		r0, butns					// buttons pressed returned

	.unreq	count
	.unreq	butns
	
	pop		{r4-r5, pc}
