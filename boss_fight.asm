boss_fight_jump_table:
	.word BossThrowsFireballs-1
	.word BossChases-1
	.word BossRageTalk-1
	.word BossRageJump-1
	.word OpenUmbrella-1
	.word FallingHydrants-1
	.word BossRageJump-1
	.word BossBlink-1
	.word BossCandyDrop-1
	.word CloseUmbrella-1

BossFightEvent:
	; TODO: move out of NMI later
	JSR ProcessProjectiles
	LDA dinojumpstate
	BNE BossJumpInProcess

	; implementing the RTS trick here https://www.nesdev.org/wiki/RTS_Trick
	LDA fightstate
	ASL A            		  ; we have a table of addresses, which are two bytes each. double that index.
  TAX
  LDA boss_fight_jump_table+1, x    ; RTS will expect the low byte to be popped first,       
  PHA                               ; so we need to push the high byte first
  LDA boss_fight_jump_table, x      ; push the low byte
  PHA
  RTS 									; this rts will launch our subroutine
BossJumpInProcess:
	JSR BossJumps
	RTS

OpenUmbrella:
	LDA movecounter
	BNE OpenUmbrellaWait
	LDA umbrellastate
	BEQ OpenUmbrellaInit
	CMP #$01
	BEQ OpenUmbrellaChangeSprites
	CMP #$02
	BEQ OpenUmbrellaFrame1
	CMP #$03
	BEQ OpenUmbrellaFrame2
	CMP #$04
	BEQ UmbrellaOpened
	RTS
OpenUmbrellaWait:
	DEC movecounter
	RTS

UmbrellaOpened:
	LDA #$09
  JSR sound_load
	LDA #$00
	STA umbrellastate
	INC fightstate
	RTS

OpenUmbrellaInit:
	LDA #$00
	STA shakescreen
	INC umbrellastate
	LDA #$10
	STA movecounter
	RTS

OpenUmbrellaChangeSprites:
	LDA #$59
	STA $022D
	LDA #$69
	STA $0235
	INC $022F
	INC umbrellastate
	RTS

OpenUmbrellaFrame1:
	LDX #$24
  LDY #$EE
  JSR SetPPUAddrSubroutine
  LDA #$29
  STA $2007
	LDX #$25
  LDY #$0E
  JSR SetPPUAddrSubroutine
  LDA #$1D
  STA $2007
  LDX #$25
  LDY #$2E
  JSR SetPPUAddrSubroutine
  LDA #$2D
  STA $2007
  LDX #$25
  LDY #$4E
  JSR SetPPUAddrSubroutine
  LDA #$18
  STA $2007
	INC umbrellastate
	LDA #$20
	STA movecounter
	RTS

OpenUmbrellaFrame2:
	LDX #$24
  LDY #$ED
  JSR SetPPUAddrSubroutine
  LDX #$00
  LDY #$1A
  JSR OpenUmbrellaFrame2LoadTilesLoop
  LDX #$25
  LDY #$0D
  JSR SetPPUAddrSubroutine
  LDX #$00
  LDY #$2A
  JSR OpenUmbrellaFrame2LoadTilesLoop
  LDX #$25
  LDY #$2E
  JSR SetPPUAddrSubroutine
  LDA #$19
  STA $2007
  INC umbrellastate
	LDA #$20
	STA movecounter
	RTS

OpenUmbrellaFrame2LoadTilesLoop:
  STY $2007
  INY
  INX
  CPX #$03
  BNE OpenUmbrellaFrame2LoadTilesLoop
	RTS

CloseUmbrella:
	LDA movecounter
	BNE CloseUmbrellaWait
	LDA umbrellastate
	BEQ CloseUmbrellaFrame1
	CMP #$01
	BEQ CloseUmbrellaFrame2
	CMP #$02
	BEQ UmbrellaClosed
	RTS
CloseUmbrellaWait:
	DEC movecounter
	RTS

CloseUmbrellaFrame1:
	JSR OpenUmbrellaFrame1
	LDX #$20
  LDY #$ED
  JSR CloseUmbrellaLoadToPPU
  LDX #$21
  LDY #$0D
  JSR CloseUmbrellaLoadToPPU
  LDX #$20
  LDY #$EF
  JSR CloseUmbrellaLoadToPPU
  LDX #$21
  LDY #$0F
  JSR CloseUmbrellaLoadToPPU
	RTS

CloseUmbrellaFrame2:
	LDX #$20
  LDY #$EE
  JSR CloseUmbrellaLoadToPPU
  LDX #$21
  LDY #$0E
  JSR CloseUmbrellaLoadToPPU
  LDX #$21
  LDY #$2E
  JSR CloseUmbrellaLoadToPPU
  LDX #$21
  LDY #$4E
  JSR CloseUmbrellaLoadToPPU
  INC umbrellastate
	RTS

