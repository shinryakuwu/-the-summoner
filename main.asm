  .inesprg 1   ; 1x 16KB PRG code
  .ineschr 1   ; 1x  8KB CHR data
  .inesmap 0   ; mapper 0 = NROM, no bank swapping
  .inesmir 1   ; background mirroring

	.include "variables.asm"      ; and also constants
	.include "initialize.asm"     ; RESET vector, load palette/background/attributes
  .include "mainloop.asm"       ; main loop subroutines
	.include "nmi.asm" 		        ; NMI vector
	.include "readcontroller.asm"
	.include "multiply.asm"
	.include "passability.asm"
	.include "movement.asm"       ; character movement and animation
  .include "warp.asm"           ; teleport character to needed location and position
	.include "tiles.asm"

  .org $FFFA     ;first of the three vectors starts here
  .dw NMI        ;when an NMI happens (once per frame if enabled) the 
                   ;processor will jump to the label NMI:
  .dw RESET      ;when the processor first turns on or is reset, it will jump
                   ;to the label RESET:
  .dw 0          ;external interrupt IRQ is not used

;;;;;;;;;;;;;;  

  .bank 2
  .org $0000
  .incbin "graphics.chr"   ;includes 8KB graphics file