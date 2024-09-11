BgScroll:
	LDA location
	CMP #$0A        ; perform horizontal scroll for the end screen
	BNE SkipScroll
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
