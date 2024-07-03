CheckAction:
	LDA eventwaitcounter
	BNE EventWait          ; do nothing in this frame unless eventwaitcounter is zero
	LDA animatecounter
	BNE CanCheckForAction  ; fix for blinking screen when action logic is happening during the animation frame
	LDA action
	BEQ CanCheckForAction  ; allow movement only when no action is happening
EventWaitDone:
	JSR BlockButtons
	RTS

EventWait:
	DEC eventwaitcounter
	JMP EventWaitDone

CanCheckForAction:
	LDA action
	BEQ CheckActionButtons ; if zero action state
	CMP #$01
	BEQ PerformTextEvent
	CMP #$02
	BEQ ActionTimeout
	CMP #$03
	BEQ CheckActionButtonReleased
	CMP #$04
	BEQ CheckActionButtonReleased
	CMP #$05
	BEQ PerformNonTextEvent
	CMP #$06
	BEQ ClearTextSection
	CMP #$07
	BEQ ClearTextSectionDone
	CMP #$08
	BEQ CheckActionButtonReleased
	RTS

PerformTextEvent:
	JSR BlockButtons
	JSR RenderText
	RTS

PerformNonTextEvent:
	JSR BlockButtons
	JSR NonTextEvents
	RTS

ClearTextSection:
	JSR BlockButtons
	JSR ClearTextSectionSubroutine
	RTS

CheckActionButtons:
	LDA buttons
	AND #ACTIONBUTTONS
	BNE BlockMovement
	RTS

ActionTimeout:
	LDA buttons             ; the part of the action is over, keep waiting for action button to be pressed at this step
	AND #ACTIONBUTTONS      ; when action button is pressed, state 2 leads to state 3 which returns to 0 (or next dialogue part)
	BEQ SkipActionTimeout   ; only when action button is released
	LDA #$03
	STA action
SkipActionTimeout:
	JSR BlockButtons
	RTS

CheckActionButtonReleased:
	; if text finished rendering and action button is released, clear text and disable action or initiate rendering next text part
	LDA buttons
	AND #ACTIONBUTTONS
	STA buttons              ; disable movement for this frame
	BNE ActionButtonOnHold
	LDA action
	CMP #$04                 ; if state is 4, it means that the initial text event will start in the next frame
	BEQ InitialTextEvent
	CMP #$08                 ; if state is 8, it means that the initial non-text event will start in the next frame
	BEQ InitialNonTextEvent
	LDA #$00
	STA cleartextstate
	LDA #$06                 ; trigger processing ClearTextSectionSubroutine from the next frame
	STA action
ActionButtonOnHold:
	RTS

ClearTextSectionDone:
	JSR BlockButtons
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

InitialTextEvent:
	LDA #$01
	STA action
	RTS

InitialNonTextEvent:
	LDA #$06
	STA action
	RTS

NextTextPart:
	DEC textpartscounter
	LDA #$01
	STA action ; enable action
	RTS

BlockMovement:
	LDA buttons        ; blocks movement if action button is pressed
	AND #ACTIONBUTTONS
	STA buttons
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
	CMP #$08
	BEQ ParkEvents
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
	LDA #LOW(startghost)
	STA currenttextlow
	LDA #HIGH(startghost)
	STA currenttexthigh
	JSR SettingEventParamsDone
	RTS

OldLadyParams:
	LDA #$40
	STA eventnumber
	LDA #$15
	STA movecounter
	JSR SettingEventParamsDone
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
	LDX #$09
	LDY #$10
	JSR CheckTilesForEvent
	BNE SkeletonParams
	LDX #$15
	LDY #$07
	JSR CheckTilesForEvent
	BNE CandymanParams
	RTS

SkeletonParams:
	LDA #LOW(skeleton)
	STA currenttextlow
	LDA #HIGH(skeleton)
	STA currenttexthigh
	JSR SettingEventParamsDone
	RTS
CandymanParams:
	LDA #LOW(candyman)
	STA currenttextlow
	LDA #HIGH(candyman)
	STA currenttexthigh
	LDA #$01
	STA textpartscounter
	STA eventnumber
	JSR SettingEventParamsDone
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
	LDA #LOW(corporations)
	STA currenttextlow
	LDA #HIGH(corporations)
	STA currenttexthigh
	LDA #$02
	STA textpartscounter
	JSR SettingEventParamsDone
	RTS

ParkEventsSubroutine:
	LDX #$16
	LDY #$09
	JSR CheckTilesForEvent
	BNE OfficeWarpParams
	RTS

OfficeWarpParams:
	LDA #$41
	STA eventnumber
	JSR SettingEventParamsDone
	RTS

SettingEventParamsDone:
	LDA eventnumber
	CMP #$40             ; 1-39 - postevent (happens after text), 40 and more - initial event (happens before text)
	BCC PostEvent ; post event (or noevent if 0)
	LDA #$08
	STA action
	RTS
PostEvent:
	LDA #$04
	STA action
	RTS

BlockButtons:
	LDA #$00    ; blocks buttons if action is in process
	STA buttons
	RTS

CheckTilesForEvent:
	; x coordinate in X, y coordinate in Y
	TYA
	CMP currentYtile
	BNE EventFalse
	LDA direction
	CMP #$02
	BCS SkipExtraCheckForX ; if 2 or more
	TXA                    ; if cat looks to the side, check one x tile
	CMP currentXtile       ; if looks up or down, check x and the next tile to the right
	BEQ EventTrue
SkipExtraCheckForX:
	TXA
	CLC
	ADC #$01
	CMP currentXtile
	BNE EventFalse
EventTrue:
	LDA #$01
	RTS
EventFalse:
	LDA #$00
	RTS
