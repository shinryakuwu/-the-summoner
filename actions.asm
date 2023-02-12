CheckAction:
  LDA buttons
  AND #%11000000
  BNE SetTextRenderParams
  RTS

SetTextRenderParams:
  LDA #$30
  STA textcompare
  LDA #LOW(texttest)
  STA currenttextlow
  LDA #HIGH(texttest)
  STA currenttexthigh
  LDA #$01
  STA action ; enable action
  RTS

PerformAction:
  LDA action
  BNE Action
  RTS

Action:
  LDA buttons    ; blocks movement
  AND #%11000000
  STA buttons

  JSR RenderText
  RTS
