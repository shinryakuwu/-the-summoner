CheckActionNMI:
	LDA #$01
	STA actionnmi
	JMP CheckAction

CheckActionMainLoop:
	LDA #$00
	STA actionnmi

CheckAction:
	LDA eventwaitcounter
	BNE EventWait            ; do nothing in this frame unless eventwaitcounter is zero
	LDA actionnmi
	BEQ CheckActionStatus
	LDA action               ; fix for blinking screen when action logic is happening during the animation frame
	BEQ CheckActionStatusNMIDone ; when action is 0
	LDA animatecounter
	BNE CheckActionStatusNMI
EventWaitDone:
	JSR BlockMovement
	RTS

EventWait:
	DEC eventwaitcounter
	LDA actionnmi          ; block movement here only when check action is called from nmi
	BNE EventWaitDone      ; because calling it in main loop messes up automovement
	RTS                    ; (buttons are set to some direction and this code clears it before CheckMovement is called)

CheckActionStatusNMI:
	; check for statuses that will be processed within nmi
	LDA action
	CMP #$07
	BEQ PerformBossFightEvent ; movement should remain here
	JSR BlockMovement
	LDA action
	CMP #$01
	BEQ PerformTextEvent
	CMP #$05
	BEQ PerformNonTextEvent
	CMP #$06
	BEQ ClearTextSection
CheckActionStatusNMIDone:
	RTS

CheckActionStatus:
	LDA action
	BEQ CheckActionButtons ; if zero action state
	CMP #$01
	BEQ PerformTalkBeep
	CMP #$02
	BEQ ActionTimeout
	CMP #$03
	BEQ ClearTextSectionDone
	CMP #$04
	BEQ StartButtonLogic
	CMP #$07
	BEQ PerformCollisionLogic
	RTS

PerformTalkBeep:
	JSR TalkBeep
	RTS

PerformBossFightEvent:
	JSR BossFightEvent
	JSR DrawProjectiles
	RTS

PerformCollisionLogic:
	JSR CheckCollision
	RTS

PerformTextEvent:
	JSR RenderText
	RTS

PerformNonTextEvent:
	JSR NonTextEvents
	RTS

ClearTextSection:
	JSR ClearTextSectionSubroutine
	RTS

CheckActionButtons:
	LDA buttons_pressed
	AND #ACTIONBUTTONS
	BNE CheckTileForAction
	RTS

CheckTileForAction:
	JSR CheckActionTile
	RTS

StartButtonLogic:
	JSR StartButtonLogicSubroutine
	RTS

ActionTimeout:
	LDA buttons_pressed     ; the part of the text action is over, keep waiting for action button to be pressed at this step
	AND #ACTIONBUTTONS      ; when action button is pressed, clear text and disable action or initiate rendering next text part
	BEQ WaitForActionButton
	LDA #$00
	STA cleartextstate
	LDA #$06                 ; trigger processing ClearTextSectionSubroutine from the next frame
	STA action
WaitForActionButton:
	RTS

ClearTextSectionDone:
	LDA textpartscounter
	BNE NextTextPart      ; if textpartscounter is not zero, set action to 1, decrement textpartscounter
	LDA eventnumber
	BEQ EndOfAction
	LDA #$05
	STA action            ; perform non text event within the next frame
	RTS
EndOfAction:
	LDA #$00
	STA action
	RTS

NextTextPart:
	DEC textpartscounter
	LDA #$01
	STA action ; enable action
	RTS

CheckActionTile:
	LDX $0213          ; load horizontal coordinate of the cat's left bottom tile into X
	LDY $0210          ; load vertical coordinate of the cat's left bottom tile into Y
	JSR CalculateTileInFrontOfCatSubroutine
	; add conditions for actions here
	LDA location
	BEQ Village1Events
	CMP #$01
	BEQ CatHouseEvents
	CMP #$03
	BEQ SkeletonHouseEvents
	CMP #$04
	BEQ ServerRoomEvents
	CMP #$07
	BEQ GhostRoom2Events
	CMP #$08
	BEQ ParkEvents
	CMP #$09
	BEQ ExHouseEvents
	RTS

Village1Events:
	JSR Village1EventsSubroutine
	RTS
CatHouseEvents:
	JSR CatHouseEventsSubroutine
	RTS
SkeletonHouseEvents:
	JSR SkeletonHouseEventsSubroutine
	RTS
ServerRoomEvents:
	JSR ServerRoomEventsSubroutine
	RTS
ParkEvents:
	JSR ParkEventsSubroutine
	RTS
GhostRoom2Events:
	JSR GhostRoom2EventsSubroutine
	RTS
