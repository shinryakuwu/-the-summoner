Multiply:            ; a = multiplier 1, x = multiplier 2
  STA multiplier
  LDA #$00
  STA mathresulthigh ; clear this value from previous results
MultiplyAgain:
  CLC
  ADC multiplier
Multiply16bit:
  PHA                ; save the value in A by pushing it to stack
  LDA mathresulthigh
  ADC #$00           ; add 0 and carry from previous add
  STA mathresulthigh
  PLA                ; restore the saved value

  DEX
  BNE MultiplyAgain
  STA mathresultlow  ; results of calculation are stored in mathresultlow and optional mathresulthigh
  RTS