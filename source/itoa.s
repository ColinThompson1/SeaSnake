// INT TO ASCII SUBROUTINE \\
//Converts int to ascii
.section .text
.globl itoa
itoa:
	push 	{r4-r12, lr}
	mov	r1, #10  	//divide/mod by 
	ldr	r6, =NumberToPrint	//buffer to store converted num (in ascii)
	str	r4, [r6]
	add	r6, #1		//add two bytes offset
	
iTop:
	mov	r4, r0
	cmp	r0, #0		//check if num is still > 0
	ble	iEnd
	push	{lr}
	bl	mod 		//Isolate for remainder
	pop 	{lr}
	add	r0, #48		//convert digit to ascii
	
	strb	r0, [r6], #-1	 //Store right justified
	mov	r0, r4
	push	{lr}
	bl	divide		//divide for next number
	pop	{lr}
	b	iTop	

iEnd:
	pop 	{r4-r12,lr}	//end itoa 
	bx	lr

// END OF SUBROUTINE \\



// DIVIDE SUBROUTINE \\
//divide number in r0 by number in r1
//return in r0
.globl dvide
divide:
	push 	{r4}
	mov	r4, #0 		//init counter to 0
	
topDivide:
	subs	r0, r1

	cmp 	r0, #0		//check if above 0
	blt	next
	add	r4, #1	//inc r4
	b	topDivide
next:
	mov	r0, r4		//move counter value back
	pop	{r4}
	bx	lr
// END OF DIVIDE SUBROUTINE \\

// MOD SUBROUTINE \\
//get mod 
//return in r0
.globl mod
mod:
	push 	{r4, r5, r6}
	mov	r4, #0 		//init counter to 0
	mov	r5, r0
	
modTop:
	sub	r0, r1

	cmp 	r0, #0		//check if above 0
	blt	mnext
	add	r4, #1			//inc r4
	b	modTop
mnext:
	mul	r6, r4, r1		//counter * divisor	
	sub	r0, r5, r6 		//calculate remainder
	pop	{r4, r5, r6}
	bx	lr
// END OF MOD SUBROUTINE \\

.section .data

