CheckActionDots:
	; dots can be active only when action state is 0 and no buttons are pressed
	LDA action
	BNE DotsInactive
	LDA buttons
	BNE DotsInactive
	LDA #$00
	STA dotsstate       ; inactive by default but will be redefined via CheckActionTile in case current tile contains event
	JSR CheckActionTile
	LDA dotsstate
	BEQ DotsInactive
	INC dotscounter
	LDA dotscounter
	CMP #DELAYACTIONDOTS
	BEQ RenewDotsCounter
	JMP DefineCurrentDotsFrame
DotsInactive:
	LDA #$00
	STA dotscounter
	JMP DefineCurrentDotsFrame

RenewDotsCounter:
	LDA #$01
	STA dotscounter

DefineCurrentDotsFrame:
	LDA dotscounter
	BEQ SetDotsFrameToZero
	CMP #$30               ; if dotscounter => this value
	BCS SetDotsFrameToZero
	CMP #$01
	BEQ SetDotsFrameToOne
	CMP #$10
	BEQ SetDotsFrameToTwo
	CMP #$20
	BEQ SetDotsFrameToThree
	RTS

SetDotsFrameToZero:
	JSR StorePreviousDotsFrame
	LDA #$00
	STA dotsframe
	RTS
SetDotsFrameToOne:
	JSR StorePreviousDotsFrame
	LDA #$01
	STA dotsframe
	RTS
SetDotsFrameToTwo:
	JSR StorePreviousDotsFrame
	LDA #$02
	STA dotsframe
	RTS
SetDotsFrameToThree:
	JSR StorePreviousDotsFrame
	LDA #$03
	STA dotsframe
	RTS

StorePreviousDotsFrame:
	LDA dotsframe
	STA olddotsframe  ; store the previous frame value so that we don't need to update dots graphics each frame
	RTS


DrawDots:
	LDA dotsframe
	CMP olddotsframe
	BEQ SkipDrawDots
	CMP #$00
	BEQ ClearDots
	JMP DrawOneDot
SkipDrawDots:
	RTS

DrawOneDot:
  LDX #HIGH(INITIALTEXTPPUADDR)
  LDA #LOW(INITIALTEXTPPUADDR)
  CLC
  ADC dotsframe  ; use dotsframe value as a pointer to add to text ppu address
  TAY
	JSR SetPPUAddrSubroutine
	LDA #$54
  STA $2007
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
