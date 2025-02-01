cat_talk_header:
  .byte $01            ;1 stream

  .byte SFX_1          ;which stream
  .byte $01            ;status byte (stream enabled)
  .byte SQUARE_1       ;which channel
  .byte $B0            ;duty
  .byte $00            ;volume envelope
  .word cat_talk_beep  ;pointer to stream
  .byte $70            ;tempo
    
cat_talk_beep:
  .byte $81, D2
  .byte endsound
