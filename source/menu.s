.section .data 
.align 4


.globl MainMenu
MainMenu:		
	.asciz 	"MAIN MENU"

.globl StartGame
StartGame:	
	.asciz 	"Start Game"

.globl QuitGame	
QuitGame:	
	.asciz "Quit Game"

.globl GameName 
GameName:	
	.asciz " CPSC 359 SNAKE"

.globl Creators
Creators:	
	.asciz "BY: Lillian Iwaniszyn, Colin Thompson & Stuart Seguin"

.globl mainMenuSelected 

mainMenuSelected:
	.int		0


.section .text


.globl DrawMenus // draws the main menu image
DrawMenus:
	push {lr}
	mov	r0,	#0
	mov r1, #0
	ldr r2, =MainMenuImg
	mov r3, #1024
	mov r4, #768
	bl drawImage
	
		
	mov	r0,	#384 // draws the starfish selector on the main menu
	mov r1, #416
	ldr r2, =StartGameStar
	mov r3, #32
	mov r4, #32
	bl drawImage
	
	pop {pc}

/* Moves the main menu selector
 * Args:
 *  none
 * Return:
 *  none
 */
.globl MainMenuSelect
MainMenuSelect:
	selection	.req	r4	// What menu item is selected
	selectAdrs	.req	r5	// Address of selector integer
	push	{r4-r5, lr}
	
	ldr		selectAdrs, =mainMenuSelected	// Load address of selection
	ldr		selection, [selectAdrs]	// Load the selection
	
	cmp		selection, #0	// Test to see is StartGame selected
	beq		quitGameSelect // if it is branch to change the selection
	
startGameSelect: // this will draw >< around what is selected
	mov	r0,	#320
	mov r1, #512
	ldr r2, =QuitGameNoStar // deletes the starfish
	mov r3, #32
	mov r4, #32
	bl drawImage

	
	mov	r0,	#384
	mov r1, #416
	ldr r2, =StartGameStar // draws the starfish
	mov r3, #32
	mov r4, #32
	bl drawImage
	mov		r0,	#0
	str		r0, [selectAdrs]	// Store the selection
	b		doneSelect		// this will quit the game				
	
quitGameSelect: // this is when we select quit game
	mov	r0,	#384
	mov r1, #416
	ldr r2, =StartGameNoStar // deletes starfish from start
	mov r3, #32
	mov r4, #32
	bl drawImage
	
	mov	r0,	#320
	mov r1, #512
	ldr r2, =QuitGameStar // draws starfish next to quit
	mov r3, #32
	mov r4, #32
	bl drawImage
	
	mov		r0,	#1
	str		r0, [selectAdrs]	// Store the selection
	
doneSelect:	// when we are done with selecting the game we pop the registers

	.unreq	selection
	.unreq	selectAdrs
	pop		{r4-r5, pc}
