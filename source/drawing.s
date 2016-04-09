.section .data
.equ	GRID_RATIO,		0x2F	// How many pixels wide is each block
.equ	INITX,	 		0x88 	// Initial point of x (left most part of map)
.equ	INITY,			0x0		// Initial point of y (top most part of map)
.equ	BG_COLOR,		0x0000	// Background color the whole game
.globl FrameBufferInfo


FrameBufferInfo:
    .int    1024    // 0 - Width
    .int    768     // 4 - Height
    .int    1024    // 8 - vWidth
    .int    768   	// 12 - vHeight
    .int    0       // 16 - GPU - Pitch
    .int    16      // 20 - Bit Depth
    .int    0       // 24 - X
    .int    0       // 28 - Y
    .int    0       // 32 - GPU - Pointer
    .int    0       // 36 - GPU - Size

	
.align 4


.globl FrameBufferPointer
FrameBufferPointer:
	.int	0

font:		
	.incbin	"font.bin"
	
.section .text

.globl InitFrameBuffer //this initializes frame buffer, taken from tutorial code
InitFrameBuffer:
   
    infoAdr .req r4
    push    {r4, lr}
    ldr     infoAdr, =FrameBufferInfo       // get framebuffer info address
    
	result  .req r0

    mov     r0, infoAdr                     // store fb info address as mail message
	add		r0,	#0x40000000					// set bit 30; tell GPU not to cache changes
    mov     r1, #1                          // mailbox channel 1
    bl      MailboxWrite                    // write message
    
    mov     r0, #1                          // mailbox channel 1
    bl      MailboxRead                     // read message
    
    teq     result, #0
    movne   result, #0
    popne   {r4, pc}                        // return 0 if message from mailbox is 0
    
