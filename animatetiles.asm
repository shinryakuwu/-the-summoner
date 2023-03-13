CheckAnimateTiles:
	LDA animatecounter
	BEQ AnimateTiles   ; animate only when counter = 0
	DEC animatecounter ; if not 0, decrement counter
	RTS

AnimateTiles:
	LDA #OBJECTSANIMATIONSPEED ; renew the counter
	STA animatecounter
	LDA location
 	BEQ AnimateVillage1 ; when equals zero
 	CMP #$01
 	BEQ AnimateCatHouse
 	CMP #$02
 	BEQ AnimateVillage2
 	RTS

AnimateVillage1:
	LDA objectframenum
	BEQ MoveGhostDown
MoveGhostUp:
	LDA #$00
	STA objectframenum
	STA trnsfrm       ; decrement via transform loop
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
