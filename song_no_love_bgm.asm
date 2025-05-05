no_love_bgm_header:
  .byte $03              ;3 streams

  .byte MUSIC_SQ2        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte SQUARE_2         ;which channel
  .byte $B0              ;initial duty
  .byte $11              ;volume envelope
  .word love_bgm_square  ;pointer to stream
  .byte $2A              ;tempo

  .byte MUSIC_TRI        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte TRIANGLE         ;which channel
  .byte $80              ;initial volume (on)
  .byte $00              ;volume envelope
  .word love_bgm_tri     ;pointer to stream
  .byte $2A              ;tempo

  .byte MUSIC_NOI        ;which stream
  .byte $01
  .byte NOISE            ;which channel
  .byte $30              ;initial duty
  .byte $10              ;volume envelope
  .word love_bgm_noise   ;pointer to stream
  .byte $2A              ;tempo

love_bgm_square:
  .byte $84, Cs3
  .byte volume_envelope, $12
  .byte C3
  .byte volume_envelope, $11
  .byte Cs3
  .byte volume_envelope, $12
  .byte C3
  .byte volume_envelope, $11
  .byte C3, C3
  .byte volume_envelope, $13
  .byte Cs3
  .byte volume_envelope, $11
  .byte Cs3
  .byte volume_envelope, $12
  .byte C3
  .byte volume_envelope, $11
  .byte Cs3
  .byte volume_envelope, $12
  .byte C3
  .byte volume_envelope, $11
  .byte Cs3
  .byte volume_envelope, $12
  .byte C3
  .byte volume_envelope, $11
  .byte Cs3
  .byte volume_envelope, $12
  .byte C3
  .byte volume_envelope, $13
  .byte Cs3
  .byte loop                              ;infinite loop
  .word love_bgm_square

love_bgm_tri:
  .byte $82, C2, $8E, rest, $82, C2, rest, C2, $86, rest, $82, C2, $86, rest
  .byte $82, C2, $86, rest, $82, C2, $86, rest, $82, C2, $8A, rest
  .byte loop                              ;infinite loop
  .word love_bgm_tri

love_bgm_noise:
  .byte $88, $0F, $0A, $84, $0F, $0F, $0A, $88, $0F, $84, $0F, $0A, $88, $0F, $84, $0F, $88, $0A
  .byte loop                              ;infinite loop
  .word love_bgm_noise