pointerWait:
    ldr     result, [infoAdr, #32]
    teq     result, #0
    beq     pointerWait                   // loop until the pointer is set
	
	ldr		r1,		=FrameBufferPointer
	str		result,	[r1]					// store the framebuffer pointer
    
    mov     result, infoAdr                 // set result to address of fb info struct
    pop     {r4, pc}                        // return
    
    .unreq  result
    .unreq  infoAdr

/* Draw Pixel
 *  r0 - x
 *  r1 - y
 *  r2 - color
 */

.globl DrawPixel 
DrawPixel:
    px      .req    r0
    py      .req    r1
	color	.req	r2
    addr    .req    r3
	push	{r4, lr}
    ldr     addr,   =FrameBufferInfo
    height  .req    r4
    ldr     height, [addr, #4]
    sub     height, #1
    cmp     py,     height
    movhi   pc,     lr
    .unreq  height
    width   .req    r4
    ldr     width,  [addr, #0]
    sub     width,  #1
    cmp     px,     width
    movhi   pc,     lr
    ldr     addr,   =FrameBufferPointer
	ldr		addr,	[addr]
    add     width,  #1
    mla     px,     py, width, px       // px = (py * width) + px
    .unreq  width
    .unreq  py
    add     addr,   px, lsl #1			// addr += (px * 2) (ie: 16bpp = 2 bytes per pixel)
    .unreq  px
    strh    color,  [addr]
    .unreq	color
    .unreq  addr
	pop		{r4, pc}

 

.globl MailboxWrite 
MailboxWrite: //code that writes to mailbox, taken from tutorial code
    
    tst     r0, #0b1111                     // if lower 4 bits of r0 != 0 (must be a valid message)
    movne   pc, lr                          //  return
    cmp     r1, #15                         // if r1 > 15 (must be a valid channel)
    movhi   pc, lr                          //  return
    channel .req r1
    value   .req r2
    mov     value, r0
    mailbox .req r0
	ldr     mailbox,=0x2000B880
    
wait1:
    status  .req r3
    ldr     status, [mailbox, #0x18]        // load mailbox status
    tst     status, #0x80000000             // test bit 32
    .unreq  status
    bne     wait1                          // loop while status bit 32 != 0
    add     value, channel                  // value += channel
    .unreq  channel
    str     value, [mailbox, #0x20]         // store message to write offset
    .unreq  value
    .unreq  mailbox
    bx		lr



.globl MailboxRead // code that reads from amilbox, taken from tutorial code
MailboxRead:
   
    cmp     r0, #15                         // return if invalid channel (> 15)
    movhi   pc, lr
    channel .req r1
    mov     channel, r0
    mailbox .req r0
	ldr     mailbox,=0x2000B880
    
rightmail$:

wait2:
    status  .req r2
    ldr     status, [mailbox, #0x18]        // load mailbox status
    
    tst     status, #0x4000000              // test bit 30
    .unreq  status
    bne     wait2                       // loop while status bit 30 != 0
    
    mail    .req r2
    ldr     mail, [mailbox, #0]             // retrieve message
    
    inchan  .req r3
    and     inchan, mail, #0b1111           // mask out lower 4 bits of message into inchan
    
    teq     inchan, channel
    .unreq  inchan
    bne     rightmail$                      // if not the right channel, loop
    
    .unreq  mailbox
    .unreq  channel
    
    and     r0, mail, #0xfffffff0           // mask out channel from message, store in return (r0)
    .unreq  mail
    
	bx		lr
	

.globl DrawChar // draws a char, taken from tutorial code
DrawChar:
	push	{r4-r10, lr} 

	chAdr	.req	r4
	px		.req	r5
	py		.req	r6
	row		.req	r7
	mask	.req	r8
	pxinit	.req	r9
	color	.req	r10

	ldr		chAdr, =font		// load the address of the font map
	add		chAdr,	r3, lsl #4	// char address = font base + (char * 16)
	
	mov		color, 	r2		// init the color
	mov		py,		r1		// init the Y coordinate (pixel coordinate)
	mov		pxinit, r0		// init the X coordinate

charLoop$:
	mov		px,		pxinit		// the X coordinate


	mov		mask,	#0x01		// set the bitmask to 1 in the LSB
	
	ldrb	row,	[chAdr], #1	// load the row byte, post increment chAdr

rowLoop$:
	tst		row,	mask		// test row byte against the bitmask
	beq		noPixel$

	mov		r0,		px			// set the x coord
	mov		r1,		py			// set the y coord
	mov		r2,		color		// set the color
	bl		DrawPixel			// draw pixel at (px, py)

noPixel$:
	add		px,		#1			// increment x coordinate by 1
	lsl		mask,	#1			// shift bitmask left by 1

	tst		mask,	#0x100		// test if the bitmask has shifted 8 times (test 9th bit)
	beq		rowLoop$

	add		py,		#1			// increment y coordinate by 1

	tst		chAdr,	#0xF
	bne		charLoop$			// loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)

	.unreq	chAdr
	.unreq	px
	.unreq	py
	.unreq	row
	.unreq	mask
	.unreq	pxinit
	.unreq	color
		
	pop		{r4-r10, pc}


/* Draws a sentence
 * Args:
 *  r0 - x location for writing to start
 *	r1 - y location for writing to start
 *	r2 - color of the text
 *	r3 - address of the text (must be in asciz)		
 * Return:
 *  none
 */
.globl DrawSentence
DrawSentence:
	sentAdr	.req	r4
	px		.req	r5
	py		.req	r6
	color	.req	r7
	tmpChar .req	r8
	counter	.req	r9
	push	{r4-r12, lr} 

	
	mov		px, r0			// Store x pixel value
	mov		py, r1			// Store y pixel value 
	mov		color, r2		// Store the color
	mov		sentAdr, r3		// Store the address of the sentance
	
	mov		counter, #0
	ldrb	tmpChar, [sentAdr]	// Load the first character to be drawn
drawSent$:
	mov		r3, tmpChar		// Move char to r3 so it can be drawn
	mov		r0,	px			// Move x location to pass it in
	mov		r1, py			// Move y location to pass it in
	mov		r2, color		// Move the color to pass it in
	bl		DrawChar		// Actually draw the character
	add		counter, #1		// Increment to next character
	add		px, #10			// Increment location to be drawn
		
	ldrb	tmpChar, [sentAdr, counter]	// Load the next character to be drawn
	cmp		tmpChar, #0		// Check if end of string
	bne		drawSent$
	
bot:
	.unreq	sentAdr
	.unreq	px
	.unreq	py
	.unreq	color
	.unreq	tmpChar
	.unreq	counter
	pop		{r4-r12, pc}


/* Draws the selector for menu items
 * Args:
 *  r0 - x coordinate to draw selector
 *  r1 - y coordinate to draw selector
 * 	r2 - color of selector
 *	r3 - how wide to make it
 * Return:
 *  none
 */
.globl DrawSelector
DrawSelector:
	px		.req	r4
	py		.req	r5
	selColr	.req	r6	
	width	.req	r7
	push {r4-r7, lr}
	
	mov		px, r0			// Store x pixel value
	mov		py, r1			// Store y pixel value
	mov		selColr, r2		// Store color 
	mov		width, r3		// Store the width in pixels
	
	ldr		r3, ='>'		// Move char to r3 so it can be drawn
	mov		r0,	px			// Move x location to pass it in
	mov		r1, py			// Move y location to pass it in
	mov		r2, selColr		// Move the color to pass it in
	bl		DrawChar		// Actually draw the character
	
	add		px,	width		// Move x location to other side of sentance/word
	
	ldr		r3, ='<'		// Move char to r3 so it can be drawn
	mov		r0,	px			// Move x location to pass it in
	mov		r1, py			// Move y location to pass it in
	mov		r2, selColr		// Move the color to pass it in
	bl		DrawChar		// Actually draw the character
	
	.unreq	px
	.unreq	py
	.unreq	selColr
	.unreq	width
	pop {r4-r7, pc}



	
	
	


