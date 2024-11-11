post_events_jump_table:
	.word CandymanHandSubroutine-1
	.word SatanGlitchSubroutine-1
	.word OfficeSubroutine-1
	.word MathSubroutine-1
	.word SkatingSubroutine-1

initial_events_jump_table:
	.word OldLadySubroutine-1
	.word ForgotSubroutine-1
	.word MathCandySubroutine-1
	.word SatanWalkSubroutine-1
	.word MedsSubroutine-1
	.word BucketHatGuySubroutine-1
	.word GhostGuardSubroutine-1
	.word StartGhostSubroutine-1
	.word RestartSubroutine-1
	.word DeathSubroutine-1

NonTextEvents:
	; implementing the RTS trick here https://www.nesdev.org/wiki/RTS_Trick
	LDA eventnumber
	BEQ NonTextEventsDone ; if zero, then there is no event
	CMP #$40
	BCC PerformPostEvent  ; if < 40
	EOR #%01000000  			; subtract 40, so to say
	ASL A            		  ; we have a table of addresses, which are two bytes each. double that index.
  TAX
  LDA initial_events_jump_table+1, x    ; RTS will expect the low byte to be popped first,       
  PHA                                   ; so we need to push the high byte first
  LDA initial_events_jump_table, x      ; push the low byte
  PHA
  RTS                   ; this rts will launch our subroutine
PerformPostEvent:
	SEC
	SBC #$01              ; subtract 1 from A because table index would start from 0 but event numbers start from 1
	ASL A          			  ; we have a table of addresses, which are two bytes each. double that index.
  TAX
  LDA post_events_jump_table+1, x    ; RTS will expect the low byte to be popped first,       
  PHA                                ; so we need to push the high byte first
  LDA post_events_jump_table, x      ; push the low byte
  PHA
  RTS                   ; this rts will launch our subroutine
NonTextEventsDone:
	LDA #$00
  STA action
	RTS

CandymanHandSubroutine:
	INC candycounter
	LDA #$34         ; tear off hand
	STA $0221
	LDA #LOW(hand_acquired)
  STA currenttextlow
  LDA #HIGH(hand_acquired)
  STA currenttexthigh
  LDA candyswitches
  ORA #%00000010
  STA candyswitches
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
	LDX #MVUP
	LDY #$01
	JSR EventWalkSubroutine
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
	JSR ObjectTransformNoCache
	LDA #LOW(candy_left)
  STA currenttextlow
  LDA #HIGH(candy_left)
  STA currenttexthigh
  LDA candyswitches
  ORA #%00000001
  STA candyswitches
	LDA #$01
  STA action
  LDA #$18
  STA ramspriteslow  ; restore default ppu pointer position
  LDA #$00
	STA eventstate
	JSR PerformNonTextEventDone
	RTS

SatanWalkSubroutine:
	LDA movecounter
	BEQ SatanWalkSubroutineDone
	DEC movecounter
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
	LDA #$00
	STA loadcache      ; disable loading cat graphics from cache
	LDA #$21           ; cat puts down his bag
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
  STA textpartscounter
  LDA #$04
  STA bgrender        ; activate background rendering and perform it via main loop (outside of NMI)
  LDA #$80            ; TODO: add different values for PAL/NTSC
  STA nmiwaitcounter  ; skip nmi subroutines in the first 32 frames after bg is changed
  STA eventwaitcounter
  LDA #LOW(satan_talk)
  STA currenttextlow
  LDA #HIGH(satan_talk)
  STA currenttexthigh
	LDA #$05
	STA eventnumber
	LDA #$00
  STA eventstate
  STA ramspriteslow  ; set ppu pointer position
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
  JSR AddSpritesComparetoSprites

	INC eventstate
	RTS

GlitchClearSprites:
	LDY #$00
	JSR ClearSprites
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
	LDA #DELAYGHOSTROOM1
  STA nmiwaitcounter
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
	RTS

OfficeGhostMovesLeft:
	LDA #$00
	STA trnsfrm             ; decrement via transform loop
	JSR OfficeGhostMoves
	LDA #$60
	STA eventwaitcounter
	LDA #$03
	STA eventstate
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
	RTS

OfficeGhostMoves:
	LDA #$77                ; compare pointer to this number via transform loop
	STA trnsfrmcompare
	LDY #$00
OfficeGhostMovesLoop:
	LDX #$57                ; ghost tiles are stored at address 0200 + this number
	JSR ObjectTransformNoCache
	INY
	CPY #$05
	BNE OfficeGhostMovesLoop
	RTS

