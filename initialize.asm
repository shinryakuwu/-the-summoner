Vblankwait:
  BIT $2002
  BPL Vblankwait
  RTS

LoadBackground:
  JSR InitializeLoadBackground
  LDA currentbghigh     ; save this value to stack to restore it by the end of the subroutine
  PHA
  LDX #$00              ; start at pointer + 0
  LDY #$00
  STY emptytilescount   ; clear empty tile rows counter
LoadBackgroundLoop:
  LDA [currentbglow], y
  CMP #EMPTYBGTILEATTRIBUTE
  BEQ LoadEmptyBgTiles
  LDA [currentbglow], y
  STA $2007
  JSR Increment16BitBGPointer
  ; INY
  ; CPY #$00
  ; BNE CompareLoadBgPointer
  ; INC currentbghigh     ; low byte went 0 to 256, so high byte needs to be changed now
  ; INX
CompareLoadBgPointer:
  CPY loadbgcompare
  BCC LoadBackgroundLoop
  CPX loadbgcompare+1
  BCC LoadBackgroundLoop

  PLA
  STA currentbghigh
  RTS

Increment16BitBGPointer:
  INY
  CPY #$00
  BEQ Increment16BitBgPointerHigh
  RTS
Increment16BitBgPointerHigh:
  INC currentbghigh     ; low byte went 0 to 256, so high byte needs to be changed now
  INX
  RTS

InitializeLoadBackground:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$20
  STA $2006             ; write the high byte of $2000 address
  LDA #$00
  STA $2006             ; write the low byte of $2000 address
  RTS

LoadEmptyBgTiles:
  INC emptytilescount    ; increment empty tile rows counter
  JSR StoreEmptyTilesRowAddress
  JSR Increment16BitBGPointer
  ; INY
  ; CPY #$00
  ; BNE LoadEmptyBgTilesSkipAddCarry
  ; INC currentbghigh     ; low byte went 0 to 256, so high byte needs to be changed now
  ; INX
; LoadEmptyBgTilesSkipAddCarry:
  LDA [currentbglow], y
  STA emptytilesnumber
  TXA
  PHA                    ; push X to stack
  LDX #$00
LoadEmptyBgTilesLoop:    ; x times move #$FF to addr 2007
  LDA #$FF
  STA $2007
  INX
  CPX emptytilesnumber
  BNE LoadEmptyBgTilesLoop
  JSR Increment16BitBGPointer
  PLA
  TAX
  JMP CompareLoadBgPointer

StoreEmptyTilesRowAddress:
  ; this subroutine stores all addresses containing the empty tile attribute (EMPTYBGTILEATTRIBUTE)
  ; in RAM starting from EMPTYTILEROWADDRESSES + 2 to use them later in passability logic
  TYA
  PHA                    ; push y to stack
  CLC
  ADC currentbglow       ; add value from y to currentbglow and store in emptytilerowaddr
  STA emptytilerowaddr
  LDA currentbghigh
  ADC #$00               ; add 0 and carry from previous add
  STA emptytilerowaddr+1
  LDA emptytilescount    ; take emptytilescount, multiply by 2 and use as pointer

  STA EMPTYTILEROWADDRESSES  ; debug

  ASL A
  TAY
  LDA emptytilerowaddr
  STA EMPTYTILEROWADDRESSES, y
  INY
  LDA emptytilerowaddr+1
  STA EMPTYTILEROWADDRESSES, y
  PLA
  TAY                    ; pull y from stack
  RTS

ClearRemainingBG:
  LDY #$00
ClearRemainingBGLoop:
  LDA #$FF
  STA $2007
  INY
  CPY clearbgcompare
  BNE ClearRemainingBGLoop
  RTS

LoadAttribute:
  LDA $2002               ; read PPU status to reset the high/low latch
  LDA #$23
  STA $2006               ; write the high byte of $23C0 address
  LDA #$C0
  STA $2006               ; write the low byte of $23C0 address
  LDA singleattribute
  CMP #$01
  BEQ LoadSingleAttribute
  LDY #$00                ; start out at 0
LoadAttributesLoop:
  LDA [currentattrlow], y ; load data from address (attribute + the value in y)
  STA $2007               ; write to PPU
  INY                     ; X = X + 1
  ; TODO: add different values for PAL/NTSC
  CPY #$40                ; load attributes to bg attributes table 64 times
  BNE LoadAttributesLoop  ; Branch to LoadAttributeLoop if compare was Not Equal to zero
  RTS

