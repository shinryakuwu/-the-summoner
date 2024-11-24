boss_steps_header:
  .byte $01            ;1 stream

  .byte SFX_1          ;which stream
  .byte $01            ;status byte (stream enabled)
  .byte NOISE          ;which channel
  .byte $70            ;duty (01)
  .byte $01            ;volume envelope
  .word boss_steps_noi ;pointer to stream
  .byte $10            ;tempo

boss_step_header:
  .byte $01           ;1 stream

  .byte SFX_1         ;which stream
  .byte $01           ;status byte (stream enabled)
  .byte NOISE         ;which channel
  .byte $70           ;duty (01)
  .byte $00           ;volume envelope
  .word boss_step_noi ;pointer to stream
  .byte $18           ;tempo

boss_steps_noi:
  .byte $81, $09, $84, rest
  .byte volume_envelope, $02
  .byte $81, $09, $84, rest
  .byte volume_envelope, $00
boss_step_noi:
  .byte $81, $09, $84, rest
  .byte endsound

boss_crash_header:
  .byte $01              ;1 stream

  .byte SFX_1          ;which stream
  .byte $01            ;status byte (stream enabled)
  .byte NOISE          ;which channel
  .byte $70            ;duty (01)
  .byte $03            ;volume envelope
  .word boss_crash_noi ;pointer to stream
  .byte $08            ;tempo

boss_crash_noi:
  .byte $81, $0C
  .byte endsound
