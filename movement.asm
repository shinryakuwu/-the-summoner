CheckMovement:
  LDA location      ; need to skip one frame in skeleton house to change background attributes
  CMP #$03          ; TODO: consider refactoring here
  BNE MovementSubroutine
  LDA animatecounter
  BNE MovementSubroutine
  RTS

MovementSubroutine:
  LDA buttons
  AND #%00001111    ; check only the state of the arrow buttons
  BNE CatMoves      ; branch if any button is pressed
  JMP StaticOrNotPassable
CatMoves:
  LDA #$00
  STA staticrender
CheckMVup:
  LDA buttons
  AND #MVUP
  BEQ CheckMVdown
  LDA #$01
  STA direction     ; direction is set to 'up'
  LDA #$00          ; decrement via transform loop
  STA trnsfrm
  LDA #$18          ; compare pointer to this number via transform loop
  STA trnsfrmcompare
  LDX #$00
  JSR TransformIfPassable
CheckMVdown:
  LDA buttons
  AND #MVDOWN
  BEQ CheckMVleft
  LDA #$00
  STA direction     ; direction is set to 'down'
  LDA #$01          ; increment via transform loop
  STA trnsfrm
  LDA #$18          ; compare pointer to this number via transform loop
  STA trnsfrmcompare
  LDX #$00
  JSR TransformIfPassable
CheckMVleft:
  LDA buttons
  AND #MVLEFT
  BEQ CheckMVright
  LDA #$02
  STA direction     ; direction is set to 'left'
  LDA #$00          ; decrement via transform loop
  STA trnsfrm
  LDA #$1B          ; compare pointer to this number via transform loop
  STA trnsfrmcompare
  LDX #$03
  JSR TransformIfPassable
CheckMVright:
  LDA buttons
  AND #MVRIGHT
  BEQ CheckMVdone
  LDA #$03
  STA direction     ; direction is set to 'right'
  LDA #$01          ; increment via transform loop
  STA trnsfrm
  LDA #$1B          ; compare pointer to this number via transform loop
  STA trnsfrmcompare
  LDX #$03
  JSR TransformIfPassable
CheckMVdone:
  JMP CompareDirToDir2
CompareDirToDir2Done:
  JSR DetermineDirection
  JSR SetRenderParameters
  LDA #$00
  STA mvcounter     ; set animation counter to 0 when direction changes
  STA framenum      ; frame number = 0
  LDA direction
  STA direction2
SkipRender:
  JSR CheckAnimateCat
  RTS

StaticOrNotPassable:
  LDA #$00
  STA mvcounter     ; set animation counter to 0 when nothing is pressed
  STA framenum      ; frame number = 0
  LDA #$01
  STA staticrender
  JSR DetermineDirection
  JSR SetRenderParameters
  RTS


CompareDirToDir2:
  LDA direction       ; finding out if the direction changed since the last render
  CMP direction2
  BEQ SkipRender
  JMP CompareDirToDir2Done


DetermineDirection:
  LDA direction
  BEQ RenderCatDown ; if equals zero
  CMP #$01
  BEQ RenderCatUp
  CMP #$02
  BEQ RenderCatLeft
  CMP #$03
  BEQ RenderCatRight

RenderCatUp:
  LDA #LOW(back)
  STA cattileslow
  LDA #HIGH(back)
  STA cattileshigh
  RTS
RenderCatDown:
  LDA #LOW(front)
  STA cattileslow
  LDA #HIGH(front)
  STA cattileshigh
  RTS
RenderCatLeft:
  LDA #LOW(left)
  STA cattileslow
  LDA #HIGH(left)
  STA cattileshigh
  RTS
RenderCatRight:
  LDA #LOW(right)
  STA cattileslow
  LDA #HIGH(right)
  STA cattileshigh
  RTS

SetRenderParameters:    ; setting parameters to load tiles into PPU
  LDA #$02
  STA trnsfrm
  LDA staticrender
  CMP #$01
  BEQ StaticRenderParameters
  LDA direction
  CMP #$01
  BEQ UpRenderParameters
  LDA #$11              ; load only 4 tiles if cat moves
  STA trnsfrmcompare
RenderParametersElse:
  LDX #$01
  LDY #$00
  JSR ObjectTransformLoop
  RTS

