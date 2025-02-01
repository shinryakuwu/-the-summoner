RenderText:
  JSR SetTextCursor       ; each piece of text begins with cursor that should be defined for it, define it if textpointer is zero
  JSR TalkBeep
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
  JSR LoadCandyCounter    ; check if line contains candy counter and load it to A if it does
  STA $2007               ; write to PPU
  INC textpointer
  CMP #$FF                ; if current symbol is a whitespace, render next symbol within the same frame
  BEQ LoadTextIntoPPU
RenderTextCursor:
  LDA textcursor
  STA $2007
  RTS
RenderTextDone:
  JSR CalculateCurrentTextAddress ; define from which address to load the text tiles within the next frame (within tiles.asm)
  LDA #$00
  STA textpointer

  LDA location
  CMP #$0B
  BEQ SetDeathScreenStatus
  LDA #$02
  STA action
  RTS

SetDeathScreenStatus:
  LDA #$04
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

LoadCandyCounter:
  CMP #$EF
  BNE LoadCandyCounterDone ; define candy number only if current symbol is #$EF
  LDA candycounter
  CMP #$06
  BEQ ZeroCandyLeft
  LDA #$4F                 ; this number is where '6' symbol is stored
  SEC                      ; subtract from it to get an address of a previous number (from 1 to 5), zero/O is stored at #$3E
  SBC candycounter
LoadCandyCounterDone:
  RTS
ZeroCandyLeft:
  LDA #$3E
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


ClearTextSectionSubroutine:
  LDA #HIGH(INITIALTEXTPPUADDR)
  STA textppuaddrhigh
  LDA #LOW(INITIALTEXTPPUADDR)
  STA textppuaddrlow
  LDX cleartextstate
  BEQ DefineCurrentTextLineDone
DefineCurrentTextLineLoop:
  LDA textppuaddrlow    ; add 32 (length of line) to textppuaddrlow X times
  CLC
  ADC #$20
  STA textppuaddrlow
  LDA textppuaddrhigh
  ADC #$00              ; add 0 and carry from previous add
  STA textppuaddrhigh
  DEX
  BNE DefineCurrentTextLineLoop
DefineCurrentTextLineDone:       ; jump here if cleartextstate is 0
  LDY #$00
  LDA textppuaddrhigh
  STA $2006
  LDA textppuaddrlow
  STA $2006
ClearTextSectionLoop:
  LDA #$FF
  STA $2007
  INY
  CPY #$20
  BNE ClearTextSectionLoop
  LDA cleartextstate
  CMP #$04           ; compare to number of lines needed to clear
  BEQ ClearTextSectionSubroutineDone
  INC cleartextstate
  RTS
ClearTextSectionSubroutineDone:
  LDA #$00
  STA cleartextstate
  LDA #$03
  STA action
  RTS

TalkBeep:
  LDA talkbeepdelay
  BNE TalkBeepDone
  LDA #$09
  JSR sound_load
  LDA #$04
  STA talkbeepdelay
  RTS
TalkBeepDone:
  DEC talkbeepdelay
  RTS
