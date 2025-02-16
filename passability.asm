CheckPassability:
  LDA walkbackwards
  BNE PassableForWalkBackwards

  LDX $0213          ; load horizontal coordinate of the cat's left bottom tile into X
  LDY $0210          ; load vertical coordinate of the cat's left bottom tile into Y

  LDA action         ; some checks specific for boss fight event
  CMP #$07
  BEQ BossFightPassability

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

BossFightPassability:
  LDA fightstate  ; at this point the boss is defeated
  CMP #$08
  BCS CalculateTileInFrontOfCat
  LDA direction
  CMP #$03
  BEQ BossFightBordersRight
  CMP #$01
  BNE CalculateTileInFrontOfCat
BossFightBordersUp:
  CPY #$6C
  BCC BordersReached
  JSR DefineDinoCompareCoordinate
  CPY dinocoordcompare
  BCS CalculateTileInFrontOfCat
  CPX #$81
  BCS BordersReached
  JMP CalculateTileInFrontOfCat
BossFightBordersRight:
  JSR DefineDinoCompareCoordinate
  DEC dinocoordcompare
  CPY dinocoordcompare
  BCS CalculateTileInFrontOfCat
  CPX #$80
  BCS BordersReached
  JMP CalculateTileInFrontOfCat

DefineDinoCompareCoordinate:
  LDA dinojumpcount ; this number indicates when boss becomes enraged
  BNE DinoCompareCoordinateEnraged
  LDA $028C         ; boss y coordinate
  STA dinocoordcompare
  RTS
DinoCompareCoordinateEnraged:
  LDA #BOSSENRAGEDPOSITION
  CLC
  ADC #$05
  STA dinocoordcompare
  RTS

CalculateTileInFrontOfCat:
  JSR CalculateTileInFrontOfCatSubroutine

MultiplyYpointerBy32:
  LDA currentYtile
  TAX                  ; preparing values for multiplication subroutine
  LDA #$20             ; here we set multiplier to 32 because (pointer to bg tiles + 32) = (Y coordinate + 1)
  JSR Multiply

AddYpointerToCurrentBg:
  CLC
  LDA currentbglow
  ADC mathresultlow
  STA currenttilelow
  LDA currentbghigh
  ADC mathresulthigh
  STA currenttilehigh

AddXpointerToCurrentBg:
  CLC
  LDA currentXtile
  ADC currenttilelow
  STA currenttilelow
  LDA currenttilehigh
  ADC #$00              ; add 0 and carry from previous add
  STA currenttilehigh

  LDA emptytilescount
  BEQ DefinePassabilityOfTile

IncludeEmptyTileRows:
  ; this logic is really tricky, it parses compressed bg data to utilize it properly

  ; compare current tile addr to $0F address
  ; if current tile addr <= $0F addr, end the loop, jump to DefinePassabilityOfTile
  ; else keep iterating
  ; increment RAM addr to get attribute value ($0F address +1)
  ; result (updated current tile value) = current tile addr - (attribute value - 2)
  ; if result <= RAM address ($0F address +1), jump to TileIsNotPassable
  ; else keep iterating - loop ends when x = emptytilescount
  LDX #$00
IncludeEmptyTileRowsLoop:
  INX    ; need to start with x = 1
  TXA    ; transform x into a pointer by multiplying it by 2
  ASL A
  TAY
  INY
CompareEmptyTileCurrTileHighAddr:
  ; BCC - ram addr < curr
  ; BCS - ram addr >= curr
  LDA EMPTYTILEROWADDRESSES, y        ; get high byte of empty tiles attr (EMPTYBGTILEATTRIBUTE) address
  CMP currenttilehigh                 ; if high empty tiles attr address < high current tile addr
  BCC IncrementEmptyTileAddress       ; then empty tiles attr address < current tile addr, so we keep the loop going
  BNE DefinePassabilityOfTile         ; if high empty tiles value address > high current tile addr, jump to DefinePassabilityOfTile
  DEY                                 ; at this point high empty tiles attr address = high current tile addr
  LDA EMPTYTILEROWADDRESSES, y        ; get low byte of empty tiles attr (EMPTYBGTILEATTRIBUTE) address
  CMP currenttilelow                  ; if low empty tiles attr address >= low current tile addr
  BCS DefinePassabilityOfTile         ; then empty tiles attr address >= current tile addr, jump to DefinePassabilityOfTile
  JMP IncrementEmptyTileAddress2      ; skip decreasing y pointer because we already did