CloseUmbrellaLoadToPPU:
	JSR SetPPUAddrSubroutine
	LDA #$9D
  STA $2007
	RTS

UmbrellaClosed:
	LDA switches
  ORA #%01000000
  STA switches ; add trigger
	LDA #$7A
	STA $022D
	LDA #$8A
	STA $0235
	DEC $022F
	LDA #$00
	STA action
	RTS

BossRageJump:
	LDA dinojumpcount ; compare to 1 instead of 0 to avoid throwing fireballs after jumping
	CMP #$01
	BEQ BossRageJumpDone
	JSR BossJumps
	RTS
BossRageJumpDone:
	LDA #$30
	STA movecounter
	LDA fightstate
	CMP #$06
	BEQ BossRageJumpDropHydrants
	INC fightstate
	RTS
BossRageJumpDropHydrants:
	DEC fightstate
	LDA #$03
	STA hydrantsstate
	RTS

BossRageTalk:
	LDA projectilenumber
	BNE BossRageTalkWait
	LDA #$00
  JSR sound_load
	JSR BossOpensMouth
	LDA #LOW(enraged)
  STA currenttextlow
  LDA #HIGH(enraged)
  STA currenttexthigh
  LDA #$01
  STA action
  LDA #$07
	STA eventnumber
	LDA #$04
	STA dinojumpcount
	INC fightstate
BossRageTalkWait:
	RTS

BossOpensMouth:
	LDA #$8B
	STA $023D
	LDA #$9A
	STA $0245
	LDA #$9B
	STA $0249
	RTS

BossClosesMouth:
	LDA #$A9
	STA $023D
	LDA #$B8
	STA $0245
	LDA #$B9
	STA $0249
	RTS

DefineProjectileNumberLimit:
	LDA fightcycle
	CMP #BOSSFIRSTPHASELENGTH
	BCC ProjectileNumberLimitFirstPhase
	LDA #$02
	RTS
ProjectileNumberLimitFirstPhase:
	LDA #$01
	RTS

BossChases:
	JSR CheckBossJump
	LDA dinochasestate
	BEQ BossChasesInit
	CMP #$01
	BEQ BossChasesDelay
	CMP #$02
	BEQ BossChasesCheck
	CMP #$03
	BEQ BossChasesMove
	RTS

BossChasesInit:
	LDA #$20
  STA movecounter
	INC dinochasestate
	RTS

BossChasesDelay:
	LDA movecounter
	BEQ BossChasesDelayDone
	DEC movecounter
	RTS
BossChasesDelayDone:
	LDA #$20
  STA movecounter
  INC dinochasestate
	RTS

BossChasesCheck:
	; wait for cat movement here
	; if cat stands on same line, wait for counter to pass, then throw fireballs
	; else proceed to chase
	LDA $0210
	SEC
	SBC #CATBOSSPOSITIONOFFSET
	CMP $0274
	BEQ BossChasesCheckWait
	BCC BossChasesUp
	BCS BossChasesDown
BossChasesCheckWait:
	LDA movecounter
	BEQ BossChasesCheckDone
	DEC movecounter
	RTS
BossChasesCheckDone:
	LDA projectilenumber
	BNE BossChasesCheckLimitWait
	LDA #$00
	STA dinochasestate
	STA fightstate
BossChasesCheckLimitWait:
	RTS

BossChasesUp:
	LDA #$02
	JMP BossChasesSetDirection
BossChasesDown:
	LDA #$01
BossChasesSetDirection:
	STA dinomvstate
	INC dinochasestate
	LDA #$40
  STA movecounter
	RTS

BossChasesMove:
	; compare positions
	; when on the same line, throw fireballs
	; else walk, decrement counter and throw fireballs when 0
	LDA $0210
	SEC
	SBC #CATBOSSPOSITIONOFFSET
	TAX
	LDA dinomvstate
	CMP #$01
	BEQ BossChasesCheckWhenMoveDown
BossChasesCheckWhenMoveUp:
	CPX $0274
	BCS BossChasesMoveDone
	JMP BossChasesProceedMoving
BossChasesCheckWhenMoveDown:
	DEX
	CPX $0274
	BCC BossChasesMoveDone
BossChasesProceedMoving:
	LDA movecounter
	BEQ BossChasesMoveDone
	DEC movecounter
	JSR BossWalks
	RTS
BossChasesMoveDone:
	JSR BossStops
	LDA projectilenumber
	BNE ProjectileLimitReachedKeepChasing
	LDA #$00
	STA dinochasestate
	STA fightstate
	RTS
ProjectileLimitReachedKeepChasing:
	LDA #$08
  STA movecounter
  LDA #$01
  STA dinochasestate
	RTS

CheckBossJump:
	LDA $0213 ; if cat is too close, perform jump
	CMP #$78  ; change this number to adjust distance
	BCC SkipJumping
	JSR BossJumps
