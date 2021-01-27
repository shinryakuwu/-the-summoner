  .inesprg 1   ; 1x 16KB PRG code
  .ineschr 1   ; 1x  8KB CHR data
  .inesmap 0   ; mapper 0 = NROM, no bank swapping
  .inesmir 1   ; background mirroring

;; DECLARE SOME VARIABLES HERE
  .rsset $0000  ;;start variables at ram location 0
  
buttons         .rs 1  ; .rs 1 means reserve one byte of space, store button state in this variable
                       ; A B select start up down left right
direction       .rs 1  ; either down(0) up(1) left(2) of right(3)
direction2      .rs 1  ; used to compare to direction variable
mvcounter       .rs 1  ; counter for movement animation
framenum        .rs 1  ; number of the current animation frame
trnsfrm         .rs 1  ; tile transform state variable
trnsfrmcompare  .rs 1  ; additional variable for main transform subroutine
cattileslow     .rs 1  ; used to address the needed tile set
cattileshigh    .rs 1
staticrender    .rs 1  ; either true(1) or false(0)
currentbglow    .rs 1  ; 16-bit variable to point to current background
currentbghigh   .rs 1
passable        .rs 1  ; either passable(1) or not(0)
multiplier      .rs 1  ; variable for multiplication subroutine
mathresultlow   .rs 1  ; 16-bit variable for storing multiplication result
mathresulthigh  .rs 1
currentXtile    .rs 1  ; variable for determining the bg tile next to the cat


;; DECLARE SOME CONSTANTS HERE

MVRIGHT = %00000001
MVLEFT = %00000010
MVDOWN = %00000100
MVUP = %00001000
CATANIMATIONSPEED = $0A

;;;;;;;;;;;;;;;

    
  .bank 0
  .org $C000

vblankwait:
  BIT $2002
  BPL vblankwait
  RTS

LoadBackground:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$20
  STA $2006             ; write the high byte of $2000 address
  LDA #$00
  STA $2006             ; write the low byte of $2000 address
  
  LDX #$00            ; start at pointer + 0
  LDY #$00
OutsideLoop:
  
InsideLoop:
  LDA [currentbglow], y  ; copy one background byte from address in pointer plus Y
  STA $2007           ; this runs 256 * 4 times
  INY                 ; inside loop counter
  CPY #$00
  BNE InsideLoop      ; run the inside loop 256 times before continuing down
  
  INC currentbghigh       ; low byte went 0 to 256, so high byte needs to be changed now
  INX
  CPX #$04
  BNE OutsideLoop     ; run the outside loop 256 times before continuing down
  RTS

RESET:
  SEI          ; disable IRQs
  CLD          ; disable decimal mode
  LDX #$40
  STX $4017    ; disable APU frame IRQ
  LDX #$FF
  TXS          ; Set up stack
  INX          ; now X = 0
  STX $2000    ; disable NMI
  STX $2001    ; disable rendering
  STX $4010    ; disable DMC IRQs

  JSR vblankwait       ; First wait for vblank to make sure PPU is ready

clrmem:
  LDA #$00
  STA $0000, x
  STA $0100, x
  STA $0200, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FE
  STA $0300, x
  INX
  BNE clrmem
   
  JSR vblankwait      ; Second wait for vblank, PPU is ready after this


LoadPalettes:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006             ; write the high byte of $3F00 address
  LDA #$00
  STA $2006             ; write the low byte of $3F00 address
  LDX #$00              ; start out at 0
LoadPalettesLoop:
  LDA palette, x        ; load data from address (palette + the value in x)
                          ; 1st time through loop it will load palette+0
                          ; 2nd time through loop it will load palette+1
                          ; 3rd time through loop it will load palette+2
                          ; etc
  STA $2007             ; write to PPU
  INX                   ; X = X + 1
  CPX #$20              ; Compare X to hex $10, decimal 16 - copying 16 bytes = 4 sprites
  BNE LoadPalettesLoop  ; Branch to LoadPalettesLoop if compare was Not Equal to zero
                        ; if compare was equal to 32, keep going down



LoadSprites:
  LDX #$00              ; start at 0
LoadSpritesLoop:
  LDA sprites, x        ; load data from address (sprites +  x)
  STA $0200, x          ; store into RAM address ($0200 + x)
  INX                   ; X = X + 1
  CPX #$28              ; Compare X to hex $20, decimal 32
  BNE LoadSpritesLoop   ; Branch to LoadSpritesLoop if compare was Not Equal to zero
                        ; if compare was equal to 32, keep going down