StaticRenderParameters:
  LDA #$19              ; load all tiles if static
  STA trnsfrmcompare
  JMP RenderParametersElse

UpRenderParameters:
  LDA #$09              ; load only 2 tiles if up movement
  STA trnsfrmcompare
  JMP RenderParametersElse

SetRenderParameters2:   ; setting parameters to load all tile attributes into PPU
  LDA #$03
  STA trnsfrm
  LDA #$1A
  STA trnsfrmcompare
  LDX #$02
  LDY #$06
  JMP ObjectTransformLoop

SetRenderParameters3:   ; setting parameters for warp
  LDA #$05
  STA trnsfrm
  LDA #$1B
  STA trnsfrmcompare
  LDX #$03
  LDY #$06 ; might be unnecessary
  JMP ObjectTransformLoop

TransformIfPassable:
  TXA
  PHA
  JSR CheckPassability     ; jump to subroutine to define if the tile next to the cat is passable
  PLA
  TAX
  LDA passable
  BNE ObjectTransformLoop  ; if the tile is passable, move to transform subroutine
  RTS

ObjectTransformLoop:       ; main sprite transform subroutine
  LDA trnsfrm
  BEQ DecrementCoordinates ; if equals zero
  CMP #$01
  BEQ IncrementCoordinates
  CMP #$02
  BEQ RenderObject
  CMP #$03
  BEQ RenderObject
  CMP #$04
  BEQ WarpObject
  CMP #$05
  BEQ WarpObject
  CMP #$06
  BEQ ChangeGraphics
TrnsfrmBranchDone:
  INX
  INX
  INX
  INX
  CPX trnsfrmcompare
  BNE ObjectTransformLoop
  LDA #$02              ; if trnsfrm state = 2, go through additional loop
  CMP trnsfrm
  BEQ SetRenderParameters2
  LDA #$04              ; if trnsfrm state = 4, go through additional loop
  CMP trnsfrm
  BEQ SetRenderParameters3
  RTS

DecrementCoordinates:
  LDA walkbackwards
  BNE ReallyIncrement
ReallyDecrement:
  DEC $0200, x
  JMP TrnsfrmBranchDone
IncrementCoordinates:
  LDA walkbackwards
  BNE ReallyDecrement
ReallyIncrement:
  INC $0200, x
  JMP TrnsfrmBranchDone
RenderObject: ; render cat?
  LDA [cattileslow], y
  STA $0200, x
  INY
  JMP TrnsfrmBranchDone
WarpObject:
  LDA [warpXYlow], y
  STA $0200, x
  INY
  JMP TrnsfrmBranchDone
ChangeGraphics: ; it can change both tile address and tile attribute
  LDA switchtile
  STA $0200, x
  JMP TrnsfrmBranchDone


CheckAnimateCat:
  LDA mvcounter
  BEQ AnimateCat   ; animate only when counter = 0
  DEC mvcounter    ; if not 0, decrement counter
  RTS
AnimateCat:
  LDA #CATANIMATIONSPEED  ; renew the counter
  STA mvcounter
  LDA framenum            ; frame number will be reset when reaches $03
  CMP #$03
  BNE SetAnimationParameters
  LDA #$FF                ; it's technically setting framenum to zero since the next step is INC
  STA framenum

SetAnimationParameters:
  INC framenum         ; increment frame number
  LDA #$03             ; setting the state for the main transform loop
  STA trnsfrm
  LDA #$19             ; the main transform loop will stop when X reaches this number
  STA trnsfrmcompare
  LDA direction
  CMP #$01
  BEQ SetAnimationParametersUp     ; branch if up movement
  ; these parameters will apply for all animations except for the up movement  
  LDX #$11             ; setting the x pointer to reach the 5th tile of the cat
  LDA framenum
  ASL A                ; multiply by 2
  JMP SetAnimationParametersAlmostDone
SetAnimationParametersUp:
  LDX #$09             ; setting the x pointer to reach the 3rd tile of the cat
  LDA framenum
  ASL A                ; multiply by 4
  ASL A
SetAnimationParametersAlmostDone:
  CLC
  ADC #$0C             ; adding the number to reach the animation tiles via the db
  TAY                  ; frame number is transformed into a pointer to the cat tile db
  JSR ObjectTransformLoop
  RTS