ExHouseEvents:
	JSR ExHouseEventsSubroutine
	RTS

Village1EventsSubroutine:
	LDX #$1B
	LDY #$05
	JSR CheckTilesForEvent
	BNE StartGhostParams
	LDX #$1C
	LDY #$05
	JSR CheckTilesForEvent
	BNE StartGhostParams
	LDX #$0B
	LDY #$08
	JSR CheckTilesForEvent
	BNE OldLadyParams
	RTS

StartGhostParams:
	LDA #$47
	STA eventnumber
	JSR SettingEventParamsDone
	RTS

OldLadyParams:
	LDA candyswitches
	AND #%00000001
	BNE OldLadyParamsDone ; if candy already gathered, skip event
	LDA #$40
	STA eventnumber
	JSR SettingEventParamsDone
OldLadyParamsDone:
	RTS

CatHouseEventsSubroutine:
	LDX #$15
	LDY #$07
	JSR CheckTilesForEvent
	BNE ComputerParams
	LDX #$13
	LDY #$07
	JSR CheckTilesForEvent
	BNE MedicineParams
	LDX #$11
	LDY #$0A
	JSR CheckTilesForEvent
	BNE ColaParams
	LDX #$0B
	LDY #$0E
	JSR CheckTilesForEvent
	BNE CassetteParams
	LDX #$0C
	LDY #$0A
	JSR CheckTilesForEvent
	BNE FursuitParams
	LDX #$12
	LDY #$0E
	JSR CheckTilesForEvent
	BNE FanfictionParams
	RTS

ComputerParams:
	LDA #LOW(computer)
	STA currenttextlow
	LDA #HIGH(computer)
	STA currenttexthigh
	JSR SettingEventParamsDone
	RTS
MedicineParams:
	LDA #LOW(medicine)
	STA currenttextlow
	LDA #HIGH(medicine)
	STA currenttexthigh
	LDA #$44
	STA eventnumber
	JSR SettingEventParamsDone
	RTS
ColaParams:
	LDA #LOW(cola)
	STA currenttextlow
	LDA #HIGH(cola)
	STA currenttexthigh
	JSR SettingEventParamsDone
	RTS
CassetteParams:
	LDA #LOW(cassette)
	STA currenttextlow
	LDA #HIGH(cassette)
	STA currenttexthigh
	JSR SettingEventParamsDone
	RTS
FursuitParams:
	LDA #LOW(fursuit)
	STA currenttextlow
	LDA #HIGH(fursuit)
	STA currenttexthigh
	JSR SettingEventParamsDone
	RTS
FanfictionParams:
	LDA #LOW(fanfiction)
	STA currenttextlow
	LDA #HIGH(fanfiction)
	STA currenttexthigh
	JSR SettingEventParamsDone
	RTS

SkeletonHouseEventsSubroutine:
	BNE SkeletonParams
	LDX #$15
	LDY #$07
	JSR CheckTilesForEvent
	BNE CandymanParams
	LDA direction  ; only when looking above
	CMP #$01
	BNE SkeletonHouseEventsSubroutineDone
	LDX #$08
	LDY #$10
	JSR CheckTilesForEvent
	BNE SkeletonParams
	LDX #$09
	LDY #$10
	JSR CheckTilesForEvent
	BNE SkeletonParams
	LDX #$08
	LDY #$06
	JSR CheckTilesForEvent
	BNE JukeboxParams
	LDX #$09
	LDY #$06
	JSR CheckTilesForEvent
	BNE JukeboxParams
SkeletonHouseEventsSubroutineDone:
	RTS

SkeletonParams:
	LDA #LOW(skeleton)
	STA currenttextlow
	LDA #HIGH(skeleton)
	STA currenttexthigh
	JSR SettingEventParamsDone
	RTS
CandymanParams:
	LDA candyswitches
	AND #%00000010
	BNE CandymanParamsDone ; if candy already gathered, skip event
	LDA #LOW(candyman)
	STA currenttextlow
	LDA #HIGH(candyman)
	STA currenttexthigh
	LDA #$01
	STA textpartscounter
	STA eventnumber
	JSR SettingEventParamsDone
CandymanParamsDone:
	RTS
JukeboxParams:
	LDA jukeboxtrigger
	BNE JukeboxParamsDone
	LDA #$4D
	STA eventnumber
	JSR SettingEventParamsDone
JukeboxParamsDone:
	RTS

ServerRoomEventsSubroutine:
	LDX #$14
	LDY #$08
	JSR CheckTilesForEvent
	BNE TVParams
	LDX #$09
	LDY #$0C
	JSR CheckTilesForEvent
	BNE BucketHatGuyParams
	RTS

