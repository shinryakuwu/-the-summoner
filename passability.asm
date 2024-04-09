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
  BEQ DefinePassibilityOfTile

IncludeEmptyTileRows:
  ; this logic is really tricky, it parses compressed bg data to utilize it properly

  ; compare current tile addr to $0F address
  ; if current tile addr < $0F addr, end the loop, jump to DefinePassibilityOfTile
  ; if current tile addr = $0F addr, end the loop, jump to TileIsNotPassable
  ; else keep iterating
  ; increment RAM addr to get attribute value ($0F address +1)
  ; result (updated current tile value) = current tile addr - (attribute value - 2)
  ; if result <= RAM address ($0F address +1), jump to TileIsNotPassable
  ; else keep iterating - loop ends when x = emptytilescount
  LDX #$00
IncludeEmptyTileRowsLoop:
  INX    ; need to start with x = 1
  TXA    ; transform x into a pointer
  ASL A
  TAY
  INY
CompareEmptyTileCurrTileHighAddr:
  LDA EMPTYTILEROWADDRESSES, y        ; get high byte of empty tiles attr (EMPTYBGTILEATTRIBUTE) address
  CMP currenttilehigh                 ; branch if high empty tiles attr address >= high current tile addr
  BCS CheckEmptyTileCurrTileEqual     ; if high empty tiles attr address < high current tile addr,
  DEY                                 ; then empty tiles attr address < current tile addr, so we keep the loop going
IncrementEmptyTileAddress:
  LDA EMPTYTILEROWADDRESSES, y        ; y should point at low empty tiles attr address at this point
  INC A
  STA EMPTYTILEROWADDRESSES, y
  BNE GetEmptyTilesAttrValue
  ; if a becomes 0, add carry and store in EMPTYTILEROWADDRESSES, y + 1
  INY
  LDA EMPTYTILEROWADDRESSES, y
  INC A
  STA EMPTYTILEROWADDRESSES, y
  DEY
GetEmptyTilesAttrValue:
  LDA [EMPTYTILEROWADDRESSES], y
  SEC
  SBC #$02
  STA emptytilesnumber  ; subtract 2 from empty tiles value and store it in emptytilesnumber
SubtractEmptyTilesAttrValue:
  LDA currenttilelow
  SEC
  SBC emptytilesnumber
  STA currenttilelow
  LDA currenttilehigh   ; subtract carry
  SBC #$00
  STA currenttilehigh
CompareResultAddrToEmptyTilesAttrAddr:
  INY
  LDA EMPTYTILEROWADDRESSES, y   ; get high byte of empty tiles value (EMPTYBGTILEATTRIBUTE+1) address
  CMP currenttilehigh            ; if high empty tiles value address < high current tile addr,
  BCC CompareXtoEmptytilescount  ; then empty tiles value address < current tile addr, so we keep the loop going
  DEY                            ; at this point high empty tiles value address => high current tile addr
  LDA EMPTYTILEROWADDRESSES, y   ; get low byte of empty tiles value (EMPTYBGTILEATTRIBUTE+1) address
  CMP currenttilelow             ; if low empty tiles value address >= low current tile addr
  BCS TileIsNotPassable          ; then empty tiles value address >= current tile addr, so the tile is not passable
  ; BCC - ram addr < curr
  ; BCS - ram addr >= curr
CompareXtoEmptytilescount:
  CPX emptytilescount           ; loop ends when x = emptytilescount
  BNE IncludeEmptyTileRowsLoop
  JMP DefinePassibilityOfTile


CheckEmptyTileCurrTileEqual:
  LDA EMPTYTILEROWADDRESSES, y        ; get high byte of empty tiles attr (EMPTYBGTILEATTRIBUTE) address
  CMP currenttilehigh                 ; if high empty tiles attr address != high current tile addr,
  BNE DefinePassibilityOfTile         ; then empty tiles attr address > current tile addr, move to DefinePassibilityOfTile
CompareEmptyTileCurrTileLowAddr:      ; high bytes are equal at this point
  DEY
  LDA EMPTYTILEROWADDRESSES, y        ; get low byte of empty tiles attr (EMPTYBGTILEATTRIBUTE) address
  CMP currenttilelow
  BEQ TileIsNotPassable               ; if empty tiles attr address = current tile addr, tile is not passable (pointer is at EMPTYBGTILEATTRIBUTE)
  ; TODO: check if works without this line
  CMP currenttilelow                  ; if low empty tiles attr address < low current tile addr,
  BCC IncrementEmptyTileAddress       ; then empty tiles attr address < current tile addr, go back to the loop
  ; else if empty tiles attr address > current tile addr, move to DefinePassibilityOfTile

DefinePassibilityOfTile:
  LDY #$00
  ; TODO: add logic to check for the empty tiles attribute
  LDA [currenttilelow], y
  CMP #$60           ; check if the tile is within the passable tiles in the tiletable (they currently end by address $60 but will change later)
  BCC TileIsPassable
TileIsNotPassable:
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
  ; LDX $0217          ; load horizontal coordinate of the cat's right bottom tile into X
  ; LDY $0214          ; load vertical coordinate of the cat's right bottom tile into Y
  ; JMP CalculateTileInFrontOfCat
  INC currenttilelow
  LDA currenttilehigh
  ADC #$00                               ; add 0 and carry from previous add
  STA currenttilehigh
  JMP DefinePassibilityOfTile