LoadSingleAttribute:
  LDX attributenumber
  LDY #$00
LoadSingleAttributeLoop:
  STX $2007                    ; write to PPU
  INY
  ; TODO: add different values for PAL/NTSC
  ; CPY #$40                     ; load X to bg attributes table 64 times
  CPY #$28
  BNE LoadSingleAttributeLoop  ; Branch to LoadAttributeLoop if compare was Not Equal to zero
  RTS

LoadSprites:
  LDY #$00                 ; start at 0
LoadSpritesLoop:
  LDA [curntspriteslow], y ; load data from address (sprites +  y)
  STA [ramspriteslow], y   ; store into RAM address
  INY                      ; Y = Y + 1
  CPY spritescompare       ; Compare Y to the needed value
  BNE LoadSpritesLoop      ; Branch to LoadSpritesLoop if compare was Not Equal to zero

ClearSprites:
  LDA #$00                 ; add the needed offset not to clear further than $02FF
  SEC
  SBC ramspriteslow
  STA spritescompare
ClearSpritesLoop:
  LDA #$00                 ; fill the rest of sprite addresses with zeros
  STA [ramspriteslow], y
  INY
  CPY spritescompare
  BNE ClearSpritesLoop
  RTS

LoadPalettes:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006             ; write the high byte of $3F00 address
  LDA #$00
  STA $2006             ; write the low byte of $3F00 address
  LDY #$00              ; start out at 0
LoadPalettesLoop:
  LDA [curntpalette], y   ; load data from address (palette + the value in y)
                          ; 1st time through loop it will load palette+0
                          ; 2nd time through loop it will load palette+1
                          ; 3rd time through loop it will load palette+2
                          ; etc
  STA $2007             ; write to PPU
  INY                   ; Y = Y + 1
  CPY #$20              ; Compare Y to hex $10, decimal 16 - copying 16 bytes = 4 sprites
  BNE LoadPalettesLoop  ; Branch to LoadPalettesLoop if compare was Not Equal to zero
                        ; if compare was equal to 32, keep going down
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

  JSR Vblankwait       ; First wait for vblank to make sure PPU is ready

Clrmem:
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
  BNE Clrmem

  JSR Vblankwait      ; Second wait for vblank, PPU is ready after this

  JSR sound_init

SetPalettes:
  LDA #LOW(palette)
  STA curntpalette
  LDA #HIGH(palette)
  STA curntpalette+1
  JSR LoadPalettes

SetCatCache:
  LDA #LOW(catsprites)
  STA curntspriteslow     ; put the low byte of the address of tiles into pointer
  LDA #HIGH(catsprites)
  STA curntspriteshigh    ; put the high byte of the address into pointer
  LDA #LOW(catcache)
  STA ramspriteslow
  LDA #HIGH(catcache)
  STA ramspriteshigh      ; load sprites starting from 0200 RAM address
  LDA #$18
  STA spritescompare

  JSR LoadSprites

SetInitialBackground:
  LDA #LOW(titleparams)
  STA currentbgparams
  LDA #HIGH(titleparams)
  STA currentbgparams+1
  JSR SetBgParams

  JSR LoadBackground

  LDA #$C0               ; TODO: add different values for PAL/NTSC
  STA clearbgcompare
  JSR ClearRemainingBG   ; the rest of bg is empty

SetInitialAttributes:
  LDA #LOW(titleattributes)
  STA currentattrlow
  LDA #HIGH(titleattributes)
  STA currentattrhigh

  JSR LoadAttribute

  ; LDA #$FF
  ; STA candyswitches

  LDA #CATLIVES
  STA lives

  LDA #TITLEANIMATIONSPEED ; set animation speed for title screen
  STA animationspeed

  LDA #$04
  STA action ; initial state is waiting for start button to be pressed

ReturnToNMI:
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000

  LDA #%00011110   ; enable sprites
  STA $2001

Forever:
  INC sleeping    ; go to sleep (wait for NMI)
ForeverLoop:
  LDA sleeping
  BNE ForeverLoop

  ; when NMI wakes us up, perform the following code and go back to sleep

  LDA nmiwaitcounter ; when nmi waits, the logic below will wait too
  BNE SkipMainLogicSubroutines

  JSR CheckActionDots
  JSR CheckActionMainLoop
  JSR MovementSubroutine
  JSR Warp
  JSR sound_play_frame

SkipMainLogicSubroutines:
  JSR BgRenderSubroutine
  JMP Forever     ; jump back to Forever, infinite loop
