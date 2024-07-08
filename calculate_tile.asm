CalculateTileInFrontOfCatSubroutine:
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
  TYA
  LSR A
  LSR A
  LSR A
  STA currentYtile     ; saving this value before multiplying it for future use in other subroutines
  RTS
