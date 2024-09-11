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
 	CMP #$04
 	BEQ AnimateServerRoom
 	CMP #$06
 	BEQ AnimateGhostRoom1
 	CMP #$07
 	BEQ AnimateGhostRoom2
 	CMP #$08
 	BEQ AnimatePark
 	CMP #$0A
 	BEQ AnimateEnd
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
AnimateServerRoom:
	JSR AnimateServerRoomSubroutine
	RTS
AnimateGhostRoom1:
	JSR AnimateGhostRoom1Subroutine
	RTS
AnimateGhostRoom2:
	JSR AnimateGhostRoom2Subroutine
	RTS
AnimatePark:
	JSR AnimateParkSubroutine
	RTS
AnimateEnd:
	JSR AnimateEndSubroutine
	RTS

AnimateVillage1Subroutine:
	LDA #$00
  STA walkbackwards ; fix for very silly bug with ghost moving backwards when a cat moves backwards
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
	LDA #$44          ; compare pointer to this number via transform loop
	STA trnsfrmcompare
	LDX #$34          ; ghost tiles are stored at address 0200 + this number
	JSR ObjectTransformNoCache
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
	JSR ObjectTransformNoCache
 	RTS
AnimateCandles:
	LDA #$01
	STA objectframenum
	LDA #$0B
	STA switchtile
	JSR ObjectTransformNoCache
	RTS

AnimateVillage2Subroutine:
	LDA #$06          ; switch tiles via transform loop
	STA trnsfrm
	LDX #$46
	LDA #$DE
	STA trnsfrmcompare
	LDA objectframenum
	BEQ AnimateRiver
	LDA #$00
	STA objectframenum
	STA switchtile
	JSR ObjectTransformNoCache
	LDX #$3A          ; also animate festoon here
	LDA #$46
	STA trnsfrmcompare
	LDA #$01
	STA switchtile
	JSR ObjectTransformNoCache
	INC $02F4        ; animate ghost guard
 	RTS
AnimateRiver:
	LDA #$01
	STA objectframenum
	LDA #$80
	STA switchtile
	JSR ObjectTransformNoCache
AnimateFestoon:
	LDX #$3A
	LDA #$46
	STA trnsfrmcompare
	LDA #$00
	STA switchtile
	JSR ObjectTransformNoCache
	DEC $02F4        ; animate ghost guard
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
	LDA #$85
	STA $02C5
	LDA #$84
	STA $02C9
	RTS

SkeletonShakesHands2:
	LDA #$84
	STA $02C5
	LDA #$85
	STA $02C9
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

AnimateServerRoomSubroutine:
	LDA #$06          ; switch tiles via transform loop
	STA trnsfrm
	LDA objectframenum
	BEQ AnimateDiodes
	LDA #$00
	STA objectframenum
	LDA #$4A
	STA switchtile
	LDX #$79
	LDA #$81
	STA trnsfrmcompare
	JSR ObjectTransformNoCache
	LDA #$FF
	STA switchtile
	LDX #$81
	LDA #$89
	STA trnsfrmcompare
	JSR ObjectTransformNoCache
 	RTS
AnimateDiodes:
	LDA #$01
	STA objectframenum
	LDA #$FF
	STA switchtile
	LDX #$79
	LDA #$81
	STA trnsfrmcompare
	JSR ObjectTransformNoCache
	LDA #$4A
	STA switchtile
	LDX #$81
	LDA #$89
	STA trnsfrmcompare
	JSR ObjectTransformNoCache
	RTS

AnimateGhostRoom1Subroutine:
	LDA objectframenum
	BEQ MoveOfficeGhostDown
MoveOfficeGhostUp:
	LDA #$00
	STA objectframenum
	STA trnsfrm       ; decrement via transform loop
 	JMP MoveOfficeGhost
MoveOfficeGhostDown:
	LDA #$01
	STA objectframenum
	STA trnsfrm       ; increment via transform loop
MoveOfficeGhost:
	LDA #$74          ; compare pointer to this number via transform loop
	STA trnsfrmcompare
	LDX #$54          ; ghost tiles are stored at address 0200 + this number
	JSR ObjectTransformNoCache
	RTS

AnimateGhostRoom2Subroutine:
	LDA objectframenum
	BEQ AnimateGhostsFrame0 ; when equals 0
	CMP #$01
 	BEQ AnimateGhostsFrame1
 	CMP #$02
 	BEQ AnimateGhostsFrame2
AnimateGhostsFrame3:
	LDA #$00
	STA objectframenum
	JSR Ghost1MovesDown
	JSR Ghost2MovesUp
	RTS
AnimateGhostsFrame0:
	INC objectframenum
	JSR Ghost1MovesUp
	JSR Ghost2MovesDown
	JSR BigGhostMovesUp
	RTS
AnimateGhostsFrame1:
	INC objectframenum
	JSR Ghost1MovesDown
	JSR Ghost2MovesUp
	RTS
AnimateGhostsFrame2:
	INC objectframenum
	JSR Ghost1MovesUp
	JSR Ghost2MovesDown
	JSR BigGhostMovesDown
	RTS

Ghost1MovesUp:
	LDA #$00
	STA trnsfrm       ; decrement via transform loop
	JSR Ghost1Moves
	RTS

Ghost1MovesDown:
	LDA #$01
	STA trnsfrm       ; increment via transform loop
	JSR Ghost1Moves
	RTS

Ghost2MovesUp:
	LDA #$00
	STA trnsfrm       ; decrement via transform loop
	JSR Ghost2Moves
	RTS

Ghost2MovesDown:
	LDA #$01
	STA trnsfrm       ; increment via transform loop
	JSR Ghost2Moves
	RTS

BigGhostMovesUp:
	LDA #$00
	STA trnsfrm       ; decrement via transform loop
	JSR BigGhostMoves
	RTS

BigGhostMovesDown:
	LDA #$01
	STA trnsfrm       ; increment via transform loop
	JSR BigGhostMoves
	RTS

Ghost1Moves:
	LDA #$3C          ; compare pointer to this number via transform loop
	STA trnsfrmcompare
	LDX #$2C          ; ghost tiles are stored at address 0200 + this number
	JSR ObjectTransformNoCache
	RTS

Ghost2Moves:
	LDA #$4C          ; compare pointer to this number via transform loop
	STA trnsfrmcompare
	LDX #$3C          ; ghost tiles are stored at address 0200 + this number
	JSR ObjectTransformNoCache
	RTS

BigGhostMoves:
	LDA #$2C          ; compare pointer to this number via transform loop
	STA trnsfrmcompare
	LDA switches
	AND #%00000001
	BNE BigGhostTilesWithoutCandy
	LDX #$18          ; ghost tiles are stored at address 0200 + this number
TransformBigGhost:
	JSR ObjectTransformNoCache
	RTS

BigGhostTilesWithoutCandy:
	LDX #$1C
	JMP TransformBigGhost

AnimateEndSubroutine:
	; TODO: might wanna make this animation faster
	LDA objectframenum
	BEQ AnimateCatSkating
	DEC objectframenum
	LDA #$F5
	STA $0209
	RTS
AnimateCatSkating:
	INC objectframenum
	LDA #$E4
	STA $0209
	RTS

AnimateParkSubroutine:
	LDA #$00
	STA trnsfrm       ; decrement via transform loop
	LDA #$73          ; compare pointer to this number via transform loop
	STA trnsfrmcompare
	LDX #$43          ; cloud tiles are stored at address 0200 + this number
	JSR ObjectTransformNoCache
	RTS
