.section .text


.globl	LoseMenu
LoseMenu:
	ldr		r2,	=0x119F   //colour of pixel
    bl		PaintScreen
    
// Draws the text "You Lose: "
	mov		r0, #300
	mov		r1, #300
	ldr		r2, =0xFFEA		// yellow
	ldr		r3,	=Lose
	bl		DrawSentence


inputLoop:
	bl	ReadSNES
	ldr	r6, =0xFFFF
	cmp	r0, r6
	bne	next

	b	inputLoop

next:
	ldr	r2, =0x0000
	bl	PaintScreen
	bl	_start

haltLoop$:
	b		haltLoop$// restart game and quit
.section .data


.globl Lose
Lose:
	.asciz 	"You Lose :( "