SkipJumping:
	RTS

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
	LDA #$98          ; compare pointer to this number via transform loop
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

BossJumpsInit:
	LDA #$00
	STA dinojumppointer
	JSR RenderBossLeftUp
	JSR RenderBossRightUp
	INC dinojumpstate
	RTS

BossAscendsWithCondition:
	JSR DefineJumpCompareCoordinate
	CMP $028C
	BCS BossAscendsWithConditionDone
	LDA #$05
	STA dinoacceleration
	JSR MoveBossOnJumping
	RTS
BossAscendsWithConditionDone:
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
	LDA fightstate
	CMP #$03
	BCS BossAscendsEnraged
	JSR BossClosesMouth
BossAscendsEnraged:
	RTS

BossJumps:
	LDA dinojumpstate
	BEQ BossJumpsInit
	CMP #$01
	BEQ BossAscendsWithCondition
	CMP #$02
	BEQ BossAscends
	CMP #$03
	BEQ BossDescends
	CMP #$04
	BEQ BossDescendsWithCondition
	CMP #$05
	BEQ BossLands
	CMP #$06
	BEQ BossJumpEnds
	RTS

BossDescends:
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

BossDescendsWithCondition:
	JSR DefineJumpCompareCoordinate
	CMP $028C
	BCC BossDescendsWithConditionDone
	LDA #$05
	STA dinoacceleration
	JSR MoveBossOnJumping
	RTS
BossDescendsWithConditionDone:
	INC dinojumpstate
	RTS

BossLands:
	LDA #$06
  JSR sound_load
  LDA #$01
  STA shakescreen
  LDA $0213
  CMP #$78
  BCS DeathFromJump
	JSR RenderBossDefault
	INC dinojumpstate
	LDA #$08
	STA movecounter
	RTS
DeathFromJump:
	JSR ProcessDeath
	RTS

BossJumpEnds:
	LDA movecounter
	BNE BossJumpWait
	LDA #$00
  STA dinojumpstate
  LDA dinojumpcount
  BNE BossKeepsJumping
  STA shakescreen    ; A would be 0 here
  STA fightstate     ; throw fireballs right after the jump
	STA fireballsstate
	RTS
BossKeepsJumping:
	DEC dinojumpcount
	RTS
BossJumpWait:
	DEC movecounter
	RTS

DefineJumpCompareCoordinate:
	LDA dinojumpcount
	BEQ JumpCompareToCat
	LDA #BOSSENRAGEDPOSITION
	RTS
JumpCompareToCat:
	LDA $0208 ; y of the middle of the cat
	RTS

MoveBossOnJumping:
  LDA #$38
  STA ramspriteslow  ; load into ram starting from this address
  LDX #$18
  LDY #$00
MoveBossOnJumpingLoop:
	LDA dinojumpstate        ; if boss is in ascending state, subtract dinoacceleration from boss y coordinates
	CMP #$03								 ; else add dinoacceleration to boss y coordinates
	BCS MoveBossOnJumpingIncrement
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

BossBlink:
	LDA movecounter
	CMP #$60             ; delay before blinking
	BCS BossBlinkDone
	AND #%00000001       ; branch depends on whether movecounter is even/odd
  BNE BossBlinkAppear  ; odd
BossBlinkDisappear:
	LDA #$06          ; switch tiles via transform loop
	STA trnsfrm
	LDX #$39          ; tiles are stored at address 0200 + this number
	LDA #$99
	STA trnsfrmcompare
	LDA #$00
	STA switchtile    ; switch to nothing
	JSR ObjectTransformNoCache
	LDA #$00          ; erase hydrant
	STA $0219
BossBlinkDone:
	LDA movecounter
	BEQ BossBlinkCandy
	DEC movecounter
	RTS
BossBlinkCandy:
	LDA #LOW(candy) ; draw candy
  STA curntspriteslow
  LDA #HIGH(candy)
  STA curntspriteshigh
  LDA #$08
  STA spritescompare
  JSR LoadSprites
  JSR RenderBossMoveDone
  LDA #$18
  STA movecounter
	INC fightstate
  RTS

BossBlinkAppear:
  LDA #$38
  STA ramspriteslow  ; load into ram starting from this address
  LDX #$18
  LDY #$01
BossBlinkAppearLoop:
  LDA gojira, y     ; load data from address (sprites +  y)
  STA [ramspriteslow], y   ; store into RAM address
  INY                      ; Y = Y + 1
  INY
  INY
  INY
  DEX
  CPX #$00
  BNE BossBlinkAppearLoop
  JSR BossOpensMouth
	LDA #$8C
	STA $023D
	LDA #$2D          ; draw hydrant
	STA $0219
	JMP BossBlinkDone

BossCandyDrop:
	LDA movecounter
	BEQ BossCandyDropDone
	INC $0238
	INC $023C
	DEC movecounter
	RTS
BossCandyDropDone:
	INC fightstate
	RTS
