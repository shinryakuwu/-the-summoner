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
  JSR PerformBgRender
  JSR ChangeCatCoordinates
  JSR LoadSprites
  LDA #OBJECTSANIMATIONSPEED ; renew the animation counter
  STA animatecounter
  JMP ExitMainLoopSubroutines

ReloadLocation:
  JSR PerformBgRender
  JSR LoadPalettes
  JMP ExitMainLoopSubroutines

PerformBgRender:
  LDA #$00
  STA $2001    ; disable rendering
  LDA currentbghigh
  PHA
  JSR LoadBackground
  PLA
  STA currentbghigh
  JSR LoadAttribute
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
