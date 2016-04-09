// Input
// r0 is the x coord
// r1 is the y coord
// Returns boolean value if is a hit

.globl HitDetection
HitDetection:
push {r2, r7, r8, lr}
	mov r7, r0 // X location
	mov r8, r1 // Y location

cmp r7, #0 // test to see if shark touched left side
	beq leftHit
	cmp r8, #2
	beq topHit // test to see if shark hit top side
	cmp r8, #23
	beq bottomHit // test to see if shark hits bottom side
	cmp r7, #31
	beq rightHit // test to see if shark hit right side
	cmp r7, #7 // this whole thing tests to see if shark hits poop
	bne not
	cmp r8, #6 // compare anything to where there is an obstacle on the game board, the rest of these cmps just do that
	beq poopHit
	cmp r8, #7
	beq poopHit
	cmp r8, #8
	beq poopHit
	cmp r8, #9
	beq poopHit
	cmp r8, #10
	beq poopHit
not:
	cmp r8, #15
	bne not2
	cmp r7, #15
	beq poopHit
	cmp r7, #16
	beq poopHit
	cmp r7, #17
	beq poopHit
	cmp r7, #18
	beq poopHit
not2:
	cmp r7, #21
	bne not3
	cmp r8, #4
	beq poopHit
	cmp r8, #5
	beq poopHit
	cmp r8, #6
	beq poopHit
not3:
	cmp r8, #6
	bne not4
	cmp r7, #18
	beq poopHit
	cmp r7, #19
	beq poopHit
	cmp r7, #20
	beq poopHit
not4:
	cmp r7, #5
	bne not5
	cmp r8, #19
	beq poopHit
	cmp r8, #20
	beq poopHit
	cmp r8, #21
	beq poopHit
	cmp r8, #22
	beq poopHit
not5:
	cmp r7, #28
	bne none
	cmp r8, #20
	beq poopHit
	b	none
	
leftHit:
	push {r12}
	mov r0, #0
	mov r12, #32
	mul r12, r8
	mov r1, r12
	pop {r12}
	ldr r2, =brick
	mov	r3, #32
	mov	r4, #32
	bl	drawImage
	b starto
	
rightHit:
	push {r12}
	mov r0, #992
	mov r12, #32
	mul r12, r8
	mov r1, r12
	pop {r12}
	ldr r2, =brick
	mov	r3, #32
	mov	r4, #32
	bl	drawImage
	b starto	
	
topHit: // checks to see if we hit top of gameboard
	push {r12}
	mov r1, #64
	mov r12, #32
	mul r12, r7
	mov r0, r12
	pop {r12}
	ldr r2, =brick
	mov	r3, #32
	mov	r4, #32
	bl	drawImage
	b starto 
	
bottomHit: // checks to see if we hit bottom of gameboard
	push {r12}
	mov r1, #736
	mov r12, #32
	mul r12, r7
	mov r0, r12
	pop {r12}
	ldr r2, =brick
	mov	r3, #32
	mov	r4, #32
	bl	drawImage
	b starto 
	
	
poopHit: // if we hit an obstacle, we redraw the obstacle
	bl drawObstacles
	b starto 	
	
starto:
	mov r0, #1
	pop {r2, r7, r8, lr}
	bx lr
	
none:
	mov r0, r7
	mov r1, r8
	bl SnakeHitDetection
	cmp r0, #1
	beq starto
	mov r0, r7
	mov r1, r8
	bl CrownHitDetection
	cmp r0, #1
	beq starto
	mov	r0, #0
	pop {r2, r7, r8, lr}
	bx lr




// A subroutine to determine if a coord is in a snake. Returns 1 in r0 if true
SnakeHitDetection:
	push {r4-r7, lr}
	ldr r4, =X
	ldr r5, =Y
	
	ldrb r8, [r4, #2]
	
SnakeHitLoop:
	cmp r8, #50
	beq CheckLastOne
	ldrb r6, [r4]
	ldrb r7, [r5]
	cmp r6, r0
	bne trynext
	cmp r7, r1
	bne trynext
	mov r0, #1
	b finish
	
trynext:
	add r4, #1
	add r5, #1
	ldrb r8, [r4, #2]
	b SnakeHitLoop
	
CheckLastOne:
	ldrb r6, [r4]
	ldrb r7, [r5]
	cmp r6, r0
	bne nothing
	cmp r7, r1
	bne nothing
	mov r0, #1

nothing:
	mov r0, #0
	
finish:
	pop {r4-r8}
	bx lr
	
// Check if a crown is at the location given is r0 and r1, returns 1 in r0 if true
CrownHitDetection:
push {r4, r5, r6, lr}

ldr r4, =AppleLocation
ldrb r5, [r4, #4]
ldrb r6, [r4, #5]

cmp r0, r5
bne noCrown
cmp r1, r6
bne noCrown
mov r0, #1
b finishCrown
noCrown:
mov r0, #0

finishCrown:
pop {r4, r5, r6, lr}
bx lr
	

	
