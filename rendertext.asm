RenderText:
  ; LDY textpointer
  ; CPY textcompare
  ; BEQ RenderTextDone

  JSR CalculateTextPPUAddress
  LDA $2002               ; read PPU status to reset the high/low latch
  LDA textppuaddrhigh
  STA $2006               ; write the high byte of text ppu address
  LDA textppuaddrlow
  STA $2006               ; write the low byte of text ppu address

LoadTextIntoPPU:
  LDY textpointer
  LDA [currenttextlow], y ; load data from address
  CMP #ENDOFTEXT          ; if current symbol is ENDOFTEXT, the part of the text finished rendering
  BEQ RenderTextDone
  STA $2007               ; write to PPU
  INC textpointer
  CMP #$FF                ; if current symbol is a whitespace, render next symbol within the same frame
  BEQ LoadTextIntoPPU
  JSR RenderTextCursor
  RTS
RenderTextDone:
  JSR RenderTextCursor
  JSR CalculateCurrentTextAddress ; add condition only if textparts?
  LDA #$00
  STA textpointer
  LDA #$02
  STA action
  RTS

RenderTextCursor:
  LDA #$85   ; should be a variable later
  STA $2007
  RTS

CalculateTextPPUAddress:
  LDA textpointer
  CLC
  ADC #LOW(INITIALTEXTPPUADDR)
  STA textppuaddrlow
  LDA #HIGH(INITIALTEXTPPUADDR)
  ADC #$00              ; add 0 and carry from previous add
  STA textppuaddrhigh
  RTS

CalculateCurrentTextAddress:
  LDA textpointer
  CLC
  ADC #LOW(INITIALTEXTPPUADDR)
  STA currenttextlow
  LDA #HIGH(INITIALTEXTPPUADDR)
  ADC #$00              ; add 0 and carry from previous add
  STA currenttexthigh
  RTS

; possible solution - 'textpartscounter' with number of text parts, set at 'check action', decrement each time
; done when reaches zero