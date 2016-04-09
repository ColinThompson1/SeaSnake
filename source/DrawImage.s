.section .text
/*    Draws an Image on screen
    Input:    
			r0 - X coordinate
            r1 - Y coordinate
            r2 - Image Address
            r3 - image X dim
            r4 - image Y dim
*/

 
.globl drawImage

drawImage:
    push    {r5-r10,lr}
    mov    r7, r2
    mov    r5, r0
    mov    r8, r0
    mov    r6, r1
    add r9, r3, r0
    add    r10,r4, r1

drawLoopIm:
    mov r0, r5
    mov    r1, r6
    ldr    r2, [r7]            //grabs pixel color from ascii image
    bl    DrawPixel
    add    r7, #2
    add    r5, #1
    cmp    r5, r9
    blt    drawLoopIm
    add    r6, #1
    mov    r5, r8
    cmp r6, r10
    blt    drawLoopIm
   
    pop        {r5-r10,lr}
    bx    lr	
