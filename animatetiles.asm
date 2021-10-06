CheckAnimateTiles:
	LDA animatecounter
  CMP #$00
  BEQ AnimateTiles   ; animate only when counter = 0
  DEC animatecounter ; if not 0, decrement counter
  RTS

AnimateTiles:
	LDA #OBJECTSANIMATIONSPEED ; renew the counter
  STA animatecounter
  LDA location
  CMP #$00
 	BEQ AnimateVillage1
 	LDA location
  CMP #$01
 	BEQ AnimateCatHouse
 	RTS

AnimateVillage1:
	LDA objectframenum
	CMP #$00
	BEQ MoveGhostDown
MoveGhostUp:
	LDA #$00
	STA objectframenum
	LDA #$00          ; decrement via transform loop
  STA trnsfrm
 	JMP MoveGhost
MoveGhostDown:
	LDA #$01
	STA objectframenum
	LDA #$01          ; increment via transform loop
  STA trnsfrm
MoveGhost:
	LDA #$48          ; compare pointer to $48 via transform loop
  STA trnsfrmcompare
  LDX #$38          ; ghost tiles are stored at address 0200 + this number
  JSR ObjectTransformLoop
  RTS

AnimateCatHouse:
	LDA objectframenum
	CMP #$00
	BEQ AnimateCandles
	LDA #$00
	STA objectframenum
	LDA #$0C
  STA $0219
  STA $021D
 	RTS
AnimateCandles:
	LDA #$01
	STA objectframenum
	LDA #$0B
	STA $0219
  STA $021D
	RTS