TVParams:
	LDA #LOW(tv)
	STA currenttextlow
	LDA #HIGH(tv)
	STA currenttexthigh
	JSR SettingEventParamsDone
	RTS

BucketHatGuyParams:
	LDA #$45
	STA eventnumber
	JSR SettingEventParamsDone
	RTS

ParkEventsSubroutine:
	LDX #$15
	LDY #$0A
	JSR CheckTilesForEvent
	BNE OfficeWarpParams
	LDA direction
	CMP #$02
	BEQ ParkEventsCheckLeft
	CMP #$03
	BEQ ParkEventsCheckRight
	RTS

ParkEventsCheckRight:
	LDX #$16
	LDY #$0A
	JSR CheckTilesForEvent
	BNE OfficeWarpParams
	RTS

ParkEventsCheckLeft:
	LDX #$14
	LDY #$0A
	JSR CheckTilesForEvent
	BNE OfficeWarpParams
	RTS

OfficeWarpParams:
	LDA switches
	AND #%00100000
	BNE OfficeWarpParamsDone ; event appears when no ghost pass
	LDA switches
	AND #%00010000
	BEQ OfficeWarpParamsDone ; event appears after getting a hint
	LDA #$03
	STA eventnumber
	LDA #LOW(nothing)
	STA currenttextlow
	LDA #HIGH(nothing)
	STA currenttexthigh
	JSR SettingEventParamsDone
OfficeWarpParamsDone:
	RTS

GhostRoom2EventsSubroutine:
	LDX #$0D
	LDY #$0C
	JSR CheckTilesForEvent
	BNE Ghost1Params
	LDX #$0A
	LDY #$0F
	JSR CheckTilesForEvent
	BNE Ghost2Params
	LDX #$0B
	LDY #$0F
	JSR CheckTilesForEvent
	BNE Ghost2Params
	LDX #$11
	LDY #$0D
	JSR CheckTilesForEvent
	BNE BigGhostParams
	LDX #$12
	LDY #$0D
	JSR CheckTilesForEvent
	BNE BigGhostParams
	LDX #$12
	LDY #$0F
	JSR CheckTilesForEvent
	BNE MathCandyParams
	RTS

Ghost1Params:
	LDA #LOW(ghost1)
	STA currenttextlow
	LDA #HIGH(ghost1)
	STA currenttexthigh
	JSR SettingEventParamsDone
	RTS
Ghost2Params:
	LDA #LOW(ghost2)
	STA currenttextlow
	LDA #HIGH(ghost2)
	STA currenttexthigh
	JSR SettingEventParamsDone
	RTS
BigGhostParams:
	LDA #LOW(math_ghost3)
	STA currenttextlow
	LDA #HIGH(math_ghost3)
	STA currenttexthigh
	JSR SettingEventParamsDone
	RTS
MathCandyParams:
	LDA candyswitches
	AND #%00001000
	BNE MathCandyParamsDone ; if candy already gathered, skip event
	LDA #$42
	STA eventnumber
	JSR SettingEventParamsDone
MathCandyParamsDone:
	RTS

ExHouseEventsSubroutine:
	LDX #$0C
	LDY #$0B
	JSR CheckTilesForEvent
	BNE ExParams
	LDX #$13
	LDY #$0B
	JSR CheckTilesForEvent
	BNE DinoDoorParams
	LDX #$14
	LDY #$0B
	JSR CheckTilesForEvent
	BNE DinoDoorParams
	LDA switches
	AND #%01000000
	BEQ ExHouseEventsSubroutineDone
	LDX #$12
	LDY #$0F
	JSR CheckTilesForEvent
	BNE BossCandy1Params
	LDX #$14
	LDY #$10
	JSR CheckTilesForEvent
	BNE BossCandy2Params
ExHouseEventsSubroutineDone:
	RTS

DinoDoorParams:
	LDA switches
	AND #%01000000
	BNE DinoDoorParamsDone
	LDA lives
	CMP #CATLIVES
	BNE DinoDoorSecondAttempt
	LDA #LOW(dinosaur)
	STA currenttextlow
	LDA #HIGH(dinosaur)
	STA currenttexthigh
	JMP DinoDoorParamsTextIsSet
DinoDoorSecondAttempt:
	LDA #LOW(nothing_new)
	STA currenttextlow
	LDA #HIGH(nothing_new)
	STA currenttexthigh
DinoDoorParamsTextIsSet:
	JSR SettingEventParamsDone
DinoDoorParamsDone:
	RTS