OfficeCatMoves:
	TXA
	STA buttons
	LDA #$60
	STA eventwaitcounter
	RTS

ParkTeleportSubroutine:
	LDA switches
  ORA #%00100000
  STA switches ; ghost pass trigger
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
  LDA #DELAYGHOSTROOM1
  STA nmiwaitcounter
	RTS

MathSubroutine:
	LDA eventstate
	CMP #$07
	BCC DrawExpression ; if eventstate < 7
	CMP #$07
	BEQ DropCandy
	CMP #$08
	BEQ CandyFalls
	RTS

DropCandy:
	INC eventstate
	LDA switches
	ORA #%00000001
	STA switches
	LDA #$15
  STA movecounter
	RTS

CandyFalls:
	LDA movecounter
	BEQ CandyFallsDone
	DEC movecounter
	INC $0218       ; alter candy vertical coordinates
	RTS
CandyFallsDone:
	LDA #$00
  STA eventstate
  JSR PerformNonTextEventDone
	RTS

DrawExpression:
	LDA eventstate
	CMP #$01
	BEQ DrawExpressionSkipDelay
	LDA #$30
  STA eventwaitcounter ; add delay
DrawExpressionSkipDelay:
	LDA eventstate
	BEQ DrawExpressionFrame0
	CMP #$01
	BEQ DrawExpressionFrame1bg
	CMP #$02
	BEQ DrawExpressionSprites ; frame 1 sprites only
	CMP #$03
	BEQ DrawExpressionSprites ; frame 2
	CMP #$04
	BEQ DrawExpressionFrame3
	CMP #$05
	BEQ DrawExpressionSprites ; frame 4
	CMP #$06
	BEQ DrawExpressionDone
DrawExpressionFrame0:
	; initiating some render params here
  LDA #LOW(expression)
  STA curntspriteslow
  LDA #HIGH(expression)
  STA curntspriteshigh
  LDA #$4C
  STA ramspriteslow  ; load into ram starting from this address
  JMP DrawExpressionSprites
DrawExpressionFrame1bg:
	LDX #$20
  LDY #$AB
	JSR SetPPUAddrSubroutine
	LDA #$6F
  STA $2007
  JMP SkipDrawingExpressionSprites
DrawExpressionFrame3:
	LDX #$20
  LDY #$CB
	JSR SetPPUAddrSubroutine
	LDX #$09
DrawExpressionLineLoop:
	LDA #$9B
  STA $2007
  DEX
  BNE DrawExpressionLineLoop
	JMP SkipDrawingExpressionSprites
DrawExpressionSprites:
  JSR DrawExpressionSpritesSubroutine
SkipDrawingExpressionSprites:
  INC eventstate
  RTS

DrawExpressionDone:
	INC eventstate
	LDA #$18
  STA ramspriteslow  ; restore default ppu pointer position
	LDA #$01
  STA action
  LDA #LOW(math_ghost2)
  STA currenttextlow
  LDA #HIGH(math_ghost2)
  STA currenttexthigh
  LDA #$03
  STA textpartscounter
	RTS

DrawExpressionSpritesSubroutine:
	LDY eventstate
	LDA expressiontilesperline, y
  STA spritescompare
  LDY #$00
DrawExpressionSpritesLoop:
  LDA [curntspriteslow], y
  STA [ramspriteslow], y
  INY
  CPY spritescompare
  BNE DrawExpressionSpritesLoop
  ; yeah proceed to the code below, it's ok

AddSpritesComparetoSprites:
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
	RTS

MathCandySubroutine:
	INC candycounter
	LDA #$00
	STA $0219             ; candy disappears
	LDA switches
  AND #%11111110
  STA switches          ; remove candy dropped trigger
	LDA #LOW(candy_left)
	STA currenttextlow
	LDA #HIGH(candy_left)
	STA currenttexthigh
	LDA candyswitches
	ORA #%00001000
	STA candyswitches
	LDA #$01
  STA action
  JSR PerformNonTextEventDone
	RTS

MedsSubroutine:
	LDA switches
	AND #%00000100
	BNE MedsSubroutineDone
	LDA switches
	AND #%00000010
	BEQ MedsSubroutineDone
	LDA #$01
	STA textpartscounter
	LDA switches
	ORA #%00000100
  STA switches   ; take pills
