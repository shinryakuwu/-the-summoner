CheckAction:
  LDA action
  BEQ CheckActionButtons ; if zero action state
  CMP #$02
  BEQ ActionTimeout
  CMP #$03
  BEQ EndOfAction
  RTS

CheckActionButtons:
  LDA buttons
  AND #ACTIONBUTTONS
  BNE BlockMovement
  RTS

ActionTimeout:
  LDA buttons             ; state 2 leads to state 3 which returns to 0 (or next dialogue part)
  AND #ACTIONBUTTONS       ; only when action buttons are not pressed
  BEQ SkipActionTimeout
  LDA #$03
  STA action
  RTS

SkipActionTimeout:
  JSR BlockButtons
  RTS

EndOfAction:
  ; if text finished rendering and action button is pressed, clear text and disable action or initiate rendering next text part
  LDA buttons
  AND #ACTIONBUTTONS
  BNE SkipEndOfAction
  JSR ClearTextSection
  LDA textpartscounter
  BNE NextTextPart         ; if textpartscounter is not zero, set action to 1, decrement textpartscounter
  LDA #$00
  STA action
  STA buttons              ; disable buttons in this frame because we will render empty dialogue section
SkipEndOfAction:
  RTS

NextTextPart:
  DEC textpartscounter
  LDA #$01
  STA action ; enable action
  ; need to find out how to set textcompare here (maybe go through initial action check + add text part condition there)
  ; or replace textcompare with a stop symbol via tiles file
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
  CMP #$01
  BEQ SetTextRenderParams
  RTS

SetTextRenderParams:
  ; LDA #$30
  ; STA textcompare
  LDA #LOW(texttest)
  STA currenttextlow
  LDA #HIGH(texttest)
  STA currenttexthigh
  LDA #$01
  STA action           ; enable action   !!! move this code somewhere else to DRY out
  STA textpartscounter ; text will be rendered in two parts
  RTS

PerformAction: ; maybe move it to CheckAction
  LDA action
  CMP #$01
  BEQ Action
  RTS

BlockButtons:
  LDA #$00    ; blocks buttons if action is in process
  STA buttons
  RTS

Action:
  JSR BlockButtons
  JSR RenderText
  RTS
