ReadController:
  LDA buttons
  STA buttons_old ; save last frame's joypad button states

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

  LDA buttons_old      ; what was pressed last frame.  EOR to flip all the bits to find ...
  EOR #$FF             ; what was not pressed last frame
  AND buttons          ; what is pressed this frame
  STA buttons_pressed  ; stores off-to-on transitions
  RTS
