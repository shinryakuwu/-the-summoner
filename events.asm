NonTextEvents:
	LDA eventnumber
	BEQ NonTextEventsDone ; if zero, then there is no event
	CMP #$01
	BEQ CandymanHand
	CMP #$02
	BEQ SatanGlitch
	CMP #$03
	BEQ Office
	CMP #$40
	BEQ OldLady
	CMP #$41
	BEQ Office
	; cmp...
	CMP #$43
	BEQ SatanWalk
NonTextEventsDone:
	LDA #$00
  STA action
	RTS

CandymanHand:
	JSR CandymanHandSubroutine
	RTS

OldLady:
	JSR OldLadySubroutine
	RTS

Office:
	JSR OfficeSubroutine
	RTS

SatanWalk:
	JSR SatanWalkSubroutine
	RTS

SatanGlitch:
	JSR SatanGlitchSubroutine
	RTS

CandymanHandSubroutine:
	INC candycounter
	LDA #$34         ; tear off hand
	STA $0221
	LDA #LOW(hand_acquired)
  STA currenttextlow
  LDA #HIGH(hand_acquired)
  STA currenttexthigh
  LDA #$01
  STA textpartscounter
  STA action
	JSR PerformNonTextEventDone
	RTS

OldLadySubroutine:
	LDA eventstate
	BEQ OldLadyWalk
	CMP #$01
	BEQ OldLadyAppear
	CMP #$02
	BEQ OldLadyDisappear
	RTS

OldLadyWalk:
	LDA walkcounter
	BEQ OldLadyWalkDone
	LDA #$01
  STA walkbackwards
	DEC walkcounter
	LDA #MVUP
	STA buttons
	RTS
OldLadyWalkDone:
	LDA #$00
  STA walkbackwards
	LDA #$05
  STA action
	LDA #$01
	STA eventstate
	RTS

OldLadyAppear:
	INC candycounter
	LDA #$FF
	STA $0245
	LDA #LOW(oldlady)
  STA curntspriteslow
  LDA #HIGH(oldlady)
  STA curntspriteshigh
  LDA #$24
  STA spritescompare
  LDA #$48
  STA ramspriteslow  ; load into ram starting from this address
  JSR LoadSprites
  LDA #LOW(oldladytalk)
  STA currenttextlow
  LDA #HIGH(oldladytalk)
  STA currenttexthigh
  LDA #$01
  STA textpartscounter
	LDA #$02
	STA eventstate
  LDA #$01
  STA action
	RTS

OldLadyDisappear:
	LDA #$67
	STA $0245
	LDA #$06          ; switch tiles via transform loop
	STA trnsfrm
	LDX #$48
	LDA #$6C
	STA trnsfrmcompare
	LDA #$FF
	STA switchtile
	JSR ObjectTransformLoop
	LDA #LOW(candy_left)
  STA currenttextlow
  LDA #HIGH(candy_left)
  STA currenttexthigh
	LDA #$01
  STA action
  LDA #$18
  STA ramspriteslow  ; return default ppu pointer position
  LDA #$00
	STA eventstate
	JSR PerformNonTextEventDone
	RTS

SatanWalkSubroutine:
	LDA walkcounter
	BEQ SatanWalkSubroutineDone
	DEC walkcounter
	LDA #MVUP
	STA buttons
	RTS
SatanWalkSubroutineDone:
	LDA #$01
  STA action
  LDA #LOW(satan_appear)
  STA currenttextlow
  LDA #HIGH(satan_appear)
  STA currenttexthigh
  LDA #$02
  STA textpartscounter
	STA eventnumber
	LDA #$21           ; TODO: cat puts down his bag
	STA $0211
	RTS

SatanGlitchSubroutine:
	LDA eventstate
	BEQ SatanGlitchInitiate
	CMP #$16
	BEQ EndGlitch      ; branch depends on whether the state number is even/odd
	AND #%00000001
	BNE LoadGlitchText ; odd
	JSR RenderSatan    ; even
	RTS

EndGlitch:
	LDA #$01
	STA action
  STA mainloop
  STA textpartscounter
  LDA #$02
  STA bgrender        ; activate background rendering and perform it via main loop (outside of NMI)
  LDA #$80            ; TODO: add different values for PAL/NTSC
  STA nmiwaitcounter  ; skip nmi subroutines in the first 32 frames after bg is changed
  STA eventwaitcounter
  LDA #LOW(satan_talk)
  STA currenttextlow
  LDA #HIGH(satan_talk)
  STA currenttexthigh
  LDA #$00
  STA eventstate
	JSR PerformNonTextEventDone
	LDA #$18
  STA ramspriteslow  ; return default ppu pointer position
  LDA #$02
  STA ramspriteshigh
	RTS

LoadGlitchText:
	JSR LoadGlitchTextSubroutine
	RTS

SatanGlitchInitiate:
	LDA #$01
	STA eventstate
	STA glitchcount
	LDA #LOW(satan)
  STA curntspriteslow
  LDA #HIGH(satan)
  STA curntspriteshigh
	LDA #$00
	STA textppuaddrlow
	LDA #$20
	STA textppuaddrhigh
	LDA #$05
  STA location
	RTS

RenderSatan:
	LDA eventstate
	CMP #$02
	BEQ GlitchClearSprites ; should clear sprites first because there would be no place in memory for all the objects
ProceedSatanRender:
	LDA eventstate         ; use eventstate / 2 as poiner
	LSR A
	TAY
	LDA satantilesperline, y
  STA spritescompare
  LDY #$00