MedsSubroutineDone:
	LDA #$01
  STA action
  JSR PerformNonTextEventDone
	RTS

BucketHatGuySubroutine:
	LDA eventstate
	BNE BucketHatGuyCandyAcquired ; it's basically the second part of BucketHatGuyState2
	LDA candyswitches
	AND #%00000100
	BNE BucketHatGuyState3
	LDA switches
	AND #%00000100
	BNE BucketHatGuyState2
BucketHatGuyState1:
	LDA #LOW(corporations)
	STA currenttextlow
	LDA #HIGH(corporations)
	STA currenttexthigh
	LDA #$02
	STA textpartscounter
	LDA switches
  ORA #%00000010
  STA switches  ; can go get pills after this event
	JMP BucketHatGuySubroutineDone

BucketHatGuyState2:
	; when buckethat guy receives meds
	LDA #LOW(chill_pill)
	STA currenttextlow
	LDA #HIGH(chill_pill)
	STA currenttexthigh
	LDA #$03
	STA textpartscounter
	LDA candyswitches
  ORA #%00000100
  STA candyswitches
	LDA #$01
  STA action
  STA eventstate
  RTS

BucketHatGuyState3:
	; after buckethat guy gives you licorice
	LDA #LOW(no_love)
	STA currenttextlow
	LDA #HIGH(no_love)
	STA currenttexthigh
	JMP BucketHatGuySubroutineDone

BucketHatGuyCandyAcquired:
	DEC eventstate
	INC candycounter
	LDA #LOW(candy_left)
  STA currenttextlow
  LDA #HIGH(candy_left)
  STA currenttexthigh

BucketHatGuySubroutineDone:
	LDA #$01
  STA action
  JSR PerformNonTextEventDone
	RTS

GhostGuardSubroutine:
	LDA eventstate
	BEQ GhostGuardWalk
	CMP #$01
	BEQ GhostGuardInitiateRender
	CMP #$02
	BEQ GhostGuardBlinks
	CMP #$03
	BEQ GhostGuardTalks
	CMP #$04
	BEQ GhostGuardHides
	RTS

GhostGuardWalk:
	LDX #MVUP
	LDY #$01
	JSR EventWalkSubroutine
	RTS

GhostGuardTalks:
	LDA #LOW(proceed_no_more)
  STA currenttextlow
  LDA #HIGH(proceed_no_more)
  STA currenttexthigh
  LDA #$01
  STA textpartscounter
  STA action
  INC eventstate
  RTS

GhostGuardHides:
	LDA #$00
  STA $02F5   ; erase ghost tile in ram
	LDA #$00
	STA eventstate
	LDA switches
	ORA #%00001000
	STA switches
	JSR PerformNonTextEventDone
	JSR CalculateTileInFrontOfCatSubroutine ; update the coordinates so that this event won't be looped
	; yea, i know, weird stuff, but when action button is pressed, warp subroutine fails to receive recent cat coordinates
	; and constantly repeats guard ghost event
	RTS

GhostGuardInitiateRender:
	LDA #$F4
	STA ramspriteslow
	LDA #LOW(ghostguard)
  STA curntspriteslow
  LDA #HIGH(ghostguard)
  STA curntspriteshigh
  LDY #$00
GhostGuardRenderLoop:
	LDA [curntspriteslow], y
  STA [ramspriteslow], y
  INY
  CPY #$03
  BNE GhostGuardRenderLoop
  ; calculate ghost's x coordinate here
  LDA $0203 ; x coordinate of the first cat tile
  SEC
  SBC #$0A ; distance between a ghost and a cat
  STA [ramspriteslow], y
  LDA #$18
  STA ramspriteslow  ; restore default ppu pointer position
  LDA #$30
	STA movecounter
	INC eventstate
	RTS

GhostGuardBlinks:
	LDA movecounter
  AND #%00000001            ; branch depends on whether movecounter is even/odd
  BNE GhostGuardDisappears  ; odd
  LDA #$6B                  ; even
  STA $02F5                 ; load ghost tile into ram
GhostGuardBlinksDone:
	LDA movecounter
	BEQ GhostGuardChangeEventState ; if 0
	DEC movecounter
  RTS
GhostGuardChangeEventState:
	INC eventstate
	RTS

GhostGuardDisappears:
	LDA #$00
  STA $02F5               ; erase ghost tile in ram
	JMP GhostGuardBlinksDone

