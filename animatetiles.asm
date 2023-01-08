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
 	CMP #$02
 	BEQ AnimateVillage2
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
	LDA #$06          ; switch tiles via transform loop
  STA trnsfrm
  LDX #$19          ; candles tiles are stored at address 0200 + this number
  LDA #$21
  STA trnsfrmcompare
	LDA objectframenum
	CMP #$00
	BEQ AnimateCandles
	LDA #$00
	STA objectframenum
	LDA #$0C
	STA switchtile
	JSR ObjectTransformLoop
 	RTS
AnimateCandles:
	LDA #$01
	STA objectframenum
	LDA #$0B
	STA switchtile
	JSR ObjectTransformLoop
	RTS

AnimateVillage2:
	LDA #$06          ; switch tiles via transform loop
  STA trnsfrm
  LDX #$49
  LDA #$E9
  STA trnsfrmcompare
	LDA objectframenum
	CMP #$00
	BEQ AnimateRiver
	LDA #$00
	STA objectframenum
	LDA #$1D
	STA switchtile
	JSR ObjectTransformLoop
	LDX #$3E          ; also animate festoon here
	LDA #$4A
  STA trnsfrmcompare
  LDA #$03
	STA switchtile
	JSR ObjectTransformLoop
 	RTS
AnimateRiver:
	LDA #$01
	STA objectframenum
	LDA #$0D
	STA switchtile
	JSR ObjectTransformLoop
AnimateFestoon:
	LDX #$3E
	LDA #$4A
  STA trnsfrmcompare
  LDA #$00
	STA switchtile
	JSR ObjectTransformLoop
	RTS