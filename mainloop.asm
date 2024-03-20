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
  JSR LoadBackground
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

ClearBG:
  JSR DisableNMIRendering
  JSR InitializeLoadBackground
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
