MainLoopSubroutines:
	LDA bgrender
	CMP #$01
	BEQ ChangeLocation
  CMP #$02
  BEQ ReloadLocation ; after the glitch event

ExitMainLoopSubroutines:
	LDA #$00
	STA mainloop
	STA bgrender
  JMP Forever

ChangeLocation:
  JSR DisableNMIRendering
  JSR PerformBgRender
  JSR LoadAttribute
  JSR ChangeCatCoordinates
  JSR LoadSprites
  LDA #OBJECTSANIMATIONSPEED ; renew the animation counter
  STA animatecounter
  JMP ExitMainLoopSubroutines

ReloadLocation:
  JSR DisableNMIRendering
  JSR ClearBG
  JSR LoadAttribute
  JSR LoadPalettes
  JMP ExitMainLoopSubroutines

PerformBgRender:
  LDA currentbghigh
  PHA
  JSR LoadBackground
  PLA
  STA currentbghigh
  RTS

ClearBG:
  JSR DisableNMIRendering
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$20
  STA $2006             ; write the high byte of $2000 address
  LDA #$00
  STA $2006             ; write the low byte of $2000 address
  LDX #$00
ClearBgLoop:
  LDA #$FF
  STA clearbgcompare
  JSR ClearRemainingBG
  INX
  CPX #$03
  BNE ClearBgLoop
  LDA #$C3
  STA clearbgcompare
  JSR ClearRemainingBG
  RTS

DisableNMIRendering:
  LDA #$00
  STA $2001    ; disable rendering
  RTS

ChangeCatCoordinates:
  LDA #$04          ; warp via transform loop
  STA trnsfrm
  LDA #$18          ; compare pointer to $18 via transform loop
  STA trnsfrmcompare
  LDX #$00
  LDY #$00
  JSR ObjectTransformLoop
  RTS
