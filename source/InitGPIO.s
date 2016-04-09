.section .text

/* Initializes the SNES controller GPIO
 * args: none
 * pre: none
 * post: clk to output, ltch to output, data to input
 * return: none
 */

.globl InitGPIO
InitGPIO:

	gpfsel1	.req	r4					// holds address for function sel. reg 1
	gpfsel0	.req	r5					// holds address for function sel. reg 0
	
	
	push	{r4-r5, lr}
	
	/*
	* set GPIO pin 11 to output (CLK)
	*/
	
	ldr		gpfsel1, =0x20200004		// set func sel 1 address
	ldr		r0, [gpfsel1]				// get value of func sel 1
	mov		r1, #7						// b0111
	lsl		r1, #3						// prepare to clear bits 3-5
	bic		r0, r1						// clear bits
	mov		r2, #1						// output code (001)
	lsl		r2, #3						// shift r2 to line 1 (GPIO 11)
	orr		r0, r2						// set line 1 to output
	str		r0, [gpfsel1]				// write back to func sel 1


	/*
	* set GPIO pin 9 to output (LATCH)
	*/
	
	ldr		gpfsel0, =0x20200000		// set func sel 0 address
	ldr		r0, [gpfsel0]				// get value of func sel 0
	mov		r1, #7						// b0111
	lsl		r1, #27						// prepare to clear bits 27-29
	bic		r0, r1						// clear bits
	mov		r2, #1						// output code (001)
	lsl		r2, #27						// shift r2 to line 9 (GPIO 9)
	orr		r0, r2						// set line 9 to output
	str		r0, [gpfsel0]				// write back to func sel 0
	
	
	/*
	* set GPIO pin 10 to input (DATA)
	*/
	
	ldr		r0, [gpfsel1]				// get value of func sel 0
	mov		r1, #7						// b0111
	bic		r0, r1						// clear bits for line 1, output (000)
	str		r0, [gpfsel1]				// write back to func sel 1

	.unreq	gpfsel0
	.unreq	gpfsel1
	
	pop		{r4-r5, pc}
