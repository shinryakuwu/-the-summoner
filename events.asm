NonTextEvents:
	LDA eventnumber
	BEQ NonTextEventsDone ; if zero, then there is no event
	CMP #$01
	BEQ CandymanHand
NonTextEventsDone:
	LDA #$00
  STA action
	RTS

CandymanHand:
	JSR CandymanHandSubroutine
	; more events here
	RTS

CandymanHandSubroutine:
	INC candycounter
	LDA #$34
	STA $0221
	LDA #LOW(hand_acquired)
  STA currenttextlow
  LDA #HIGH(hand_acquired)
  STA currenttexthigh
  LDA #$01
  STA textpartscounter
  STA action
	JSR PerformNonTextEventDone
	RTS

PerformNonTextEventDone: ; might need to set one more event after the next text part, so this code should be optional
	LDA #$00
	STA eventnumber
	RTS
