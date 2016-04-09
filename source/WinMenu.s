.section .text


.globl	WinMenu
WinMenu:

	ldr		r2,	=0x2FFF  //light blue
    bl		PaintScreen // paints screen light blue
    
// Draws the text "You Win: "
	mov		r0, #300 // writes you win at 300x300
	mov		r1, #300 // writes you win at 300x300
	ldr		r2, =0xB1FF	// purple font
	ldr		r3,	=Win
	bl		DrawSentence


inputLoop:
	bl	ReadSNES // read snes so that when we press any button, we can continue to main menu
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
Win:
	.asciz 	"You Win :)"
