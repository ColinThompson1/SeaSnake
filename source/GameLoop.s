.section .text
/*  
Main Game Loop
Input:    
			r0 - 
*/

 

.globl GameLoop

GameLoop:
	
	push {r4, r5, r6, r7, r8, r9, r10, lr}
	mov r0, #0
	mov r1, #0
	ldr r3, =AppleLocation // Write new door location
	strb r0, [r3, #2]
	strb r1, [r3, #3]
	
	bl ResetArrayForStart
	
	//reset score
	ldr r0, =ScoreCount
	mov r1, #0
	strb r1, [r0]
	
	//Reset head coords
	ldr r0, =HeadX
	mov r1, #16
	strb r1, [r0]
	
	ldr r0, =HeadY
	mov r1, #12
	strb r1, [r0]
	
	//Reset crown
	ldr r0, =AppleLocation
	mov r1, #6
	strb r1, [r0, #4]
	mov r1, #0
	strb r1, [r0, #5]
	
	//ensure number of lives is 3 everytime we restart / lose the game 	
	ldr		r3, =Lives				//address of lives
	mov		r0, #3					//number of lives
	strb		r0, [r3]			//store number of lives
	
	bl		GameMenu
	b		first
	
	
.globl noReset
noReset:
	
	bl		GameMenu
	ldr r0, =ScoreCount
	ldrb	r0, [r0]
	bl 		itoa
	mov		r0, #100
	mov		r1, #10
	ldr		r2, =0x0000		// Navy blue(we can change this easily)
	ldr		r3, =NumberToPrint
	bl		DrawSentence		//init print 0
	
first:	
	
	// Draw first apple
	bl DrawApple
	ldr r3, =AppleLocation // Write new apple location
	strb r0, [r3]
	strb r1, [r3, #1]
	
	
Dead:
	//Storage Registers
	mov	r5, #-1 //X direction
	mov r6, #0 //Y direction
	ldr	r11, =0x240
	
		// Reset tail
	bl ResetTail
	
			// Reset head coords
	ldr r0, =HeadY
	mov r1, #12
	strb r1, [r0]
	ldr r0, =HeadX
	mov r1, #16
	strb r1, [r0]

starto:

	ldr r0, =Lives //Load lives from memory
	ldrb r1, [r0]
	cmp r1, #0 // before this we need to print the lives
	bne continue  //Continute by subtracting lives or lose game
	bl LoseMenu
continue:
	sub r1, #1	// Decrement lives
	strb r1, [r0]
	add r3, r1, #49
	mov		r0, #576
	mov		r1, #10
	ldr		r2, =0x0000		// Navy blue(we can change this easily)
	//ldr	r3, =Lives	//buffer to store converted num (in ascii)
	bl		DrawChar		//init print 0

	ldr r0, =ScoreCount //Load lives from memory
	ldrb r1, [r0]
	cmp r1, #20
	blt Top
	ldr r3, =AppleLocation // this is the door location
	ldrb r0, [r3, #2]
	ldrb r1, [r3, #3]
	cmp r0, #0
	beq Top
	cmp r1, #0
	beq Top
	lsl r0, #5
	lsl r1, #5
	ldr r2, =Door
	mov		r3, #32
	mov		r4, #32
	bl drawImage
	


Top: // this is where we deal with the powerups
// try to delete the crown before we print a new one

	ldr r0, =Lives //load game counter from memory
	ldrb r1, [r0, #1]
	cmp r1, #255
	bne cont
	push {r0, r1, r3, r4}
	ldr r1, =AppleLocation //Get location of old and remove image
	ldrb r0, [r1, #4]
	ldrb r1, [r1, #5]
	mov		r0, r0, lsl #5
	mov		r1, r1, lsl #5
	ldr		r2, =BackgroundImage
	mov		r3, #32
	mov		r4, #32
	bl 		drawImage
	
	bl DrawPU
	ldr r3, =AppleLocation // Write new location
	strb r0, [r3, #4]  //Draw new powerup at location
	strb r1, [r3, #5]
	pop {r0, r1, r3, r4}
	mov r1, #0
cont:
	add r1, #1
	strb		r1, [r0, #1]



	

	
.globl noDoor
noDoor:
	ldr r0, =HeadY
	ldrb r1, [r0]
	ldr r0, =HeadX
	ldrb r0, [r0]
	bl HitDetection
	cmp r0, #1
	bne dead2
	
	push {r0}
	bl	GameMenu		//if we hit a wall
	bl	DrawApple		//redraw apple and wall
	ldr r12, =AppleLocation // Write new apple location
	strb r0, [r12]
	strb r1, [r12, #1]
	pop {r0}
	
dead2:	

	cmp r0, #1
	beq Dead			//check if we are dead
	

	ldr r0, =ScoreCount
	ldrb	r0, [r0]
	
	bl 		itoa
	
	mov		r0, #100
	mov		r1, #10
	ldr		r2, =0x0000		// Navy blue(we can change this easily)
	ldr		r3, =NumberToPrint
	bl		DrawSentence		//init print 0

	ldr	r3, =NumberToPrint	//buffer to store converted num (in ascii)
	ldr r12, =AppleLocation // Write new apple location
	ldrb r0, [r12]
	ldr	r2, =HeadX
	ldrb r2, [r2]
	cmp r2, r0
	bne NotApple
	
	ldr	r2, =HeadY  //Check y
	ldrb r2, [r2]
	ldrb r0, [r12, #1]
	cmp r2, r0
	bne NotApple

	
	bl AddToTail //Extend tail
	
	bl	DrawApple		//redraw apple and wall
	ldr r12, =AppleLocation // Write new apple location
	strb r0, [r12]
	strb r1, [r12, #1]
	
	ldr	r3, =ScoreCount			//update the score
	ldrb r0, [r3]
	add		r0, #1
	strb	r0, [r3]
	cmp r0, #20
	bne notDoor
	push {r0}
	bl DrawDoor
	
	ldr r3, =AppleLocation // Write new door location
	strb r0, [r3, #2]
	strb r1, [r3, #3]
	pop {r0}
	
	

notDoor:	
	bl itoa
	
	mov		r0, #96  //Generate new background behind score
	mov		r1, #0
	ldr		r2, =BackgroundImage
	mov		r3, #32
	mov		r4, #32
	bl 		drawImage
	
	mov		r0, #128
	mov		r1, #0
	ldr		r2, =BackgroundImage
	mov		r3, #32
	mov		r4, #32
	bl 		drawImage
	
	mov		r0, #96
	mov		r1, #32
	ldr		r2, =BackgroundImage
	mov		r3, #32
	mov		r4, #32
	bl 		drawImage
	
	mov		r0, #128
	mov		r1, #32
	ldr		r2, =BackgroundImage
	mov		r3, #32
	mov		r4, #32
	bl 		drawImage
	
	mov		r0, #100
	mov		r1, #10
	ldr		r2, =0x0000		// Navy blue(we can change this easily)
	ldr	r3, =NumberToPrint	//buffer to store converted num (in ascii)
	bl		DrawSentence		//init print 0
	
	
	
lowScore:
	
NotApple:

	ldr r0, =AppleLocation
	ldrb r1, [r0, #4]
	ldrb r0, [r0, #5]

	//Check for crown
	ldr	r2, =HeadX  //Check X
	ldrb r2, [r2]
	cmp r2, r1
	bne NotCrown
	
	ldr	r2, =HeadY //Check Y
	ldrb r2, [r2]
	cmp r2, r0
	bne NotCrown
	
	ldr r0, =Lives //Get ref to lives for update
	ldrb r1, [r0]
	
	push {r0, r1, r2, r3, r4}
	mov		r0, #576
	mov		r1, #0
	ldr		r2, =BackgroundImage
	mov		r3, #32
	mov		r4, #32
	bl 		drawImage
	pop {r0, r1, r2, r3, r4}
	
	add r1, #1	// increment lives
	strb r1, [r0]
	add r3, r1, #49
	mov		r0, #576
	mov		r1, #10
	ldr		r2, =0x0000		// Navy blue(we can change this easily)
	//ldr	r3, =Lives	//buffer to store converted num (in ascii)
	bl		DrawChar		//init print 0fsc
	
	push {r1- r4}
	mov		r0, #96
	mov		r1, #0
	ldr		r2, =BackgroundImage
	mov		r3, #32
	mov		r4, #32
	bl 		drawImage
	
	ldr r0, =ScoreCount
	ldrb	r1, [r0]
	add r1, #1
	strb r1, [r0]
	mov r0, r1
	bl 		itoa
	mov		r0, #100
	mov		r1, #10
	ldr		r2, =0x0000		// Navy blue(we can change this easily)
	ldr		r3, =NumberToPrint
	bl		DrawSentence		//init print 0
	pop {r1-r4}
	
	
	
NotCrown:
	

	ldr r12, =AppleLocation  //Check if hit door
	ldrb r0, [r12, #2]
	ldr	r2, =HeadX
	ldrb r2, [r2]
	cmp r2, r0
	bne Buttons
	
	ldr	r2, =HeadY
	ldrb r2, [r2]
	ldrb r0, [r12, #3]
	cmp r2, r0
	bne Buttons
	bl WinMenu // user wins the game

Buttons:

	bl	ReadSNES		// read SNES
	ldr	r1, =0xFFEF		// full mask
	teq	r0, r1			// test if up button is pressed
	bne down
	cmp r6, #1			//Make sure not to go backwards
	beq down
	mov r5, #0			// Reset x
	mov r6, #-1		// Reset y
	b next

down:
	ldr	r1, =0xFFDF		// full mask
	teq	r0, r1			// test if up button is pressed
	bne left
	cmp r6, #-1			//Make sure not to go backwards
	beq left
	mov r5, #0			// Reset x
	mov r6, #1		// Reset y
	b next
left:
	ldr	r1, =0xFFBF		// full mask
	teq	r0, r1			// test if up button is pressed
	bne right
	cmp r5, #1			//Make sure not to go backwards
	beq right
	mov r5, #-1			// Reset x
	mov r6, #0		// Reset y
	b next
right:
	ldr	r1, =0xFF7F		// full mask
	teq	r0, r1			// test if up button is pressed
	bne start
	cmp r5, #-1			//Make sure not to go backwards
	beq start
	mov r5, #1		// Reset x
	mov r6, #0			// Reset y
	b next
start:
	ldr	r1, =0xFFF7		// full mask
	teq	r0, r1			// test if start is pressed
	bne next
	ldr	r0, =Lives
	ldrb r1, [r0]
	add	r1, #1
	strb	r1, [r0]
	bl PauseMenu

next:

  add r10, #1
  cmp r10, r11
  blt Buttons
  mov r10, #0 		// Reset counter for next time
  
  // boolean stillAZero = false
  ldr r0, =StillNoCord
  mov r1, #0
  strb r1, [r0]
  
  // Store GetFirstCoordNum in memory for later.
  bl GetFirstCoordNum
  ldrb r0, [r0] //Load from returned addresses 
  ldrb r1, [r1]
  ldr r3, =CoordX //Location to store item
  strb r0, [r3] //Store item
  ldr r3, =CoordY
  strb r1, [r3]
  
  // do { 
  //	a = [x + 1]
  // 	b = [x]		}
  
  ldr r9, =X //Get snake X addr
  ldr r12, =Y //Get snake Y addr
  ldrb r7, [r9, #1]
  ldrb r8, [r9]
  
  // While a != 50 {
  // 	if (b = 51) {
  //		if (a != 51) {
  //			stillAZero = true
  //			goto else
  //		}
  //		inc x, y
  //		a = [x + 1]
  //		b = [x]
  //		stillAZero = true
  //		continue
  //	}
  
While:
  mov r0, #50 // Move for multiplying
  cmp r7, r0
  beq End 
  
  mov r0, #51 // Move for multiplying
  cmp r8, r0
  bne Else
  
  cmp r7, r0 //Check if a is also empty
  beq AlsoFiftyOne
							
	ldr r0, =StillNoCord    //Stillazero = true
	mov r1, #1
	strb r1, [r0]
	b Else				// Start swaping through values
	
  AlsoFiftyOne:
	add r9, #1
	add r12, #1
	ldrb r7, [r9, #1] 	// a = [x + 1]
	ldrb r8, [r9]		// b = [x]
	
	ldr r0, =StillNoCord    //Stillazero = true
	mov r1, #1
	strb r1, [r0]
	b While
  
  Else:
  
	strb r7, [r9] // [x] = a
	ldrb r4, [r12, #1] // [y] = [y + 1]
	strb r4, [r12]
	
	add r9, #1 // increment the addresses
	add r12, #1
  
	ldrb r7, [r9, #1] 	// a = [x + 1]
	
	b While //Try to reloop  
  
  
  // [x] = (new X value) = [x] + currentDirX
  // [y] = (new Y value) = [y] + currentDirY
  // if stillAZero != 1
  // 	load original x and y and drawbackground w/ them
  
End:
	ldrb r4, [r12] //update x
	ldrb r8, [r9]
	
	// Load stuff for drawing body to replace head
	mov	r0,	r8, lsl #5
	mov r1, r4, lsl #5
	ldr r2, =BodyImage
	mov r3, #32
	push {r4}
	mov r4, #32
	bl drawImage
	pop {r4}
	
	add	r8, r5 //old vaule plus movement
	add r4, r6
	strb r8, [r9]
	strb r4, [r12]
	
	ldr r2, =HeadX
	strb r8, [r2]
	ldr r2, =HeadY
	strb r4, [r2]
	
	// Load stuff for drawing shark
	mov r0, r8, lsl #5 //Coord * 32  
	mov r1, r4, lsl #5
	ldr r2, =SharkHead
	mov r3, #32
	mov r4, #32
	bl drawImage
	
	ldr r0, =StillNoCord
	ldrb r1, [r0]
	cmp r1, #1
	beq NoDraw
	
	ldr r0, =CoordX		// Load original x
	ldrb r1, [r0]
	ldr r0, =CoordY		// Load original x
	ldrb r2, [r0]
	
	mov r0, r1, lsl #5  // Set parameters up
	mov r1, r2, lsl #5
	ldr	r2, =BackgroundImage
	mov r3, #32
	mov r4, #32
	bl drawImage		//Redraw Square
	
	
NoDraw:
	
	b Top
	
pop {r4, r5, r6, r7, r8, r9, r10, lr}



// Resets all blocks in tail except for the starting 3
ResetTail:
	push {r4, r5, r6, r7, lr}
	ldr r4, =X	// Load current snake array
	ldr	r5, =Y
	mov r7, #51 // Coordinate-free tail marker
resetLoop:		// Load three bytes ahead
	ldrb	r6, [r4, #3]
	/*
	mov r0, r6, lsl #5  // Set parameters up
	ldrb	r2, [r5, #3]
	mov r1, r2, lsl #5
	ldr	r2, =0xFFFF
	bl DrawSquare		//Redraw Square
	*/
	cmp r6, #50
	beq finishReset
	strb r7, [r4] //Store byte to indicate tail block without location
	strb r7, [r5]
	add	r4, #1	//Increment position
	add	r5, #1
	b resetLoop
	
finishReset:
	mov r0, #18
	strb r0, [r4]		
	mov r0, #17
	strb r0, [r4, #1]
	mov r0, #16
	strb r0, [r4, #2]
	
	mov r0, #12
	strb r0, [r5]
	strb r0, [r5, #1]
	strb r0, [r5, #2]

	//bl	GameMenu

	mov r0, #16
	pop {r4, r5, r6, r7, lr}
	bx lr



// Retruns the first number with a coord. return address of it in r0 and r1
GetFirstCoordNum:
	push {r4, r5, r6, lr}
	ldr r4, =X	// Load current snake array
	ldr r6, =Y
GetCoordLoop:
	ldrb r5, [r4]
	cmp r5, #51
	bne NonZeroCoord
	add r4, #1  // Increment position
	add	r6, #1
	b GetCoordLoop
NonZeroCoord:
	mov r0, r4 //Move for return
	mov r1, r6
	pop {r4, r5, r6, lr}
	bx lr

//Adds one block to the tail
AddToTail:
	push {r4-r9, lr}
	ldr r8, =X
	ldr r9, =Y
	mov r4, r8
	mov r5, r9
TopOfAddTail:
	ldrb r6, [r4, #1] //Make sure next one isnt 50
	cmp r6, #50
	beq AddIt //Go to the end
	add r4, #1
	add r5, #1
	b TopOfAddTail
AddIt:
	cmp r4, r8
	beq BackAtBeginning //Shift everything right
	ldrb r7, [r5]
	ldrb r6, [r4]
	strb r7, [r5, #1]
	strb r6, [r4, #1]
	sub r4, #1
	sub r5, #1
	b AddIt
BackAtBeginning:
	ldrb r7, [r5] //Move set a spot for new tail growth
	ldrb r6, [r4]
	strb r7, [r5, #1]
	strb r6, [r4, #1]
	mov r0, #51
	strb r0, [r8]
	strb r0, [r9]
	pop {r4-r9, lr}
	bx lr

//Resets the array for the start of the game
ResetArrayForStart:
push {r4-r6, lr}
ldr r4, =X
ldr r5, =Y
ldrb r6, [r4]
topofReset:
	cmp r6, #50
	beq doneReset
	mov r0, #50
	strb r0, [r4]
	strb r0, [r5]
	add r4, #1
	add r5, #1
	ldrb r6, [r4]
	b topofReset
doneReset:
	ldr r4, =X
	ldr r5, =Y
	mov r0, #18
	strb r0, [r4]
	mov r0, #17
	strb r0, [r4, #1]
	mov r0, #16
	strb r0, [r4, #2]
	
	mov r0, #12
	strb r0, [r5]
	strb r0, [r5, #1]
	strb r0, [r5, #2]

	pop {r4-r6, lr}
	bx lr
	
	
.section .data
.align 1

// Two-D Array of the "Snake"
.globl X
.globl Y
X:
//.byte	51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51
//.byte	51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51 //Uncomment for the fun times
//.byte	51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51 //But then comment the reset
.byte	18,17,16,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50 //subroutine call
.byte	50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50
.byte	50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50
.byte	50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50
.byte	50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50
.byte	50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50
.byte	50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50

Y:
//.byte	51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51
//.byte	51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51
//.byte	51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51
.byte	12,12,12,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50
.byte	50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50
.byte	50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50
.byte	50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50
.byte	50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50
.byte	50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50
.byte	50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50

CoordX:
.byte	0
CoordY:
.byte	0

HeadX:
.byte	16
HeadY:
.byte	12

StillNoCord:
.byte	0

Lives:
.byte	3, 0
 
.section .data
.globl AppleLocation
AppleLocation:
.byte 0, 0, 0, 0, 6, 0 // apple, door, crown
.globl ScoreCount
ScoreCount: 
.int 0
GoingToWin:
.byte 0
.globl NumberToPrint
NumberToPrint:
.ascii "0"


