.section .text

/* Drawing a 32x32 box
 * Args:
 *  r0 - inital x coord
 *	r1 - inital y coord
 *	r2 - color of line
 * Return:
 *  none
 */
.globl DrawSquare
DrawSquare:
    boxx    .req    r4		// Left most part of the box
    boxy    .req    r5		// Top of the box
    color	.req	r6		// Color of the box
    px		.req	r7		// x coordinate of the pixel (relative to inside the box)
    py		.req	r8		// y coordinate of the pixel (relative to inside the box)
	
	push {r4-r8, lr}
	
	mov		boxx,	r0		// Save left corner of box
	mov		boxy,	r1		// Save top of box
	mov		color,	r2		// Save the color
	
	mov		px,		#0		// Set x coord of pixel to 0
	mov		py,		#0		// Set y coord of pixel to 0 
squareLoop$:
	mov		r0,		px		// Move the pixel value of x (relative to the box)
	add		r0, 	boxx	// Add the x value relative to the screen 
	mov		r1,		py		// Move the pixel value of y (relative to the box)
	add		r1,		boxy	// Add the y value relative to the screen 
	mov		r2,		color	// Set the color
	bl		DrawPixel		// Draw pixel at (px, py)
	add 	px, #1			// Increment the pixel on the x axis
	cmp		px, #32			// Draw up to 32th pixel on x axis
	ble		squareLoop$
	mov		px, #0			// Reset the x coord of the pixel
	add 	py, #1			// Increment the pixel on the y axis
	cmp		py, #32			// Draw up to 32th pixel on y axis
	ble		squareLoop$
	
	.unreq	boxx
	.unreq	boxy
	.unreq	color
	.unreq	px
	.unreq	py
		
	pop {r4-r8, pc}







