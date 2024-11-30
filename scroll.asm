BgScroll:
	LDA location
	CMP #$0A        ; perform horizontal scroll for the end screen
	BEQ EndScreenScroll
	LDA shakescreen
	BEQ SkipScroll
	CMP #$01
	BEQ MoveScreenLeft
MoveScreenRight:
	LDA #$01
	STA shakescreen
	JMP BgScrollSetValues
EndScreenScroll:
	INC bgscrollposition
  INC bgscrollposition
  LDA bgscrollposition
BgScrollSetValues:
  STA $2005       ; store the needed value for horizontal scroll
  LDA #$00
  STA $2005
  STA sleeping    ; wake up the main program
  RTS

SkipScroll:
	LDA #$00
	JMP BgScrollSetValues

MoveScreenLeft:
	LDA #$FF
	STA shakescreen
	JMP BgScrollSetValues