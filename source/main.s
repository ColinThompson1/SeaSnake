.section    .init
.globl     _start

_start:
    b       main
    
.section .text

main:
    mov     sp, #0x8000
	
	bl		EnableJTAG		// Enable JTAG
	bl		InitFrameBuffer	// Initalize the frame buffer
	bl		InitGPIO		// Initalize SNES controller
	
.globl mainMenu$			// Made global so user can go back into 
mainMenu$:
	bl		DrawMenus		// Draw the main menu texts
	bl		MainMenuControl	// Enable the controller to act in the main menu
	
	cmp		r0, #0			// If MainMenuControl returns 0 in r0 then... 
	bne		haltLoop$		// ... "quit game"
.globl startGame
startGame:	
	bl		GameLoop

 
haltLoop$:
	b		haltLoop$
