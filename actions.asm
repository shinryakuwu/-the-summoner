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
  LDA #$00
  STA movement ; disable movement
  RTS

PerformAction:
  LDA movement
  BEQ Action
  RTS

Action:
  JSR RenderText
  RTS