ExParams:
	LDA switches
	AND #%01000000
	BNE ExParamsBossDefeated
	LDA lives
	CMP #CATLIVES
	BNE ExParamsSecondAttempt ; different dialogues depending on lives
	LDA #LOW(evil_ex)
	STA currenttextlow
	LDA #HIGH(evil_ex)
	STA currenttexthigh
	LDA #$03
	STA textpartscounter
	JMP ExParamsTextDone
ExParamsSecondAttempt:
	LDA #LOW(further_attempts)
	STA currenttextlow
	LDA #HIGH(further_attempts)
	STA currenttexthigh
ExParamsTextDone:
	LDA #$06
	STA eventnumber
	JSR SettingEventParamsDone
	RTS
ExParamsBossDefeated:
	LDA #LOW(your_fault)
	STA currenttextlow
	LDA #HIGH(your_fault)
	STA currenttexthigh
	JSR SettingEventParamsDone
	RTS
BossCandy1Params:
	LDA candyswitches
	AND #%00010000
	BNE BossCandyParamsDone ; if candy already gathered, skip event
	LDA #$4A
	STA eventnumber
	JSR SettingEventParamsDone
	RTS
BossCandy2Params:
	LDA candyswitches
	AND #%00100000
	BNE BossCandyParamsDone ; if candy already gathered, skip event
	LDA #$4B
	STA eventnumber
	JSR SettingEventParamsDone
BossCandyParamsDone:
	RTS

SettingEventParamsDone:
	LDA buttons          ; if no buttons are pressed, it means that the logic is processed from CheckActionDots
	BEQ ActivateDots     ; so the real event is not happening
	LDA eventnumber
	CMP #$40             ; 1-39 - postevent (happens after text), 40 and more - initial event (happens before text)
	BCC PostEvent        ; post event (or noevent if 0)
	LDA #$06
	STA action
	RTS
PostEvent:
	LDA #$01
	STA action
	RTS

ActivateDots:
	INC dotsstate   ; 0 becomes 1
ClearEventParams:
	LDA #$00
	STA eventnumber
	STA textpartscounter
	RTS

BlockMovement:
	LDA buttons        ; blocks movement during action
	AND #%11110000
	STA buttons
	RTS

CheckTilesForEvent:
	; x coordinate in X, y coordinate in Y
	CPY currentYtile
	BNE EventFalse
	LDA direction
	CMP #$02
	BCS SkipExtraCheckForX ; if 2 or more
	CPX currentXtile       ; if cat looks to the side, check one x tile
	BEQ EventTrue          ; if looks up or down, check x and the next tile to the right
SkipExtraCheckForX:
	INX
	CPX currentXtile
	BNE EventFalse
EventTrue:
	LDA #$01
	RTS
EventFalse:
	LDA #$00
	RTS

StartButtonLogicSubroutine:
	LDA buttons_pressed
	AND #STARTBUTTON
	BEQ StartButtonNotPressed
	LDA location
	BEQ SetStartEvent
	CMP #$0B
	BEQ SetRestartEvent
StartButtonNotPressed:
	RTS

SetRestartEvent:
	LDA lives
	BEQ SkipSetRestartEvent ; no restart when no lives
	LDA #$06
	STA action
	LDA #$48
	STA eventnumber
	LDA #$00
	JSR sound_load
SkipSetRestartEvent:
	RTS

SetStartEvent:
	LDA #$00
	JSR sound_load
	LDA #$02
	STA eventwaitcounter
	LDA #$4C         ; event is triggered when you start the game
	STA eventnumber
	LDA #$06
	STA action
	RTS

TalkBeep:
	LDA talkbeepdelay
	BNE TalkBeepDone
	JSR DefineBeepTone
	CMP #$FF
	BEQ TalkBeepSkip
	JSR sound_load ; the song is stored in A at this point
	LDA #$04
	STA talkbeepdelay
TalkBeepSkip:
	RTS
TalkBeepDone:
	DEC talkbeepdelay
	RTS

DefineBeepTone:
	; the tone is defined based on the current cursor
	LDA textcursor
	CMP #$85
	BEQ SetCatBeep
	CMP #$64
	BEQ SetGrilBeep
	CMP #$74
	BEQ SetGrilBeep
	CMP #$76
	BEQ SetBossBeep
	CMP #$77
	BEQ SetBossBeep
	CMP #$86
	BEQ SetFellaBeep
	CMP #$75
	BEQ SetFellaBeep
	CMP #$65
	BEQ SetFellaBeep
	CMP #$87
	BEQ SetFellaBeep
	RTS
SetCatBeep:
	LDA #$0A
	RTS
SetGrilBeep:
	LDA #$0B
	RTS
SetBossBeep:
	LDA #$0C
	RTS
SetFellaBeep:
	LDA #$0D
	RTS
