RenderText:
  JSR SetTextCursor       ; each piece of text begins with cursor that should be defined for it, define it if textpointer is zero
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
RenderTextCursor:
  LDA textcursor
  STA $2007
  RTS
RenderTextDone:
  JSR CalculateCurrentTextAddress
  LDA #$00
  STA textpointer
  LDA #$02
  STA action
  RTS

SetTextCursor:
  LDA textpointer
  BNE SetTextCursorDone
  LDY textpointer
  LDA [currenttextlow], y
  STA textcursor
  INC textpointer
SetTextCursorDone:
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
  LDA textpartscounter  ; don't define the next starting address for text if all text parts are rendered
  BEQ CalculateCurrentTextAddressDone
  INC textpointer
  LDA currenttextlow
  CLC
  ADC textpointer
  STA currenttextlow
  LDA currenttexthigh
  ADC #$00              ; add 0 and carry from previous add
  STA currenttexthigh
CalculateCurrentTextAddressDone:
  RTS
