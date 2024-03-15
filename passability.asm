CheckPassability:
  LDA walkbackwards
  BNE PassableForWalkBackwards

  LDX $0213          ; load horizontal coordinate of the cat's left bottom tile into X
  LDY $0210          ; load vertical coordinate of the cat's left bottom tile into Y

  LDA direction
  CMP #$02
  BEQ CheckMapBordersLeft
  CMP #$03
  BEQ CheckMapBordersRight
  JMP CalculateTileInFrontOfCat
CheckMapBordersLeft:
  CPX #$00
  BEQ BordersReached
  JMP CalculateTileInFrontOfCat
CheckMapBordersRight:
  CPX #$F0
  BEQ BordersReached
  JMP CalculateTileInFrontOfCat
BordersReached:
  LDA #$00
  STA passable       ; set passable to false
  RTS

PassableForWalkBackwards:
  LDA #$01
  STA passable       ; set passable to true
  RTS

CalculateTileInFrontOfCat:
  JSR CalculateTileInFrontOfCatSubroutine

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
  LDA direction          ; if direction is above or below, we would also check if bottom right cat tile is on a passable bg tile
  CMP #$02
  BCC CheckSecondCatTile ; if less than 2
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
  JMP CalculateTileInFrontOfCat
