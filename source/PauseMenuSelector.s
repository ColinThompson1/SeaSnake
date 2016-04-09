//Pause Menu Selector 
//This will allow the user to choose between quiting and restarting the game from the pause menu

 
 .globl PauseMenuControl
 
 PauseMenuControl:
	push { r4-r7, lr}

	
	mov		r7, #0			//if r4 = 0 then restart game is highlighted if 1 = quit game is highlighted
	
menuLetGo:
	bl	LongDelayLoop	// Delay loop so user doesn't double click
	bl	ReadSNES	// Read from the controller
	ldr	r1, =0xFFFF		// Load the value when no buttons are pressed
	teq	r0, r1			// Compare value when no buttons pressed to what we got from controller
	bne	menuLetGo	// Until no buttons pressed loop back up
	b	controllerRead // After no buttons are pressed check for next button
	
	
controllerRead:	
	bl	LongDelayLoop	// Delay loop so user doesn't double click
	bl	ReadSNES		// read SNES
	ldr	r1, =0xFFFF		// full mask
	teq	r0, r1			// test if no buttons are pressed
	beq	controllerRead	// read controller again when no buttons are pressed
	
	ldr	r1, =0xFEFF		// mask for bit [8]
	teq	r0, r1			// test if 'a' was pressed 
	beq	aPress
	
	ldr	r1, =0xFFEF		// mask for bit [4]
	teq	r0, r1			// test if 'up' was pressed
	beq	changeSelection
	
	ldr	r1, =0xFFDF		// mask for bit [5]
	teq	r0, r1			// test if 'down' was pressed
	beq	changeSelection
	
	ldr	r1, =0xFFF7		// mask for bit [5]
	teq	r0, r1			// test if 'start' was pressed
	beq	resume
	
	b	controllerRead	// branch if none of these buttons are being pressed by themselves
	
	//go back to game screen
resume:
	bl noReset
	
	//if user pressed a 
aPress:
	
	cmp		r7,	#0
	bne		quiting			//if quit game was selected: quiting
	
	pop { r4-r7, lr}
	
	// need to restart the gameboard here
	bl		GameLoop		//else start
	
quiting:
	ldr	r2, =0x0000
	bl	PaintScreen
	bl		_start

changeSelection:
	cmp		r7, #0			//are we highlighting restart or quit
	bne		changeToRestart	//if quit game change to restart
	
	mov		r7, #1			//else change to quit game
	
	mov	r0,	#608
	mov r1, #352
	ldr r2, =0x0000
	bl	DrawSquare
	
	mov	r0,	#608
	mov r1, #384
	ldr r2, =PauseMenuShell
	mov r3, #32
	mov r4, #32
	bl drawImage
	
	b 		menuLetGo
	
changeToRestart:
	mov		r7, #0			//change to restart
	
	mov	r0,	#608
	mov r1, #384
	ldr r2, =0x0000
	bl	DrawSquare
	
	mov	r0,	#608
	mov r1, #352
	ldr r2, =PauseMenuShell
	mov r3, #32
	mov r4, #32
	bl drawImage
	
	
	b		menuLetGo
	
	
	
