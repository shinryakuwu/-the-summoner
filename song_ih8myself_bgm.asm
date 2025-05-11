ih8myself_bgm_header:
  .byte $03              ;3 streams

  .byte MUSIC_SQ1        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte SQUARE_1         ;which channel
  .byte $B0              ;initial duty
  .byte $0A              ;volume envelope
  .word h8_bgm_square1   ;pointer to stream
  .byte $2A              ;tempo ntsc
  ; .byte $34              ;tempo pal

  .byte MUSIC_SQ2        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte SQUARE_2         ;which channel
  .byte $B0              ;initial duty
  .byte $09              ;volume envelope
  .word h8_bgm_square2   ;pointer to stream
  .byte $2A              ;tempo ntsc
  ; .byte $34              ;tempo pal

  .byte MUSIC_NOI        ;which stream
  .byte $01
  .byte NOISE            ;which channel
  .byte $30              ;initial duty
  .byte $0B              ;volume envelope
  .word h8_bgm_noise     ;pointer to stream
  .byte $2A              ;tempo ntsc
  ; .byte $34              ;tempo pal

h8_bgm_square1:
.h8_wait:
  .byte $9F, rest, $9F, rest, $82, rest
  .byte $9F, rest, $9F, rest, $82, rest

  .byte set_loop1_counter, $02
.h8_main:
  .byte volume_envelope, $0A
  .byte $8B, F4, $81, rest, $82, F4, $84, E4, G4, F4, $86, G4

  .byte loop1                             ;finite loop (2 times)
  .word .h8_main

  .byte $8B, D4, $81, rest, $84, F4, $8C, G4, $84, F4, $94, D4, $8C, rest

  .byte volume_envelope, $09
  .byte $83, E4, $81, rest, $84, E4, G4, $82, E4, $84, F4, $82, E4, $84, D4
  .byte $81, E4, $81, rest, $81, E4, $81, rest, $81, E4, $81, rest, $81, E4, $9F, rest, $82, rest
  .byte loop                              ;infinite loop
  .word h8_bgm_square1

h8_bgm_square2:
  .byte set_loop1_counter, $03
.h82_main:
  .byte $83, E4, $81, rest, $84, E4, G4, $82, E4, $84, F4, $82, E4, $84, D4
  .byte $81, E4, $81, rest, $81, E4, $81, rest, $81, E4, $81, rest, $81, E4, $81, rest
  .byte $83, E4, $81, rest, $84, E4, F4, $82, E4, $84, D4, $82, E4, $84, C4
  .byte $81, E4, $81, rest, $81, E4, $81, rest, $81, E4, $81, rest, $81, E4, $81, rest
  .byte loop1                             ;finite loop (3 times)
  .word .h82_main

  .byte $83, E4, $81, rest, $84, E4, G4, $82, E4, $84, F4, $82, E4, $84, D4
  .byte $81, E4, $81, rest, $81, E4, $81, rest, $81, E4, $81, rest, $81, E4, $81, rest
  .byte $83, E4, $81, rest, $84, E4, F4
  .byte $82, F5, $84, E5, G5, F5, $86, G5, $8B, F5, $9F, rest, $96, rest

  .byte loop                              ;infinite loop
  .word h8_bgm_square2

h8_bgm_noise:
  .byte set_loop1_counter, $07
.h8_main:
  .byte sync, $01, $84, $0A, sync, $01, $0A, sync, $01, $86, $0E
  .byte sync, $01, $0A, sync, $01, $84, $0A, sync, $01, $88, $0E
  .byte loop1                             ;finite loop (7 times)
  .word .h8_main

  .byte sync, $01, $84, $0E, sync, $01, $0E, sync, $01, $82, $0E, sync, $01, $0E, sync, $01, $0E
  .byte sync, $01, $86, $0E, sync, $01, $84, $0A, sync, $01, sync, $01, $88, $0E

  .byte set_loop1_counter, $02
.h8_main2:
  .byte sync, $01, $84, $0A, sync, $01, $0A, sync, $01, $86, $0E
  .byte sync, $01, $0A, sync, $01, $84, $0A, sync, $01, $88, $0E
  .byte loop1                             ;finite loop (2 times)
  .word .h8_main2

  .byte loop                              ;infinite loop
  .word h8_bgm_noise