RenderSatanLoop:
  LDA [curntspriteslow], y
  STA [ramspriteslow], y
  INY
  CPY spritescompare
  BNE RenderSatanLoop
  ; TODO: refactor, maybe add a separate subroutine for 16-bit adding
  LDA curntspriteslow   ; add spritescompare to curntsprites and ramsprites
  CLC
  ADC spritescompare
  STA curntspriteslow
  LDA curntspriteshigh
  ADC #$00              ; add 0 and carry from previous add
  STA curntspriteshigh
  LDA ramspriteslow
  CLC
  ADC spritescompare
  STA ramspriteslow
  LDA ramspriteshigh
  ADC #$00              ; add 0 and carry from previous add
  STA ramspriteshigh

	INC eventstate
	RTS

GlitchClearSprites:
	LDY #$00
	JSR ClearSpritesLoop
	JMP ProceedSatanRender
	RTS

LoadGlitchTextSubroutine:
	LDA glitchcount
	CMP #$20 ; TODO: move to constant 'glitch delay'
	BEQ LoadGlitchTextDone
  LDA $2002               ; read PPU status to reset the high/low latch
  LDA textppuaddrhigh
  STA $2006               ; write the high byte of text ppu address
  LDA textppuaddrlow
  STA $2006               ; write the low byte of text ppu address

	LDA #LOW(satan_appear)
  STA currenttextlow
  LDA #HIGH(satan_appear)
  STA currenttexthigh
  LDY #$00
LoadGlitchTextLoop:
  LDA [currenttextlow], y ; load data from address
  STA $2007               ; write to PPU
  INY
  ; TODO: add different values for PAL/NTSC
  CPY #$FF
  BNE LoadGlitchTextLoop
  INC glitchcount
  LDA textppuaddrlow
  CLC
  ; TODO: add different values for PAL/NTSC (equals to value above)
  ADC #$FF
  STA textppuaddrlow    ; save current ppu address for the next frame
  LDA textppuaddrhigh
  ADC #$00              ; add 0 and carry from previous add
  STA textppuaddrhigh
  RTS
LoadGlitchTextDone:
  INC eventstate
  LDA #$00
  STA glitchcount
	RTS

OfficeSubroutine:
	LDA eventstate
	BEQ OfficeTeleport
	CMP #$01
	BEQ OfficeLookUp
	CMP #$02
	BEQ OfficeGhostMovesLeft
	CMP #$03
	BEQ OfficeCatMovesLeft
	CMP #$04
	BEQ OfficeCatMovesRight
	CMP #$05
	BEQ OfficeCatMovesDown
	CMP #$06
	BEQ OfficeGhostMovesRight
	CMP #$07
	BEQ ParkTeleport
	RTS

ParkTeleport:
	JSR ParkTeleportSubroutine
	RTS

OfficeTeleport:
	JSR ParkGhostRoom1Warp
	LDA #MVDOWN
	STA buttons
	LDA #$40
	STA eventwaitcounter
	LDA #$01
	STA eventstate
	RTS

OfficeLookUp:
	LDA #MVUP
	STA buttons
	LDA #LOW(office_ghost)
  STA currenttextlow
  LDA #HIGH(office_ghost)
  STA currenttexthigh
  LDA #$06
  STA textpartscounter
  LDA #$01
  STA action
  LDA #$02
	STA eventstate
	LDA #$03
	STA eventnumber
	RTS

OfficeGhostMovesLeft:
	LDA #$00
	STA trnsfrm             ; decrement via transform loop
	JSR OfficeGhostMoves
	LDA #$60
	STA eventwaitcounter
	LDA #$03
	STA eventstate
	LDA #$41
	STA eventnumber
	RTS

OfficeCatMovesLeft:
	LDX #MVLEFT
	JSR OfficeCatMoves
	LDA #$04
	STA eventstate
	RTS

OfficeCatMovesRight:
	LDX #MVRIGHT
	JSR OfficeCatMoves
	LDA #$05
	STA eventstate
	RTS

OfficeCatMovesDown:
	LDX #MVDOWN
	JSR OfficeCatMoves
	LDA #$06
	STA eventstate
	RTS

OfficeGhostMovesRight:
	LDA #$01
	STA trnsfrm             ; increment via transform loop
	JSR OfficeGhostMoves
	LDA #MVUP
	STA buttons
	LDA #LOW(office_ghost2)
  STA currenttextlow
  LDA #HIGH(office_ghost2)
  STA currenttexthigh
  LDA #$09
  STA textpartscounter
  LDA #$01
  STA action
  LDA #$07
	STA eventstate
	LDA #$03
	STA eventnumber
	RTS

OfficeGhostMoves:
	LDA #$6F                ; compare pointer to $6F via transform loop
	STA trnsfrmcompare
	LDY #$00
OfficeGhostMovesLoop:
	LDX #$57                ; ghost tiles are stored at address 0200 + this number
	JSR ObjectTransformLoop
	INY
	CPY #$04
	BNE OfficeGhostMovesLoop
	RTS

OfficeCatMoves:
	TXA
	STA buttons
	LDA #$60
	STA eventwaitcounter
	RTS

ParkTeleportSubroutine:
	JSR GhostRoom1ParkWarp
  LDA #LOW(nightmare)
  STA currenttextlow
  LDA #HIGH(nightmare)
  STA currenttexthigh
  LDA #$01
  STA action
  LDA #$00
	STA eventstate
  JSR PerformNonTextEventDone
  LDA #MVLEFT
	STA buttons
  ; TODO: add different values for PAL/NTSC
  LDA #DELAYAFTERGHOSTROOM1
  STA nmiwaitcounter
	RTS

PerformNonTextEventDone: ; might need to set one more event after the next text part, so this code should be optional
	LDA #$00
	STA eventnumber
	RTS