SetDefaultBackground:
  LDA #LOW(village1)
  STA currentbglow       ; put the low byte of the address of background into pointer
  LDA #HIGH(village1)
  STA currentbghigh      ; put the high byte of the address into pointer
  PHA                    ; save the high byte bg value 

  JSR LoadBackground
  PLA                    ; restore the high byte bg value 
  STA currentbghigh

              
LoadAttribute:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$23
  STA $2006             ; write the high byte of $23C0 address
  LDA #$C0
  STA $2006             ; write the low byte of $23C0 address
  LDX #$00              ; start out at 0
  LDY #$00
LoadAttributeLoop:
  ;LDA attribute, x      ; load data from address (attribute + the value in x)
  STX $2007              ; write to PPU
  ;INX                   ; X = X + 1
  INY
  CPY #$30               ; load 0 to bg attributes 48 times
  BNE LoadAttributeLoop  ; Branch to LoadAttributeLoop if compare was Not Equal to zero
           

  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000

  LDA #%00011110   ; enable sprites
  STA $2001

Forever:
  JMP Forever     ;jump back to Forever, infinite loop
  
 

NMI:
  LDA #$00
  STA $2003       ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014       ; set the high byte (02) of the RAM address, start the transfer


  ;;This is the PPU clean up section, so rendering the next frame starts properly.
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000
  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA $2001
  LDA #$00         ;tell the ppu there is no background scrolling
  STA $2005
  STA $2005

  JSR ReadController

  JSR CheckMovement

  
  RTI             ; return from interrupt

ReadController:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016
  LDX #$08
ReadControllerLoop:
  LDA $4016
  LSR A           ; bit0 -> Carry
  ROL buttons     ; bit0 <- Carry
  DEX
  BNE ReadControllerLoop
  RTS

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
  ADC #$00            ; add 0 and carry from previous add
  STA mathresulthigh
  PLA                ; restore the saved value

  DEX
  BNE MultiplyAgain
  STA mathresultlow    ; results of calculation are stored in mathresultlow and optional mathresulthigh
  RTS



CheckPassability:
  LDX $0213          ; load horizontal coordinate of the cat's bottom tile into X
  STX $55 ;!!!!
  LDY $0210          ; load vertical coordinate of the cat's bottom tile into Y
  STY $56 ;!!!!
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
  JMP CalculateBgPointer
TileAbove:
  DEY
  TXA
  JMP CalculateBgPointer
TileLeft:
  DEX
  TXA
  JMP CalculateBgPointer
TileRight:
  TXA
  CLC
  ADC #$10

CalculateBgPointer:    ; vert is stored in Y, horiz is stored in A
  STA $57 ;!!!
  STY $58 ;!!!
  LSR A                ; need to devide both vert and horiz values by 8
  LSR A 
  LSR A
  STA currentXtile
  STA $59 ;!!!
  TYA
  LSR A
  LSR A
  LSR A
  STA $5A ;!!!
  TAX                  ; preparing values for multiplication subroutine
  LDA #$20
  JSR Multiply

AddingYpointerToCurrentBg:
  LDA currentbglow ;!!!
  STA $5F ;!!!
  LDA currentbghigh ;!!!
  STA $60 ;!!!
  LDA mathresultlow ;!!!
  STA $5D ;!!!
  LDA mathresulthigh ;!!!
  STA $5E ;!!!

  CLC
  LDA currentbglow
  ADC mathresultlow
  STA mathresultlow
  STA $5B ;!!!
  LDA currentbghigh
  ADC mathresulthigh
  STA mathresulthigh
  STA $5C ;!!!

FinallyDefiningPassibilityOfTile:
  LDY currentXtile
  LDA [mathresultlow], y
  STA $61 ;!!!!
  CMP #$90          ; check if the tile is within the passable tiles in the tiletable (they currently end by address $90 but will change later)
  BCC TileIsPassable
  LDA #$00
  STA passable
  RTS
TileIsPassable:
  LDA #$01
  STA passable
  RTS

CheckMovement:
  LDA buttons
  AND #%00001111    ; check only the state of the arrow buttons
  CMP #$00
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
  LDA #$18          ; compare pointer to $18 via transform loop
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
  LDA #$18          ; compare pointer to $18 via transform loop
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
  LDA #$1B          ; compare pointer to $1B via transform loop
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
  LDA #$1B          ; compare pointer to $1B via transform loop
  STA trnsfrmcompare
  LDX #$03
  JSR TransformIfPassable
