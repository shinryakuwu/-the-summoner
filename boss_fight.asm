BossWalks:
	LDA dinomvstate
	CMP #$01
	BEQ BossWalksDown
	CMP #$02
	BEQ BossWalksUp
	RTS

BossWalksUp:
	LDA #$00
BossWalksDown:
	; A = 1 at this point if jumped to BossWalksDown
	STA trnsfrm       ; increment or decrement via transform loop based on the condition
ChangeBossCoordinates:
	LDA #$9C          ; compare pointer to this number via transform loop
	STA trnsfrmcompare
	LDX #$38          ; tiles are stored at address 0200 + this number
	JSR ObjectTransformNoCache
CheckAnimateBoss:
	LDA dinomvcounter
  BEQ AnimateBoss      ; animate only when counter = 0
  DEC dinomvcounter    ; if not 0, decrement counter
  RTS
AnimateBoss:
  LDA #BOSSANIMATIONSPEED ; renew the counter
  STA dinomvcounter
  LDA dinomvframe         ; frame number will be reset when reaches $03
  CMP #$03
  BNE RenderBossFrame
  LDA #$FF                ; it's technically setting framenum to zero since the next step is INC
  STA dinomvframe

RenderBossFrame:
  INC dinomvframe         ; increment frame number
  LDA dinomvframe
  BEQ RenderBossDefaultWithSound
  CMP #$01
  BEQ RenderBossLeftUp
  CMP #$02
  BEQ RenderBossDefaultWithSound
  CMP #$03
  BEQ RenderBossRightUp
	RTS

RenderBossDefaultWithSound:
	LDA #$03                 ; sound of boss steps
  JSR sound_load
RenderBossDefault:
	LDA #$6C
  STA ramspriteslow        ; load into ram starting from this address
  LDX #$09
  LDY #$01
RenderBossDefaultLoop:
  LDA gojiraleftleg, y  	 ; load data from address (sprites +  y)
  STA [ramspriteslow], y   ; store into RAM address
  INY                      ; Y = Y + 1
  INY
  INY
  INY
  DEX
  CPX #$00
  BNE RenderBossDefaultLoop
	JMP RenderBossMoveDone

RenderBossLeftUp:
  LDA #$6D
  STA ramspriteslow        ; load into ram starting from this address
  LDX #$00
  LDY #$00
RenderBossLeftUpLoop:
  LDA gojiraleftlegup, x   ; load data from address (sprites +  x)
  STA [ramspriteslow], y   ; store into RAM address
  INY                      ; Y = Y + 1
  INY
  INY
  INY
  INX
  CPX #$04
  BNE RenderBossLeftUpLoop
  JMP RenderBossMoveDone

RenderBossRightUp:
  LDA #$7D
  STA ramspriteslow  ; load into ram starting from this address
  LDX #$00
  LDY #$00
RenderBossRightUpLoop:
  LDA gojirarightlegup, x  ; load data from address (sprites +  x)
  STA [ramspriteslow], y   ; store into RAM address
  INY                      ; Y = Y + 1
  INY
  INY
  INY
  INX
  CPX #$05
  BNE RenderBossRightUpLoop
  ; JMP RenderBossMoveDone

RenderBossMoveDone:
	; TODO: might want to refactor restoring this pointer across the project, no need to do this everytime
	LDA #$18
  STA ramspriteslow  ; restore default ppu pointer position
	RTS

BossStops:
	LDA #$00
	STA dinomvcounter
  STA dinomvframe
  STA dinomvstate
  JSR RenderBossDefault
	RTS

BossJumps:
	LDA dinojumpstate
	BEQ BossJumpsInit
	CMP #$01
	BEQ BossAscends
	CMP #$02
	BEQ BossInAir
	CMP #$03
	BEQ BossDescends
	CMP #$04
	BEQ BossLanded
	; change some boss fight state to define where jumping should stop
	RTS


BossJumpsInit:
	; change everything to jumpstate and db. of acceleration ending with $FF or so.
	; falling might be backwards for jumping
	JSR RenderBossLeftUp
	JSR RenderBossRightUp
	INC dinojumpstate
	RTS

BossAscends:
	LDX dinojumppointer
	LDA gojirajumpacceleration, x
	CMP #$FF
	BEQ BossAscendsDone
	STA dinoacceleration
	JSR MoveBossOnJumping
	INC dinojumppointer
	RTS
BossAscendsDone:
	INC dinojumpstate
	RTS

BossInAir:
	; fall a bit regardless of cat position
	; maybe use movecounter here
	INC dinojumpstate
	RTS

BossDescends:
	; stop falling depending on cat position
	; add condition here
	LDA dinojumppointer
	CMP #$FF
	BEQ BossDescendsDone
	LDX dinojumppointer
	LDA gojirajumpacceleration, x
	STA dinoacceleration
	JSR MoveBossOnJumping
	DEC dinojumppointer
	RTS
BossDescendsDone:
	INC dinojumpstate
	RTS

BossLanded:
	; add sound
	; shake screen
	JSR RenderBossDefault
	INC dinojumpstate
	RTS

MoveBossOnJumping:
  LDA #$38
  STA ramspriteslow  ; load into ram starting from this address
  LDX #$19
  LDY #$00
MoveBossOnJumpingLoop:
	LDA dinojumpstate        ; if boss is in ascending state, subtract dinoacceleration from boss y coordinates
	CMP #$01								 ; else add dinoacceleration to boss y coordinates
	BNE MoveBossOnJumpingIncrement
MoveBossOnJumpingDecrement:
  LDA [ramspriteslow], y
  SEC
  SBC dinoacceleration
  JMP MoveBossOnJumpingStoreResult
MoveBossOnJumpingIncrement:
	LDA [ramspriteslow], y
	CLC
  ADC dinoacceleration
MoveBossOnJumpingStoreResult:
  STA [ramspriteslow], y   ; store into RAM address
  INY                      ; Y = Y + 1
  INY
  INY
  INY
  DEX
  CPX #$00
  BNE MoveBossOnJumpingLoop
  LDA #$18
  STA ramspriteslow  ; restore default ppu pointer position
	RTS
