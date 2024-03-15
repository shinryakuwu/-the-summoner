NonTextEvents:
	LDA eventnumber
	BEQ NonTextEventsDone ; if zero, then there is no event
	CMP #$01
	BEQ CandymanHand
	CMP #$02
	BEQ SatanGlitch
	CMP #$40
	BEQ OldLadyWalk
	CMP #$41
	BEQ OldLadyAppear
	CMP #$42
	BEQ OldLadyDisappear
	CMP #$43
	BEQ SatanWalk
NonTextEventsDone:
	LDA #$00
  STA action
	RTS

CandymanHand:
	JSR CandymanHandSubroutine
	RTS

OldLadyWalk:
	JSR OldLadyWalkSubroutine
	RTS

OldLadyAppear:
	JSR OldLadyAppearSubroutine
	RTS

OldLadyDisappear:
	JSR OldLadyDisappearSubroutine
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

OldLadyWalkSubroutine:
	LDA walkcounter
	BEQ OldLadyWalkSubroutineDone
	LDA #$01
  STA walkbackwards
	DEC walkcounter
	LDA #MVUP
	STA buttons
	RTS
OldLadyWalkSubroutineDone:
	LDA #$00
  STA walkbackwards
	LDA #$05
  STA action
	LDA #$41
	STA eventnumber
	RTS

OldLadyAppearSubroutine:
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
  LDA #$42
	STA eventnumber
  LDA #$01
  STA action
	RTS

OldLadyDisappearSubroutine:
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
	LDA glitchstate
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
  STA glitchstate
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
	STA glitchstate
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
	LDA glitchstate
	CMP #$02
	BEQ GlitchClearSprites ; should clear sprites first because there would be no place in memory for all the objects
ProceedSatanRender:
	LDA glitchstate        ; use glitchstate / 2 as poiner
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

	INC glitchstate
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
  INC glitchstate
  LDA #$00
  STA glitchcount
	RTS

PerformNonTextEventDone: ; might need to set one more event after the next text part, so this code should be optional
	LDA #$00
	STA eventnumber
	RTS
