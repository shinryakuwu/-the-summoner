  .inesprg 2   ; 1x 16KB PRG code
  .ineschr 1   ; 1x  8KB CHR data
  .inesmap 0   ; mapper 0 = NROM, no bank swapping
  .inesmir 0   ; background mirroring

;;;;;;;;;;;;;;

  .rsset $0000                  ;;start variables at ram location 0
  .include "variables.asm"      ; and also constants

;;;;;;;;;;;;;;

  .bank 0
  .org $8000

  .include "initialize.asm"     ; RESET vector, load palette/background/attributes
  .include "bgrender.asm"       ; bg rendering subroutine
  .include "nmi.asm"            ; NMI vector
  .include "readcontroller.asm"
  .include "math.asm"
  .include "passability.asm"
  .include "calculate_tile"     ; subroutine to calculate tile in front of the cat
  .include "movement.asm"       ; character movement and animation
  .include "drawcat.asm"        ; subroutine that moves cat graphics data from cache into PPU
  .include "warp.asm"           ; teleport character to needed location and position
  .include "animatetiles"       ; animate different objects on locations
  .include "actions.asm"        ; checks and params for performing events
  .include "rendertext.asm"
  .include "events.asm"         ; logic for performing any events aside from rendering text
  .include "dots.asm"           ; logic for drawing dots identifying that the action is possible
  .include "scroll.asm"

;;;;;;;;;;;;;;

  .bank 1
  .org $A000

  .include "sound_engine.asm"

;;;;;;;;;;;;;;

  .bank 2
  .org $C000

  .include "tiles_sprites.asm"    ; stores tiles for sprites

;;;;;;;;;;;;;;

  .bank 3
  .org $E000

  .include "tiles_bg.asm"         ; stores tiles for background
  .include "tiles_text.asm"       ; stores tiles for text

;;;;;;;;;;;;;;

  .org $FFFA     ;first of the three vectors starts here
  .dw NMI        ;when an NMI happens (once per frame if enabled) the 
                   ;processor will jump to the label NMI:
  .dw RESET      ;when the processor first turns on or is reset, it will jump
                   ;to the label RESET:
  .dw 0          ;external interrupt IRQ is not used

;;;;;;;;;;;;;;

  .bank 4
  .org $0000
  .incbin "graphics.chr"   ;includes 8KB graphics file
