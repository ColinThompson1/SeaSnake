.section .text

/* Writes a bit to the latch line
 * args: r0 passes a 1 or 0 to write
 * pre: controller should be initialized
 * post: a bit is written to the latch line (GPSCLR0 or GPSET0)
 * return: none
 */

.globl	Write_Latch
Write_Latch:

	gpfsel0	.req	r4					// holds address for function sel. reg 1
	
	push	{r4, lr}

	ldr		gpfsel0, =0x20200000		// set address for func sel 1
	
	mov		r1,	#1						// set up a mask
	mov		r2,	#9						// latch is pin #9 
	lsl		r1, r2						// align to pin #9
	teq		r0, #0						// check if the arg passed is 0
	streq	r1,	[gpfsel0, #40]			// GPSCLR0if r0 is 0
	strne 	r1,	[gpfsel0, #28]			// GPSET0 if r0 is 1
	
	.unreq	gpfsel0
	
	pop		{r4, pc}
