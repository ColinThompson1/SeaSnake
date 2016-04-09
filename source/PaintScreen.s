.globl	PaintScreen

//r2 - colour to be painted
PaintScreen:
push {r4, r5, lr}

mov    r4, #0           //init counter to 0


drawLoop:

    mov    r5, #0           //x pos of pixel
drawLine:
	mov		r0, r5
	mov		r1, r4        //y pos of pixel
	//ldr		r2,	=0x119F   //colour of pixel
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
    
    pop {r4,r5, lr}
    
    bx	lr
