
    
.section .text
.globl GameMenu
GameMenu:
	push {r4-r8, lr}
    mov    r4, #0           //init counter to 0


drawLoop:

    mov    r5, #0           //x pos of pixel
drawLine:
	mov		r0, r5
	mov		r1, r4        //y pos of pixel
	ldr		r2,	=BackgroundImage  //colour of pixel
	mov		r3, #32
	push {r4}
	mov		r4, #32
	bl		drawImage
	pop {r4}

    add    r5, #32            //increment x pos of pixel
    cmp    r5, #1024        //have we filled out the whole line
    blt    drawLine         //no than finish it

    add    r4, #32           //otherwise go to next line

drawLoopTest:
//1024 X 768
    cmp     r4, #768        //have we painted all lines
    blt     drawLoop        //no keep going



	mov r0, #0 //x
brickTop:

	mov r1, #64 //y
	mov r3, #32
	mov r4, #32
	ldr r2, =brick
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	add r0, #32 //x
	cmp r0, #1024
	blt brickTop

	mov r0, #0 //x
brickBottom:

	mov r1, #736 //y
	mov r3, #32
	mov r4, #32
	ldr r2, =brick
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	add r0, #32 //x
	cmp r0, #1024
	blt brickBottom         
                         
                         
	mov r1, #64 //y
brickRight:

	mov r0, #0 //x
	mov r3, #32
	mov r4, #32
	ldr r2, =brick
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	add r1, #32 //x
	cmp r1, #768
	blt brickRight                            




	mov r1, #64 //y
brickLeft:

	mov r0, #992 //x
	mov r3, #32
	mov r4, #32
	ldr r2, =brick
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	add r1, #32 //x
	cmp r1, #768
	blt brickLeft

// Draws the text "Score: "
	mov		r0, #10
	mov		r1, #10
	ldr		r2, =0x0000		// Navy blue(we can change this easily)
	ldr		r3,	=Score
	bl		DrawSentence
	
	
	mov		r0, #100
	mov		r1, #10
	ldr		r2, =0x0000		// Navy blue(we can change this easily)
	mov		r3, #48
	bl		DrawChar	//init print 0
	
	
	mov		r0, #96
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
	
	ldr	r3, =NumberToPrint	//buffer to store converted num (in ascii)
	mov	r0, #0
	str	r0, [r3]			//init memory
	str	r0, [r3, #2]
	
	



// Draws the text "Lives: "
	mov		r0, #500
	mov		r1, #10
	ldr		r2, =0x0000		// Navy blue(we can change this easily)
	ldr		r3,	=Lives
	bl		DrawSentence
	bl 	drawObstacles
	//bl	GameLoop //Start game
	pop {r4-r8, lr}
	bx		lr

haltLoop$:
	b		haltLoop$


.globl drawObstacles
drawObstacles:
	push {r0,r1,r2,r3,r4, lr}
	mov r0, #224	
	mov r1, #192
	ldr r2, = obstacle
	mov r3, #32
	mov r4, #32
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	
	mov r0, #224	
	mov r1, #224
	ldr r2, = obstacle
	mov r3, #32
	mov r4, #32
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	
	mov r0, #224	
	mov r1, #256
	ldr r2, = obstacle
	mov r3, #32
	mov r4, #32
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	
	mov r0, #224	
	mov r1, #288
	ldr r2, = obstacle
	mov r3, #32
	mov r4, #32
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	
	mov r0, #224	
	mov r1, #320
	ldr r2, = obstacle
	mov r3, #32
	mov r4, #32
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	
	mov r0, #480	
	mov r1, #480
	ldr r2, = obstacle
	mov r3, #32
	mov r4, #32
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	
	mov r0, #512	
	mov r1, #480
	ldr r2, = obstacle
	mov r3, #32
	mov r4, #32
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	
	mov r0, #544	
	mov r1, #480
	ldr r2, = obstacle
	mov r3, #32
	mov r4, #32
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	
	mov r0, #576	
	mov r1, #480
	ldr r2, = obstacle
	mov r3, #32
	mov r4, #32
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	
	mov r0, #672	
	mov r1, #128
	ldr r2, = obstacle
	mov r3, #32
	mov r4, #32
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
		
	mov r0, #672	
	mov r1, #160
	ldr r2, = obstacle
	mov r3, #32
	mov r4, #32
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	
	mov r0, #672	
	mov r1, #192
	ldr r2, = obstacle
	mov r3, #32
	mov r4, #32
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	
	mov r0, #640	
	mov r1, #192
	ldr r2, = obstacle
	mov r3, #32
	mov r4, #32
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	
	mov r0, #608	
	mov r1, #192
	ldr r2, = obstacle
	mov r3, #32
	mov r4, #32
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	
	mov r0, #576	
	mov r1, #192
	ldr r2, = obstacle
	mov r3, #32
	mov r4, #32
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	

	mov r0, #160	
	mov r1, #704
	ldr r2, = obstacle
	mov r3, #32
	mov r4, #32
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	
	mov r0, #160	
	mov r1, #672
	ldr r2, = obstacle
	mov r3, #32
	mov r4, #32
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	
	mov r0, #160	
	mov r1, #640
	ldr r2, = obstacle
	mov r3, #32
	mov r4, #32
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	
	mov r0, #160	
	mov r1, #608
	ldr r2, = obstacle
	mov r3, #32
	mov r4, #32
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	
	mov r0, #896	
	mov r1, #640
	ldr r2, = obstacle
	mov r3, #32
	mov r4, #32
	push {r0-r4}
	bl drawImage
	pop {r0-r4}
	
	
	pop {r0,r1,r2,r3,r4, lr}
	bx lr


.section .data
.globl Score
Score:	
	.asciz 	"Score:"
.globl Lives
Lives:	
	.asciz 	"Lives:"