CheckMVdone:
  ;LDA passable
  ;CMP #$00
  ;BEQ StaticOrNotPassable
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
  CMP #$00
  BEQ RenderCatDown
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
  JSR CatTransformLoop
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
  JMP CatTransformLoop

TransformIfPassable:
  TXA
  PHA
  JSR CheckPassability ; jump to subroutine to define if the tile next to the cat is passable
  PLA
  TAX
  LDA passable
  CMP #$00
  BNE CatTransformLoop      ; if the tile is passable, move to transform subroutine
  RTS

CatTransformLoop:       ; main sprite transform subroutine
  LDA trnsfrm
  CMP #$00
  BEQ CatDecrement
  CMP #$01
  BEQ CatIncrement
  CMP #$02
  BEQ CatRender
  CMP #$03
  BEQ CatRender
TrnsfrmBranchDone:
  INX
  INX
  INX
  INX
  TXA
  CMP trnsfrmcompare
  BNE CatTransformLoop
  LDA #$02              ; if trnsfrm state = 2, go through additional loop
  CMP trnsfrm
  BEQ SetRenderParameters2
  RTS

CatDecrement:
  DEC $0200, x
  JMP TrnsfrmBranchDone
CatIncrement:
  INC $0200, x
  JMP TrnsfrmBranchDone
CatRender:
  LDA [cattileslow], y
  STA $0200, x
  INY
  JMP TrnsfrmBranchDone


CheckAnimateCat:
  LDA mvcounter
  CMP #$00
  BEQ AnimateCat   ; animate only when counter = 0
  DEC mvcounter    ; if not 0, decrement counter
  ; add a branch to check if the tile is passable
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
  JSR CatTransformLoop
  RTS



;;;;;;;;;;;;;;  
  
  
  
  .bank 1
  .org $E000
palette:
  .db $0F,$14,$25,$36,$0F,$36,$14,$25,$0F,$13,$2C,$30,$0F,$1C,$2B,$39
  .db $0F,$14,$25,$36,$0F,$36,$14,$25,$0F,$13,$2C,$30,$0F,$1C,$2B,$39

sprites:
     ;vert tile attr horiz
  .db $80, $00, $00, $80
  .db $80, $00, $40, $88
  .db $88, $10, $00, $80
  .db $88, $10, $40, $88
  .db $90, $20, $00, $80
  .db $90, $04, $40, $88

  .db $B0, $1A, $00, $B0
  .db $B0, $1A, $40, $B8
  .db $B8, $2A, $00, $B0
  .db $B8, $2A, $40, $B8

front:
      ;tiles                        ;attributes                   ;animation
  .db $00, $00, $10, $10, $20, $04, $00, $40, $00, $40, $00, $40, $20, $04, $20, $05, $20, $04, $06, $04

back:
  .db $01, $01, $14, $11, $16, $21, $00, $40, $00, $40, $00, $40, $14, $11, $16, $21, $15, $17, $25, $26, $14, $11, $16, $21, $17, $15, $16, $27

left:
  .db $03, $02, $13, $12, $22, $23, $40, $40, $40, $40, $00, $00, $22, $23, $18, $19, $22, $23, $28, $29

right:
  .db $02, $03, $12, $13, $22, $23, $00, $00, $00, $00, $00, $00, $22, $23, $07, $08, $22, $23, $09, $0A

