NMI:
  LDA #$00
  STA $2003       ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014       ; set the high byte (02) of the RAM address, start the transfer

  LDA nmiwaitcounter
  BEQ NMISubroutines
  DEC nmiwaitcounter
  JMP EndOfNMI

NMISubroutines:
    ;;This is the PPU clean up section, so rendering the next frame starts properly.
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000
  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA $2001

  JSR DrawCatFromCache

  JSR DrawDots

  JSR ReadController

  JSR CheckActionNMI

  JSR CheckAnimateTiles

EndOfNMI:
  LDA #$00
  sta sleeping    ; wake up the main program
  STA $2005       ; tell the ppu there is no background scrolling
  STA $2005
  RTI             ; return from interrupt
