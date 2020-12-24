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
  CPX #$18              ; Compare X to hex $20, decimal 32
  BNE LoadSpritesLoop   ; Branch to LoadSpritesLoop if compare was Not Equal to zero
                        ; if compare was equal to 32, keep going down


  LoadBackground:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$20
  STA $2006             ; write the high byte of $2000 address
  LDA #$00
  STA $2006             ; write the low byte of $2000 address
  LDX #$00              ; start out at 0
LoadBackgroundLoop:
  LDA background, x     ; load data from address (background + the value in x)
  STA $2007             ; write to PPU
  INX                   ; X = X + 1
  CPX #$80              ; Compare X to hex $80, decimal 128 - copying 128 bytes
  BNE LoadBackgroundLoop  ; Branch to LoadBackgroundLoop if compare was Not Equal to zero
                        ; if compare was equal to 128, keep going down
              
              
LoadAttribute:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$23
  STA $2006             ; write the high byte of $23C0 address
  LDA #$C0
  STA $2006             ; write the low byte of $23C0 address
  LDX #$00              ; start out at 0
LoadAttributeLoop:
  LDA attribute, x      ; load data from address (attribute + the value in x)
  STA $2007             ; write to PPU
  INX                   ; X = X + 1
  CPX #$08              ; Compare X to hex $08, decimal 8 - copying 8 bytes
  BNE LoadAttributeLoop  ; Branch to LoadAttributeLoop if compare was Not Equal to zero
                        ; if compare was equal to 128, keep going down
           

  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000

  LDA #%00010000   ; enable sprites
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
  LDA #%00010010   ; enable sprites, enable background, no clipping on left side
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


CheckMovement:
  LDA buttons
  AND #%00001111    ; check only the state of the arrow buttons
  CMP #$00
  BNE CatMoves      ; branch if any button is pressed
  LDA #$00
  STA mvcounter     ; set animation counter to 0 when nothing is pressed
  STA framenum      ; frame number = 0
  LDA #$01
  STA staticrender
  JSR DetermineDirection
  JSR SetRenderParameters
  RTS
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
  JSR CatTransformLoop
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
  JSR CatTransformLoop
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
  JSR CatTransformLoop
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
  JSR CatTransformLoop
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
  ;LDA staticrender
  ;CMP #$01
  ;BEQ CatTransformLoop
  LDY #$06
  JMP CatTransformLoop


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
  .db $0F,$1C,$24,$33,$34,$35,$36,$37,$38,$24,$3A,$3B,$3C,$3D,$3E,$0F
  .db $0F,$14,$25,$36,$0F,$14,$25,$36,$0F,$12,$24,$39,$31,$02,$38,$3C

sprites:
     ;vert tile attr horiz
  .db $80, $00, $00, $80
  .db $80, $00, $40, $88
  .db $88, $10, $00, $80
  .db $88, $10, $40, $88
  .db $90, $20, $00, $80
  .db $90, $04, $40, $88

front:
      ;tiles                        ;attributes                   ;animation
  .db $00, $00, $10, $10, $20, $04, $00, $40, $00, $40, $00, $40, $20, $04, $20, $05, $20, $04, $06, $04

back:
  .db $01, $01, $14, $11, $16, $21, $00, $40, $00, $40, $00, $40, $14, $11, $16, $21, $15, $17, $25, $26, $14, $11, $16, $21, $17, $15, $16, $27

left:
  .db $03, $02, $13, $12, $22, $23, $40, $40, $40, $40, $00, $00, $22, $23, $18, $19, $22, $23, $28, $29

right:
  .db $02, $03, $12, $13, $22, $23, $00, $00, $00, $00, $00, $00, $22, $23, $07, $08, $22, $23, $09, $0A

; not ready yet
background:
  .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  ;;row 1
  .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  ;;all sky

  .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  ;;row 2
  .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  ;;all sky

  .db $24,$24,$24,$24,$45,$45,$24,$24,$45,$45,$45,$45,$45,$45,$24,$24  ;;row 3
  .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$53,$54,$24,$24  ;;some brick tops

  .db $24,$24,$24,$24,$47,$47,$24,$24,$47,$47,$47,$47,$47,$47,$24,$24  ;;row 4
  .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$55,$56,$24,$24  ;;brick bottoms

attribute:
  .db %00000000, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000

  .db $24,$24,$24,$24, $47,$47,$24,$24 ,$47,$47,$47,$47, $47,$47,$24,$24 ,$24,$24,$24,$24 ,$24,$24,$24,$24, $24,$24,$24,$24, $55,$56,$24,$24  ;;brick bottoms



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

