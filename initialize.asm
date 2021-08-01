  .bank 0
  .org $C000

vblankwait:
  BIT $2002
  BPL vblankwait
  RTS

LoadBackground:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$20
  STA $2006             ; write the high byte of $2000 address
  LDA #$00
  STA $2006             ; write the low byte of $2000 address
  
  LDX #$00              ; start at pointer + 0
  LDY #$00
OutsideLoop:
  
InsideLoop:
  LDA [currentbglow], y  ; copy one background byte from address in pointer plus Y
  STA $2007              ; this runs 256 * 4 times
  INY                    ; inside loop counter
  CPY #$00
  BNE InsideLoop         ; run the inside loop 256 times before continuing down
  
  INC currentbghigh      ; low byte went 0 to 256, so high byte needs to be changed now
  INX
  CPX #$04
  BNE OutsideLoop        ; run the outside loop 256 times before continuing down
  RTS

LoadAttribute:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$23
  STA $2006             ; write the high byte of $23C0 address
  LDA #$C0
  STA $2006             ; write the low byte of $23C0 address
  LDX #$00              ; start out at 0
  LDY #$00
LoadAttributeLoop:
  ;LDA attribute, x      ; load data from address (attribute + the value in x)
  STX $2007              ; write to PPU
  ;INX                   ; X = X + 1
  INY
  CPY #$30               ; load 0 to bg attributes 48 times
  BNE LoadAttributeLoop  ; Branch to LoadAttributeLoop if compare was Not Equal to zero
  RTS

RESET:
  SEI          ; disable IRQs
  CLD          ; disable decimal mode
  LDX #$40
  STX $4017    ; disable APU frame IRQ
  LDX #$FF
  TXS          ; Set up stack
  INX          ; now X = 0
  STX $2000    ; disable NMI
  STX $2001    ; disable rendering
  STX $4010    ; disable DMC IRQs

  JSR vblankwait       ; First wait for vblank to make sure PPU is ready

clrmem:
  LDA #$00
  STA $0000, x
  STA $0100, x
  STA $0200, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FE
  STA $0300, x
  INX
  BNE clrmem
   
  JSR vblankwait      ; Second wait for vblank, PPU is ready after this


LoadPalettes:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006             ; write the high byte of $3F00 address
  LDA #$00
  STA $2006             ; write the low byte of $3F00 address
  LDX #$00              ; start out at 0
LoadPalettesLoop:
  LDA palette, x        ; load data from address (palette + the value in x)
                          ; 1st time through loop it will load palette+0
                          ; 2nd time through loop it will load palette+1
                          ; 3rd time through loop it will load palette+2
                          ; etc
  STA $2007             ; write to PPU
  INX                   ; X = X + 1
  CPX #$20              ; Compare X to hex $10, decimal 16 - copying 16 bytes = 4 sprites
  BNE LoadPalettesLoop  ; Branch to LoadPalettesLoop if compare was Not Equal to zero
                        ; if compare was equal to 32, keep going down


LoadSprites:
  LDX #$00              ; start at 0
LoadSpritesLoop:
  LDA sprites, x        ; load data from address (sprites +  x)
  STA $0200, x          ; store into RAM address ($0200 + x)
  INX                   ; X = X + 1
  CPX #$28              ; Compare X to hex $20, decimal 32
  BNE LoadSpritesLoop   ; Branch to LoadSpritesLoop if compare was Not Equal to zero
                        ; if compare was equal to 32, keep going down

SetDefaultBackground:
  LDA #LOW(village1)
  STA currentbglow       ; put the low byte of the address of background into pointer
  LDA #HIGH(village1)
  STA currentbghigh      ; put the high byte of the address into pointer
  PHA                    ; save the high byte bg value 

  JSR LoadBackground
  PLA                    ; restore the high byte bg value 
  STA currentbghigh


  JSR LoadAttribute


ReturnToNMI:
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000

  LDA #%00011110   ; enable sprites
  STA $2001

Forever:
  LDA mainloop
  CMP #$01
  BEQ MainLoopSubroutines
  JMP Forever     ; jump back to Forever, infinite loop