village1:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ;;row 1
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ;;row 2
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$01,$00,$00,$00,$03,$00,$00,$00,$AB,$B4,$A4,$00,$00  ;;row 3
  .db $00,$C0,$C1,$C2,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$01,$00,$00,$03,$00,$A0,$A1,$A2,$A3,$C4,$B8,$B9,$A1  ;;row 4
  .db $BA,$D0,$D1,$D2,$00,$02,$00,$C0,$C1,$C2,$00,$00,$00,$00,$00,$00

  .db $00,$02,$00,$01,$00,$00,$00,$00,$B0,$B1,$B2,$B3,$C6,$BB,$BC,$B1  ;;row 5
  .db $BD,$E0,$E1,$E2,$00,$00,$00,$D0,$D1,$D2,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$01,$00,$C0,$C1,$C2,$C3,$C9,$CA,$A5,$A6,$A7,$C9,$CA  ;;row 6
  .db $C8,$00,$F1,$00,$00,$00,$00,$E0,$F0,$E2,$00,$00,$00,$00,$00,$00

  .db $00,$02,$00,$01,$00,$D0,$D1,$D2,$C3,$D9,$DA,$B5,$B6,$B7,$D9,$DA  ;;row 7
  .db $C8,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01

  .db $00,$00,$00,$01,$00,$E0,$E1,$E2,$C3,$00,$00,$C5,$00,$C7,$00,$00  ;;row 8
  .db $C8,$00,$03,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$01,$00,$00,$F1,$00,$D3,$D4,$D4,$D5,$D6,$D7,$D4,$D4  ;;row 9
  .db $D8,$02,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ;;row 10
  .db $00,$00,$00,$02,$01,$00,$00,$F8,$F7,$F6,$F6,$F6,$F6,$F5,$00,$00

  .db $00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01  ;;row 11
  .db $01,$01,$01,$01,$01,$00,$F9,$E3,$E4,$E6,$EC,$EF,$00,$F4,$00,$00

  .db $02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ;;row 12
  .db $01,$01,$00,$00,$00,$FA,$FD,$FC,$E5,$E7,$E6,$EF,$EC,$F4,$03,$00

  .db $00,$00,$00,$00,$AA,$AD,$AD,$AD,$AD,$AD,$AD,$AF,$00,$02,$00,$00  ;;row 13
  .db $01,$01,$00,$00,$00,$FB,$FC,$ED,$EE,$E5,$E8,$97,$97,$F3,$00,$00

  .db $00,$00,$02,$00,$A9,$F6,$F6,$F6,$F6,$F6,$F6,$BF,$00,$00,$02,$00  ;;row 14
  .db $01,$01,$00,$F2,$F2,$EB,$EC,$CE,$CF,$EF,$EB,$DC,$DD,$99,$F3,$00

  .db $00,$03,$00,$00,$A8,$CC,$90,$91,$92,$93,$94,$98,$00,$00,$00,$00  ;;row 15
  .db $01,$01,$00,$F3,$00,$EB,$EF,$DE,$DF,$99,$EB,$00,$00,$99,$F3,$00

  .db $00,$00,$00,$F2,$F4,$CB,$00,$95,$AE,$96,$00,$98,$F2,$F2,$F3,$00  ;;row 16
  .db $01,$01,$00,$F3,$02,$EB,$00,$99,$E9,$99,$EA,$07,$07,$00,$F3,$00

  .db $00,$00,$00,$F3,$F4,$DB,$00,$C5,$BE,$AC,$CC,$98,$00,$02,$F3,$00  ;;row 17
  .db $01,$01,$00,$F3,$00,$06,$07,$07,$07,$07,$08,$00,$00,$00,$F3,$00

  .db $00,$00,$00,$F3,$F4,$00,$CC,$C5,$CD,$AC,$00,$98,$00,$00,$F3,$00  ;;row 18
  .db $01,$01,$00,$F2,$F2,$F2,$F2,$00,$00,$F2,$F2,$F2,$F2,$F2,$F3,$00

  .db $00,$00,$00,$F3,$04,$04,$04,$04,$04,$04,$04,$05,$02,$00,$F3,$00  ;;row 19
  .db $01,$01,$00,$00,$00,$00,$00,$01,$01,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$F2,$F2,$F2,$F2,$00,$01,$00,$F2,$F2,$F2,$F2,$F3,$00  ;;row 20
  .db $01,$01,$00,$00,$00,$00,$00,$01,$01,$00,$00,$02,$00,$C0,$C1,$C2

  .db $00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$01  ;;row 21
  .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$02,$00,$00,$D0,$D1,$D2

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ;;row 22
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$E0,$F0,$E2

  .db $97,$97,$97,$97,$97,$97,$97,$97,$97,$97,$97,$97,$97,$97,$97,$97  ;;row 23
  .db $97,$97,$97,$97,$97,$97,$97,$97,$97,$97,$97,$97,$97,$97,$97,$97


attribute:
  .db %00000010, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000

  .db $24,$24,$24,$24, $47,$47,$24,$24 ,$47,$47,$47,$47, $47,$47,$24,$24 ,$24,$24,$24,$24 ,$24,$24,$24,$24, $24,$24,$24,$24, $55,$56,$24,$24



  .org $FFFA     ;first of the three vectors starts here
  .dw NMI        ;when an NMI happens (once per frame if enabled) the 
                   ;processor will jump to the label NMI:
  .dw RESET      ;when the processor first turns on or is reset, it will jump
                   ;to the label RESET:
  .dw 0          ;external interrupt IRQ is not used
  
  
;;;;;;;;;;;;;;  
  
  
  .bank 2
  .org $0000
  .incbin "graphics.chr"   ;includes 8KB graphics file

