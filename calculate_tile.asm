CalculateTileInFrontOfCat:
  LDA direction
  BEQ TileBelow ; if equals zero
  CMP #$01
  BEQ TileAbove
  CMP #$02
  BEQ TileLeft
  CMP #$03
  BEQ TileRight

TileBelow:            ; do some math to determine the sprite next to the cat based on his direction
  TYA
  CLC
  ADC #$08
  TAY
  TXA
  CLC
  ADC #$04
  JMP CalculateBgPointer
TileAbove:
  TYA
  CLC
  ADC #$03
  TAY
  TXA
  CLC
  ADC #$04
  JMP CalculateBgPointer
TileLeft:
  TYA
  CLC
  ADC #$06
  TAY
  TXA
  JMP CalculateBgPointer
TileRight:
  TYA
  CLC
  ADC #$06
  TAY
  TXA
  CLC
  ADC #$10

CalculateBgPointer:    ; vert is stored in Y, horiz is stored in A
  LSR A                ; need to devide both vert and horiz values by 8
  LSR A 
  LSR A
  STA currentXtile
  STA $66              ; for debugging purposes
  TYA
  LSR A
  LSR A
  LSR A
  STA currentYtile     ; saving this value before multiplying it for future use in other subroutines
  STA $67              ; for debugging purposes
  TAX                  ; preparing values for multiplication subroutine
  LDA #$20             ; here we set multiplier to 32 because (pointer to bg tiles + 32) = (Y coordinate + 1)
  JSR Multiply
  RTS
