.section .text


/* Performs a delay of micro seconds, used when pulsing controller
 * args: r0 passes a time to wait in micro seconds
 * pre: none
 * post: the system has waited r0 micro seconds
 * return: none
 */
 
.globl	Wait
Wait:

	timer	.req	r4					// holds address for CLO register

	push	{r4, lr}

	ldr		timer,	=0x20003004			// CLO register address

	ldr		r1, [timer]					// load value of CLO
	add		r1, r0						// add r0 micro seconds
	
	waitloop:
		ldr		r2,	[timer]				// load value of CLO
		cmp		r1,	r2					// stop when CLO = r1
		bhi		waitloop				// loop

	mov		r0, #0						// reset r0
	.unreq	timer
	
	pop		{r4, pc}
	

.section .data
