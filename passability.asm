CheckPassability:
  LDX $0213          ; load horizontal coordinate of the cat's left bottom tile into X
  LDY $0210          ; load vertical coordinate of the cat's left bottom tile into Y
CheckPassabilityAgain:
  LDA direction
  CMP #$00
  BEQ TileBelow
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
  ADC #$07
  JMP CalculateBgPointer
TileAbove:
  DEY
  TXA
  CLC
  ADC #$07
  JMP CalculateBgPointer
TileLeft:
  TXA
  JMP CalculateBgPointer
TileRight:
  TXA
  CLC
  ADC #$10

CalculateBgPointer:    ; vert is stored in Y, horiz is stored in A
  LSR A                ; need to devide both vert and horiz values by 8
  LSR A 
  LSR A
  STA currentXtile
  STA $66 ; !!!
  TYA
  LSR A
  LSR A
  LSR A
  STA currentYtile     ; saving this value before multiplying it for future use in other subroutines
  STA $67 ; !!!
  TAX                  ; preparing values for multiplication subroutine
  LDA #$20             ; here we set multiplier to 32 because (pointer to bg tiles + 32) = (Y coordinate + 1)
  JSR Multiply

AddingYpointerToCurrentBg:
  CLC
  LDA currentbglow
  ADC mathresultlow
  STA currentYtilelow
  LDA currentbghigh
  ADC mathresulthigh
  STA currentYtilehigh

FinallyDefiningPassibilityOfTile:
  LDY currentXtile
  LDA [currentYtilelow], y
  CMP #$60           ; check if the tile is within the passable tiles in the tiletable (they currently end by address $60 but will change later)
  BCC TileIsPassable
  LDA #$00
  STA passablecheck2 ; nullify check counter for future use
  LDA #$00
  STA passable       ; set passable to false
  RTS
TileIsPassable:
  LDA passablecheck2 ; see if the passability check runs for second time
  CMP #$01
  BEQ SetPassableToTrue
  LDA direction
  CMP #$00
  BEQ CheckSecondCatTile
  CMP #$01
  BEQ CheckSecondCatTile ; if direction is above or below, we would also check if bottom right cat tile is on a passable bg tile

SetPassableToTrue:
  LDA #$00
  STA passablecheck2 ; nullify check counter for future use
  LDA #$01
  STA passable
  RTS

CheckSecondCatTile:
  LDA #$01
  STA passablecheck2 ; mark that the passability check is running for second time
  LDX $0217          ; load horizontal coordinate of the cat's right bottom tile into X
  LDY $0214          ; load vertical coordinate of the cat's right bottom tile into Y
  JMP CheckPassabilityAgain
