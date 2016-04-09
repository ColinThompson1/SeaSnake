.section .text

.globl InGameMenuControl
InGameMenuControl:

	
	
/* Moves the main menu selector
 * Args:
 *  none
 * Return:
 *  r0 - 0 if player start game
 *	   - 1 if player quit game 
 */
.globl MainMenuControl
MainMenuControl:
	push	{lr}
	
mainMenuControllerRead:	
	bl	LongDelayLoop	// Delay loop so user doesn't double click
	bl	ReadSNES		// read SNES
	ldr	r1, =0xFFFF		// full mask
	teq	r0, r1			// test if no buttons are pressed
	beq	mainMenuControllerRead	// read controller again when no buttons are pressed
	ldr	r1, =0xFEFF		// mask for bit [8]
	teq	r0, r1			// test if 'a' was pressed 
	beq	mainMenuAPress
	ldr	r1, =0xFFEF		// mask for bit [4]
	teq	r0, r1			// test if 'up' was pressed
	beq	mainMenuChangeSelection
	ldr	r1, =0xFFDF		// mask for bit [5]
	teq	r0, r1			// test if 'down' was pressed
	beq	mainMenuChangeSelection
	b	mainMenuControllerRead	// branch if none of these buttons are being pressed by themselves
		
mainMenuAPress:
	ldr		r0, =mainMenuSelected	// Load adddress of what is selected in the menu
	ldr		r1, [r0]				// Load what is actually selected
	cmp		r1, #0					// See if restart game is selected
	bne		mainMenuQuitGame		// Otherwise selection is to quit game
mainMenuStartGame:
	mov		r0, #0				
	b		mainMenuDone
mainMenuQuitGame:	
	    mov    r4, #0           //init counter to 0


drawLoop:

    mov    r5, #0           //x pos of pixel
drawLine:
	mov		r0, r5
	mov		r1, r4        //y pos of pixel
	ldr		r2,	=0x0   //colour of pixel
	push {r0,r1, r2}
	bl		DrawPixel
	pop {r0,r1,r2}

    add    r5, #1            //increment x pos of pixel
    cmp    r5, #1024        //have we filled out the whole line
    blt    drawLine         //no than finish it

    add    r4, #1           //otherwise go to next line

drawLoopTest:
//1024 X 768
    cmp     r4, #768        //have we painted all lines
    blt     drawLoop        //no keep going
	mov		r0, #1
	b		mainMenuDone
	
mainMenuChangeSelection:
	bl		MainMenuSelect
	b		mainMenuLetGo
		
mainMenuLetGo:
	bl	LongDelayLoop	// Delay loop so user doesn't double click
	bl	ReadSNES	// Read from the controller
	ldr	r1, =0xFFFF		// Load the value when no buttons are pressed
	teq	r0, r1			// Compare value when no buttons pressed to what we got from controller
	bne	mainMenuLetGo	// Until no buttons pressed loop back up
	b	mainMenuControllerRead // After no buttons are pressed check for next button
		
mainMenuDone:	
	
	pop		{pc}
	
	

/* Delay loop so that player doesn't accidently click a few times in a row
 * Args:
 *  none
 * Return:
 *  none
 */
.globl LongDelayLoop
LongDelayLoop:
	push	{r4-r5,lr}
	
	mov	r4, #0		// Move 0 into counter
	ldr	r5, =100000 // Set how many time to loop (the larger the longer the delay)
delayLoopLoop:
	add	r4, #1		// Add to counter
	cmp	r4, r5		// Compare to how many times to loop
	blo	delayLoopLoop	// Branch till done the loop r5 times
	
	pop		{r4-r5,pc}
	

/* Extra long delay loop used for start menu
 * Args:
 *  none
 * Return:
 *  none
 */
.globl ExtraLongDelayLoop
ExtraLongDelayLoop:
	push	{r4-r5,lr}
	
	mov	r4, #0		// Move 0 into counter
	ldr	r5, =1000000 // Very large delay
extraDelayLoopLoop:
	add	r4, #1		// Add to counter
	cmp	r4, r5		// Compare to how many times to loop
	blo	extraDelayLoopLoop	// Branch till done the loop r5 times
	
	pop		{r4-r5,pc}
	
