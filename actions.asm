CheckAction:
  LDA action
  BEQ CheckActionButtons ; if zero action state
  CMP #$01
  BEQ Action
  CMP #$02
  BEQ ActionTimeout
  CMP #$03
  BEQ CheckActionButtonReleased
  CMP #$04
  BEQ CheckActionButtonReleased
  RTS

Action:
  JSR PerformAction
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
  CMP #$04                 ; if state is 4, it means that the initial action will start in the next frame
  BEQ InitialAction
  JSR ClearTextSection
  LDA textpartscounter
  BNE NextTextPart         ; if textpartscounter is not zero, set action to 1, decrement textpartscounter
  LDA #$00
  STA action
ActionButtonOnHold:
  RTS

InitialAction:
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
SetDefaultTextCursor: ; default is cat face, redefine it later if needed
  LDA #$85
  STA textcursor
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
  LDX #$1B
  LDY #$05
  JSR CheckTilesForEvent
  BNE StartGhostParams
  LDX #$1C
  LDY #$05
  JSR CheckTilesForEvent
  BNE StartGhostParams
  RTS
CatHouseEvents:
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

SkeletonHouseEvents:
  LDX #$09
  LDY #$10
  JSR CheckTilesForEvent
  BNE SkeletonParams
  RTS

StartGhostParams:
  LDA #LOW(startghost)
  STA currenttextlow
  LDA #HIGH(startghost)
  STA currenttexthigh
  LDA #$86
  STA textcursor
  JMP SettingEventParamsDone
ComputerParams:
  LDA #LOW(computer)
  STA currenttextlow
  LDA #HIGH(computer)
  STA currenttexthigh
  ; set textpartscounter here if needed
  JMP SettingEventParamsDone
ColaParams:
  LDA #LOW(cola)
  STA currenttextlow
  LDA #HIGH(cola)
  STA currenttexthigh
  JMP SettingEventParamsDone
CassetteParams:
  LDA #LOW(cassette)
  STA currenttextlow
  LDA #HIGH(cassette)
  STA currenttexthigh
  JMP SettingEventParamsDone
FursuitParams:
  LDA #LOW(fursuit)
  STA currenttextlow
  LDA #HIGH(fursuit)
  STA currenttexthigh
  JMP SettingEventParamsDone
FanfictionParams:
  LDA #LOW(fanfiction)
  STA currenttextlow
  LDA #HIGH(fanfiction)
  STA currenttexthigh
  JMP SettingEventParamsDone
SkeletonParams:
  LDA #LOW(skeleton)
  STA currenttextlow
  LDA #HIGH(skeleton)
  STA currenttexthigh
  LDA #$64
  STA textcursor
SettingEventParamsDone:
  LDA #$04
  STA action
  RTS

BlockButtons:
  LDA #$00    ; blocks buttons if action is in process
  STA buttons
  RTS

PerformAction:
  JSR BlockButtons
  JSR RenderText
  RTS

CheckTilesForEvent:
  ; x coordinate in X, y coordinate in Y
  TYA
  CMP currentYtile
  BNE EventFalse
  LDA direction
  CMP #$02
  BEQ SkipExtraChechForX ; check if can compare by 'more than 1'
  CMP #$03
  BEQ SkipExtraChechForX
  TXA
  CMP currentXtile
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