EventWalkSubroutine:
	LDA movecounter
	BEQ EventWalkDone
	DEC movecounter
	STY walkbackwards
	STX buttons
	RTS
EventWalkDone:
	LDA #$00
  STA walkbackwards
	INC eventstate
	RTS

StartGhostSubroutine:
	; when ghost pass received
	LDA switches
  AND #%00100000
  BNE StartGhostState3
	; when house visited
	LDA switches
	AND #%00001000
	BNE StartGhostState2
	; else
StartGhostState1:
	LDA #LOW(startghost)
	STA currenttextlow
	LDA #HIGH(startghost)
	STA currenttexthigh
  JMP StartGhostSubroutineDone

StartGhostState2:
	LDA #LOW(ceo)
	STA currenttextlow
	LDA #HIGH(ceo)
	STA currenttexthigh
	LDA #$03
  STA textpartscounter
  LDA switches
  ORA #%00010000
  STA switches  ; can go to CEO after this event
  JMP StartGhostSubroutineDone

StartGhostState3:
	LDA #LOW(predictions)
	STA currenttextlow
	LDA #HIGH(predictions)
	STA currenttexthigh
	JMP StartGhostSubroutineDone

StartGhostSubroutineDone:
	LDA #$01
  STA action
  JSR PerformNonTextEventDone
	RTS

ForgotSubroutine:
	LDA eventstate
	BEQ ForgotWalk
	CMP #$01
	BEQ ForgotTalk
	LDA #$00
	STA eventstate
	JSR PerformNonTextEventDone
	RTS

ForgotWalk:
	LDX #MVDOWN
	LDY #$01
	JSR EventWalkSubroutine
	RTS

ForgotTalk:
	LDA #LOW(forgot)
	STA currenttextlow
	LDA #HIGH(forgot)
	STA currenttexthigh
	LDA #$01
  STA action
	INC eventstate
	JSR PerformNonTextEventDone
	JSR CalculateTileInFrontOfCatSubroutine ; same thing as with ghost guard
	RTS

SkatingSubroutine:
	LDA eventstate
	BEQ SkatingWarp
	RTS

SkatingWarp:
	JSR CatHouseEndWarp
	INC eventstate
	LDA #DELAYENDSCREEN
  STA nmiwaitcounter
	RTS

RestartSubroutine:
	LDA eventstate
	BEQ RestartWarp
	CMP #$01
	BEQ RestartWalk
	LDA #$00
	STA eventstate
	JSR PerformNonTextEventDone
	RTS

RestartWarp:
	LDA #MVRIGHT
  STA buttons
	JSR DeadCatHouseWarp
  LDA #$01
  STA loadcache
  STA eventstate
  LDA #$04
  STA movecounter
	RTS

RestartWalk:
	LDX #MVRIGHT
	LDY #$00
	JSR EventWalkSubroutine
	RTS

DeathSubroutine:
	LDA lives
	BEQ SkipLivesDecrement ; do not decrement lives when there are no more
	DEC lives
SkipLivesDecrement:
	LDA animatecounter
	STA randomnumber
	LDA #$05
  STA bgrender
  LDA #$03
  STA nmiwaitcounter
  LDA #$0B
  STA location
  LDA #$20
  STA spritescompare
  LDA #LOW(deadsprites)
  STA curntspriteslow     ; put the low byte of the address of tiles into pointer
  LDA #HIGH(deadsprites)
  STA curntspriteshigh    ; put the high byte of the address into pointer
  LDA #MVRIGHT
  STA buttons
  LDA #$01
  STA action
  JSR SetDeathText
  JSR PerformNonTextEventDone
	RTS

SetDeathText:
	LDA lives
	BNE RestartText
	LDA randomnumber
	CMP #XAHASCREENCHANCE
	BCC XahaText            ; if randomnumber < XAHASCREENCHANCE
ItsOverText:
	LDA #LOW(deadd)
  STA currenttextlow
  LDA #HIGH(deadd)
  STA currenttexthigh
	RTS
XahaText:
	LDA #LOW(deaddd)
  STA currenttextlow
  LDA #HIGH(deaddd)
  STA currenttexthigh
	RTS
RestartText:
	LDA #LOW(dead)
  STA currenttextlow
  LDA #HIGH(dead)
  STA currenttexthigh
	RTS

PerformNonTextEventDone: ; might need to set one more event after the next text part, so this code should be optional
	; TODO: check if can move setting eventstate to zero here
	LDA #$00
	STA eventnumber
	RTS
