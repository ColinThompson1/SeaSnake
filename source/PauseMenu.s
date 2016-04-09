.section .text

//Draw the PauseMenu
.globl	PauseMenu
PauseMenu:

	mov	r0,	#256
	mov r1, #256
	ldr r2, =PauseMenuImg
	mov r3, #500
	mov r4, #250
	bl drawImage
	
	mov	r0,	#608
	mov r1, #352
	ldr r2, =PauseMenuShell
	mov r3, #32
	mov r4, #32
	bl drawImage
	
	b 	PauseMenuControl

	
	
	//BRANCH TO THE SELECTOR SUBROUTINE WHERE WE FIGURE OUT WHAT OPTION THEY CHOOSE AND DRAW 





haltLoop$:
	b		haltLoop$// restart game and quit
.section .data


.globl Paused
Paused:
	.asciz 	"Game Menu"

.globl Restart
Restart:
	.asciz 	"Restart Game"

.globl Quit
Quit:
	.asciz 	"Quit Game"
