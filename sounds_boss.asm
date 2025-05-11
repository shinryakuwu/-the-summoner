boss_steps_header:
  .byte $01            ;1 stream

  .byte SFX_1          ;which stream
  .byte $01            ;status byte (stream enabled)
  .byte NOISE          ;which channel
  .byte $70            ;duty (01)
  .byte $04            ;volume envelope
  .word boss_steps_noi ;pointer to stream
  ; .byte $10            ;tempo ntsc
  .byte $18            ;tempo pal

boss_step_header:
  .byte $01           ;1 stream

  .byte SFX_1         ;which stream
  .byte $01           ;status byte (stream enabled)
  .byte NOISE         ;which channel
  .byte $70           ;duty (01)
  .byte $02           ;volume envelope
  .word boss_step_noi ;pointer to stream
  ; .byte $18           ;tempo ntsc
  .byte $1C           ;tempo pal

boss_steps_noi:
  .byte $81, $09, $84, rest
  .byte volume_envelope, $03
  .byte $81, $09, $84, rest
  .byte volume_envelope, $02
boss_step_noi:
  .byte $81, $09, $84, rest
  .byte endsound

boss_crash_header:
  .byte $01            ;1 stream

  .byte SFX_1          ;which stream
  .byte $01            ;status byte (stream enabled)
  .byte NOISE          ;which channel
  .byte $70            ;duty (01)
  .byte $01            ;volume envelope
  .word boss_crash_noi ;pointer to stream
  ; .byte $08            ;tempo ntsc
  .byte $09            ;tempo pal

boss_crash_noi:
  .byte $81, $0C
  .byte endsound

boss_jump_header:
  .byte $01            ;1 stream

  .byte SFX_1          ;which stream
  .byte $01            ;status byte (stream enabled)
  .byte NOISE          ;which channel
  .byte $70            ;duty (01)
  .byte $00            ;volume envelope
  .word boss_jump_noi  ;pointer to stream
  ; .byte $12            ;tempo ntsc
  .byte $14            ;tempo pal

boss_jump_noi:
  .byte $81, $0A
  .byte endsound

boss_fire_header:
  .byte $01            ;1 stream

  .byte SFX_1          ;which stream
  .byte $01            ;status byte (stream enabled)
  .byte NOISE          ;which channel
  .byte $70            ;duty (01)
  .byte $00            ;volume envelope
  .word boss_fire_noi  ;pointer to stream
  ; .byte $28            ;tempo ntsc
  .byte $30            ;tempo pal

boss_fire_noi:
  .byte $81, $0F
  .byte endsound

boss_dead_header:
  .byte $01            ;1 stream

  .byte SFX_2          ;which stream
  .byte $01            ;status byte (stream enabled)
  .byte NOISE          ;which channel
  .byte $70            ;duty (01)
  .byte $01            ;volume envelope
  .word boss_dead_noi  ;pointer to stream
  ; .byte $10            ;tempo ntsc
  .byte $18            ;tempo pal

boss_dead_noi:
  .byte $81, $0C
  .byte endsound