IncrementEmptyTileAddress:
  DEY
IncrementEmptyTileAddress2:
  LDA EMPTYTILEROWADDRESSES, y   ; y should point at low empty tiles attr address at this point
  STA emptytilerowaddr
  INY
  LDA EMPTYTILEROWADDRESSES, y
  STA emptytilerowaddr+1
  INC emptytilerowaddr
  BNE GetEmptyTilesAttrValue     ; branch unless emptytilerowaddr equals zero
  INC emptytilerowaddr+1         ; add carry to high byte
GetEmptyTilesAttrValue:
  TYA                   ; move y to stack
  PHA
  LDY #$00
  LDA [emptytilerowaddr], y
  SEC
  SBC #$02
  STA emptytilesnumber  ; subtract 2 from empty tiles value and store it in emptytilesnumber
  PLA
  TAY                   ; restore y
SubtractEmptyTilesAttrValue:
  LDA currenttilelow
  SEC
  SBC emptytilesnumber
  STA currenttilelow
  LDA currenttilehigh   ; subtract carry
  SBC #$00
  STA currenttilehigh
CompareResultAddrToEmptyTilesAttrAddr:
  LDA EMPTYTILEROWADDRESSES, y   ; get high byte of empty tiles value (EMPTYBGTILEATTRIBUTE+1) address
  CMP currenttilehigh            ; if high empty tiles value address < high current tile addr,
  BCC CompareXtoEmptytilescount  ; then empty tiles value address < current tile addr, so we keep the loop going
  BNE TileIsNotPassable          ; high empty tiles value address > high current tile addr, so the tile is not passable
  DEY                            ; at this point high empty tiles value address = high current tile addr
  LDA EMPTYTILEROWADDRESSES, y   ; get low byte of empty tiles value (EMPTYBGTILEATTRIBUTE+1) address
  CMP currenttilelow             ; if low empty tiles value address >= low current tile addr
  BCS TileIsNotPassable          ; then empty tiles value address >= current tile addr, so the tile is not passable
CompareXtoEmptytilescount:
  CPX emptytilescount           ; loop ends when x = emptytilescount
  BNE IncludeEmptyTileRowsLoop
  ; else just move to DefinePassabilityOfTile

DefinePassabilityOfTile:
  LDY #$00
  LDA [currenttilelow], y
  CMP #EMPTYBGTILEATTRIBUTE
  BEQ TileIsNotPassable
  CMP #PASSABILITYSEPARATOR  ; check if the tile is within the passable tiles in the tiletable
  BCC TileIsPassable
TileIsNotPassable:
  LDY #$00
  JMP SetPassable
TileIsPassable:
  LDA passablecheck2     ; see if the passability check runs for second time
  CMP #$01
  BEQ SetPassableToTrue
  LDA direction          ; if direction is above or below, we would also check if bottom right cat tile is on a passable bg tile
  CMP #$02
  BCC CheckSecondCatTile ; if less than 2
SetPassableToTrue:
  LDY #$01
SetPassable:
  STY passable
  LDA #$00
  STA passablecheck2     ; nullify check counter for future use
  RTS

CheckSecondCatTile:
  LDA #$01
  STA passablecheck2           ; mark that the passability check is running for second time
  INC currenttilelow
  BNE DefinePassabilityOfTile
  INC currenttilehigh          ; if currenttilelow becomes 0, increment currenttilehigh too
  JMP DefinePassabilityOfTile
