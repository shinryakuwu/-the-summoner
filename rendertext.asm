RenderText:
  LDY textpointer
  CPY textcompare
  BEQ RenderTextDone

  JSR CalculateTextPPUAddress
  LDA $2002               ; read PPU status to reset the high/low latch
  LDA textppuaddrhigh
  STA $2006               ; write the high byte of text ppu address
  LDA textppuaddrlow
  STA $2006               ; write the low byte of text ppu address

LoadTextIntoPPU:
  LDY textpointer
  LDA [currenttextlow], y ; load data from address
  STA $2007               ; write to PPU
  INC textpointer
  CMP #$FF                ; if current symbol is a whitespace, render next symbol within the same frame
  BEQ LoadTextIntoPPU
  LDA #$85                ; render text cursor
  STA $2007
  RTS
RenderTextDone:
  LDA #$00
  STA textpointer
  STA action
  RTS

CalculateTextPPUAddress:
  TYA
  CLC
  ADC #LOW(INITIALTEXTPPUADDR)
  STA textppuaddrlow
  LDA #HIGH(INITIALTEXTPPUADDR)
  ADC #$00              ; add 0 and carry from previous add
  STA textppuaddrhigh
  RTS

; possible solution - 'textpartscounter' with number of text parts, set at 'check action', decrement each time
; done when reaches zero