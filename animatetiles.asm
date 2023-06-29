CheckAnimateTiles:
	LDA animatecounter
	BEQ AnimateTiles   ; animate only when counter = 0
	DEC animatecounter ; if not 0, decrement counter
	LDA location
	CMP #$03
	BEQ SkeletonDanceCheck ; separate logic for dancing skeletons animation, I hope it's worth it...
	RTS

SkeletonDanceCheck:
	LDA animatecounter ; animate when counter = 9 or 18
	CMP #$06
	BEQ SkeletonDance
	CMP #$12
	BEQ SkeletonDance
	RTS
SkeletonDance:
	JSR SkeletonDanceSubroutine
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
 	CMP #$03
 	BEQ AnimateSkeletonHouse
 	RTS

AnimateVillage1:
	JSR AnimateVillage1Subroutine
	RTS
AnimateCatHouse:
	JSR AnimateCatHouseSubroutine
	RTS
AnimateVillage2:
	JSR AnimateVillage2Subroutine
	RTS
AnimateSkeletonHouse:
	JSR AnimateSkeletonHouseSubroutine
	RTS

AnimateVillage1Subroutine:
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
	STA trnsfrm       ; increment via transform loop
MoveGhost:
	LDA #$48          ; compare pointer to $48 via transform loop
	STA trnsfrmcompare
	LDX #$38          ; ghost tiles are stored at address 0200 + this number
	JSR ObjectTransformLoop
	RTS

AnimateCatHouseSubroutine:
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

AnimateVillage2Subroutine:
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

AnimateSkeletonHouseSubroutine:
	LDA objectframenum
	BEQ AnimateLights
	LDA #$00
	STA objectframenum
	LDX #$AA
	JMP ChangeSkeletonHousePalette
AnimateLights:
	LDA #$01
	STA objectframenum
	LDX #$00
ChangeSkeletonHousePalette:
	LDY #$CB
	JSR SkeletonHouseLoadAttributes
	LDY #$D3
	JSR SkeletonHouseLoadAttributes
	RTS

SkeletonHouseLoadAttributes:
	LDA $2002     ; read PPU status to reset the high/low latch
  LDA #$23
  STA $2006     ; write the high byte of $23CB/$23D3 address
  STY $2006     ; write the low byte of $23CB/$23D3 address             
  STX $2007
  STX $2007     ; load attribute to PPU twice
  RTS

SkeletonDanceSubroutine:
	LDA skeletonframenum
	BEQ AnimateSkeletonsFrame0 ; when equals 0
	CMP #$01
 	BEQ AnimateSkeletonsFrame1
 	CMP #$02
 	BEQ AnimateSkeletonsFrame2
AnimateSkeletonsFrame3:
	LDA #$00
	STA skeletonframenum
	JSR SkeletonShakesHands1
	JSR SkeletonStandsStraight
	RTS
AnimateSkeletonsFrame0:
	INC skeletonframenum
	JSR SkeletonShakesHands2
	JSR SkeletonShakesLeft
	RTS
AnimateSkeletonsFrame1:
	INC skeletonframenum
	JSR SkeletonShakesHands1
	JSR SkeletonStandsStraight
	RTS
AnimateSkeletonsFrame2:
	INC skeletonframenum
	JSR SkeletonShakesHands2
	JSR SkeletonShakesRight
	RTS

SkeletonShakesHands1:
	LDA #$00
	STA $02CE
	LDA #$C0
	STA $02D2
	LDA #$4C
	STA $02D0
	LDA #$4F
	STA $02CC
	RTS

SkeletonShakesHands2:
	LDA #$80
	STA $02CE
	LDA #$40
	STA $02D2
	LDA #$4F
	STA $02D0
	LDA #$4C
	STA $02CC
	RTS

SkeletonStandsStraight:
	LDA #$64
	STA $02A9
	STA $02AD

	LDA #$74
	STA $02B1
	RTS

SkeletonShakesLeft:
	LDA #$83
	STA $02A9
	LDA #$65
	STA $02AD

	LDA #$75
	STA $02B1
	LDA #$40
	STA $02B2
	RTS

SkeletonShakesRight:
	LDA #$65
	STA $02A9
	LDA #$83
	STA $02AD

	LDA #$75
	STA $02B1
	LDA #$00
	STA $02B2
	RTS