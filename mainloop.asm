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
  ; CRITICAL!
  ; TODO: Divide into smaller parts
  JSR DisableNMIRendering
  JSR LoadBackground
  JSR LoadAttribute
  JSR ChangeCatCoordinates
  JSR LoadSprites
  JSR AdditionalRender
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

AdditionalRender:
  LDA location
  CMP #$06
  BEQ GhostRoom1AdditionalRender
  RTS

GhostRoom1AdditionalRender:
  LDX #$21
  LDY #$34
  JSR AdditionalRenderSetPPUAddr
  LDA #$FF              ; add empty tile behind the plant
  STA $2007
  LDX #$22
  LDY #$4F
  JSR AdditionalRenderSetPPUAddr
  LDA #$97              ; remove exit
  STA $2007
  STA $2007
  RTS

AdditionalRenderSetPPUAddr:
  ; high byte in X, low byte in Y
  LDA $2002             ; read PPU status to reset the high/low latch
  TXA
  STA $2006             ; write the high byte of $224F address
  TYA
  STA $2006             ; write the low byte of $224F address
  RTS
