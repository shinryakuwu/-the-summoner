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
  CMP #$05
  BEQ DrawEndScreen
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
  JSR LoadSatanBGAttributes
  JSR LoadPalettes
  JMP EndBgRenderSubroutine

DrawEndScreen:
  JSR DisableNMIRendering
  JSR ClearBG
  JSR LoadDeadCat
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

LoadSatanBGAttributes: ; TODO: might need to remove or reconsider this mess
  LDA #$00
  STA singleattribute ; no need to set attributes address because it's already set to village1attributes
  JSR LoadAttribute
  RTS

LoadDeadCat:
  LDA #$00
  STA ramspriteslow
  STA loadcache
  JSR LoadSprites
  LDA #$18
  STA ramspriteslow
  RTS

AdditionalRender:
  LDA location
  CMP #$03
  BEQ SkeletonHouseAdditionalRender
  CMP #$06
  BEQ GhostRoom1AdditionalRender
  CMP #$07
  BEQ GhostRoom2AdditionalRender
  CMP #$08
  BEQ ParkAdditionalRender
  CMP #$09
  BEQ ExHouseAdditionalRender
  CMP #$0A
  BEQ EndAdditionalRender
  RTS

GhostRoom2AdditionalRender:
  LDA candyswitches
  AND #%00001000
  BNE GhostRoom2EraseCandyTile
  RTS

GhostRoom2EraseCandyTile:
  LDA #$00
  STA $0219
  RTS

SkeletonHouseAdditionalRender:
  LDA candyswitches
  AND #%00000010
  BNE RenderTornOffHand
  RTS

RenderTornOffHand:
  LDA #$34
  STA $0221
  RTS

ParkAdditionalRender:
  LDA switches
  AND #%00100000
  BNE ParkAdditionalRenderDone ; when no ghost pass
  LDA switches
  AND #%00010000
  BEQ ParkAdditionalRenderDone ; after getting a hint
  LDA #$03
  STA $0272
  STA $0276
  STA $027A
ParkAdditionalRenderDone:
  RTS

ExHouseAdditionalRender:
  ; add code
  RTS

EndAdditionalRender:
  LDA #LOW(paletteend)
  STA curntpalette
  LDA #HIGH(paletteend)
  STA curntpalette+1
  JSR LoadPalettes
  RTS

GhostRoom1AdditionalRender:
  ; add a plant
  LDX #$20
  LDY #$F4
  JSR SetPPUAddrSubroutine
  LDA #$16
  STA $2007
  LDX #$21
  LDY #$14
  JSR SetPPUAddrSubroutine
  LDA #$17
  STA $2007
  LDX #$21
  LDY #$34
  JSR SetPPUAddrSubroutine
  LDA #$27
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
