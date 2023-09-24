NonTextEvents:
	LDA eventnumber
	BEQ NonTextEventsDone ; if zero, then there is no event
	CMP #$01
	BEQ CandymanHand
	CMP #$40
	BEQ OldLadyWalk
	CMP #$41
	BEQ OldLadyAppear
	CMP #$42
	BEQ OldLadyDisappear
NonTextEventsDone:
	LDA #$00
  STA action
	RTS

CandymanHand:
	JSR CandymanHandSubroutine
	RTS

OldLadyWalk:
	JSR OldLadyWalkSubroutine
	RTS

OldLadyAppear:
	JSR OldLadyAppearSubroutine
	RTS

OldLadyDisappear:
	JSR OldLadyDisappearSubroutine
	RTS

CandymanHandSubroutine:
	INC candycounter
	LDA #$34         ; tear off hand
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

OldLadyWalkSubroutine:
	LDA walkcounter
	BEQ OldLadyWalkSubroutineDone
	LDA #$01
  STA walkbackwards
	DEC walkcounter
	LDA #MVUP
	STA buttons
	RTS
OldLadyWalkSubroutineDone:
	LDA #$00
  STA walkbackwards
	LDA #$05
  STA action
	LDA #$41
	STA eventnumber
	RTS

OldLadyAppearSubroutine:
	INC candycounter
	LDA #$FF
	STA $0245
	LDA #LOW(oldlady)
  STA curntspriteslow
  LDA #HIGH(oldlady)
  STA curntspriteshigh
  LDA #$24
  STA spritescompare
  LDA #$48
  STA ramspriteslow  ; load into ram starting from this address
  JSR LoadSprites
  LDA #LOW(oldladytalk)
  STA currenttextlow
  LDA #HIGH(oldladytalk)
  STA currenttexthigh
  LDA #$01
  STA textpartscounter
  LDA #$42
	STA eventnumber
  LDA #$01
  STA action
	RTS

OldLadyDisappearSubroutine:
	LDA #$67
	STA $0245
	LDA #$06          ; switch tiles via transform loop
	STA trnsfrm
	LDX #$48
	LDA #$6C
	STA trnsfrmcompare
	LDA #$FF
	STA switchtile
	JSR ObjectTransformLoop
	LDA #LOW(candy_left)
  STA currenttextlow
  LDA #HIGH(candy_left)
  STA currenttexthigh
	LDA #$01
  STA action
  LDA #$18
  STA ramspriteslow  ; return default ppu pointer position
	JSR PerformNonTextEventDone
	RTS


PerformNonTextEventDone: ; might need to set one more event after the next text part, so this code should be optional
	LDA #$00
	STA eventnumber
	RTS
