CheckAction:
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
  LDA #$00
  STA cleartextstate
  LDA #$06                 ; trigger processing ClearTextSectionSubroutine from the next frame
  STA action
ActionButtonOnHold:
  RTS

ClearTextSectionDone:
  JSR BlockButtons
  LDA textpartscounter
  BNE NextTextPart         ; if textpartscounter is not zero, set action to 1, decrement textpartscounter
  JSR NonTextEvents
  RTS

InitialTextEvent:
  LDA #$01
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
  JSR CalculateTileInFrontOfCat
  ; add conditions for actions here
  LDA location
  BEQ Village1Events
  CMP #$01
  BEQ CatHouseEvents
  CMP #$03
  BEQ SkeletonHouseEvents
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

Village1EventsSubroutine:
  LDX #$1B
  LDY #$05
  JSR CheckTilesForEvent
  BNE StartGhostParams
  LDX #$1C
  LDY #$05
  JSR CheckTilesForEvent
  BNE StartGhostParams
  RTS

StartGhostParams:
  LDA #LOW(startghost)
  STA currenttextlow
  LDA #HIGH(startghost)
  STA currenttexthigh
  JSR SettingEventParamsDone
  RTS

CatHouseEventsSubroutine:
  LDX #$14
  LDY #$07
  JSR CheckTilesForEvent
  BNE ComputerParams
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
  ; set textpartscounter here if needed
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
  LDA #$01
  STA eventnumber
  JSR SettingEventParamsDone
  RTS

SettingEventParamsDone:
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
  BEQ SkipExtraChechForX ; to do: check if can compare by 'more than 1'
  CMP #$03
  BEQ SkipExtraChechForX
  TXA                    ; if cat looks to the side, check one x tile
  CMP currentXtile       ; if looks up or down, check x and the next tile to the right
  BEQ EventTrue
SkipExtraChechForX:
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
