BgRenderSubroutine:
	LDA bgrender
	CMP #$01
	BEQ ActivateChangeLocationSequence
  CMP #$02
  BEQ LoadBackgroundForLocation
  CMP #$03
  BEQ LoadSpritesForLocation
  CMP #$04
  BEQ ReloadLocation ; after the glitch event
  RTS

EndBgRenderSubroutine:
	LDA #$00
	STA bgrender
  RTS

ActivateChangeLocationSequence:
  ; via the same frame, set the needed status + disable NMI
  LDA #$02
  STA bgrender
  JSR DisableNMIRendering
  RTS

LoadBackgroundForLocation:
  ; frame 1, load background and background attributes
  LDA #$03
  STA bgrender
  JSR LoadBackground
  JSR LoadAttribute
  RTS

LoadSpritesForLocation:
  ; frame 2, load sprites + do some more things
  JSR ChangeCatCoordinates
  JSR DrawCatFromCache
  JSR LoadSprites
  JSR AdditionalRender
  LDA #OBJECTSANIMATIONSPEED ; renew the animation counter
  STA animatecounter
  JMP EndBgRenderSubroutine

ReloadLocation:
  JSR DisableNMIRendering
  JSR ClearBG
  JSR LoadAttribute
  JSR LoadPalettes
  JMP EndBgRenderSubroutine

ClearBG:
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
  LDA #$18          ; compare pointer to this number via transform loop
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
  JSR SetPPUAddrSubroutine
  LDA #$FF              ; add empty tile behind the plant
  STA $2007
  LDX #$22
  LDY #$4F
  JSR SetPPUAddrSubroutine
  LDA #$97              ; remove exit
  STA $2007
  STA $2007
  RTS

SetPPUAddrSubroutine:
  ; high byte in X, low byte in Y
  LDA $2002             ; read PPU status to reset the high/low latch
  TXA
  STA $2006             ; write the high byte of $224F address
  TYA
  STA $2006             ; write the low byte of $224F address
  RTS
