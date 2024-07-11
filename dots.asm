CheckActionDots:
	; dots can be active only when action state is 0 and no buttons are pressed
	LDA action
	BNE DotsInactive
	LDA buttons
	BNE DotsInactive
	JSR CheckActionTile
	LDA dotsstate
	CMP #$40            ; TODO: change to constant, add different values for PAL/NTSC
	BEQ RenewDotsState
	RTS
DotsInactive:
	LDA dotsstate
	STA olddotsstate    ; need to know if the state was already zero so that we don't need to clear dots each frame
	LDA #$00
	STA dotsstate
	RTS

RenewDotsState:
	LDA #$01
	STA dotsstate
	RTS

DrawDots:
	LDA dotsstate
	BEQ CheckOldDotsState
	CMP #$30               ; if dotsstate => this value, clear dots
	BCS ClearDots
	CMP #$01
	BEQ DrawOneDot
	CMP #$10
	BEQ DrawOneDot
	CMP #$20
	BEQ DrawOneDot
	RTS

DrawOneDot:
  LDA dotsstate
  STA dotsframe
  LDX #$04
DivideDotsStateLoop: ; divide 4 times to get the needed pointer to add to text ppu address
	LSR dotsframe
	DEX
	BNE DivideDotsStateLoop
  LDX #HIGH(INITIALTEXTPPUADDR)
  LDY #LOW(INITIALTEXTPPUADDR)
  INY
  TYA
  CLC
  ADC dotsframe
  TAY
	JSR SetPPUAddrSubroutine
	LDA #$54
  STA $2007
	RTS

CheckOldDotsState:
	; if olddotsstate between 1 and n, jump to ClearDots
	LDA olddotsstate
	BEQ CheckOldDotsStateDone
	CMP #$30
	BCC ClearDots
CheckOldDotsStateDone:
	RTS

ClearDots:
	LDX #HIGH(INITIALTEXTPPUADDR)
  LDY #LOW(INITIALTEXTPPUADDR)
  INY
	JSR SetPPUAddrSubroutine
	LDA #$FF
  STA $2007  ; clear three tiles in a row
  STA $2007
  STA $2007
	RTS
