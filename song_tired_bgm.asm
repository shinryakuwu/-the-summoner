tired_bgm_header:
  .byte $03              ;3 streams

  .byte MUSIC_SQ2        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte SQUARE_2         ;which channel
  .byte $B0              ;initial duty
  .byte $14              ;volume envelope
  .word tired_bgm_square ;pointer to stream
  ; .byte $34              ;tempo ntsc
  .byte $40              ;tempo pal

  .byte MUSIC_TRI        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte TRIANGLE         ;which channel
  .byte $80              ;initial volume (on)
  .byte $00              ;volume envelope
  .word tired_bgm_tri    ;pointer to stream
  ; .byte $34              ;tempo ntsc
  .byte $40              ;tempo pal

  .byte MUSIC_NOI        ;which stream
  .byte $01
  .byte NOISE            ;which channel
  .byte $30              ;initial duty
  .byte $0B              ;volume envelope
  .word tired_bgm_noise  ;pointer to stream
  ; .byte $34              ;tempo ntsc
  .byte $40              ;tempo pal

tired_bgm_square:
  .byte set_loop1_counter, $02
.part1
  .byte $81, E4, rest, E4, rest, E4, rest, E4, $83, rest, $82, F4, rest, $84, F4
  .byte $83, A4, $81, rest, $82, A4, $88, B4, $87, F4, $81, rest
  .byte A4, rest, A4, rest, A4, rest, A4, rest, $84, F4, $81, A4, rest, A4, rest, $84, F4
  .byte volume_envelope, $15
  .byte G4
  .byte volume_envelope, $14
  .byte $81, E4, rest, E4, rest, E4, rest, E4, $83, rest, $83, F4, $81, rest
  .byte $82, F4, $83, A4, $81, rest, $84, A4, $88, B4
  .byte volume_envelope, $15
  .byte F4, A4, B4, C5
  .byte volume_envelope, $14
  .byte loop1                             ;finite loop (2 times)
  .word .part1
  .byte volume_envelope, $16
  .byte set_loop1_counter, $02
.part2
  .byte $83, D4, rest, D4, rest, D4, $81, rest, $83, E4, rest, E4, rest, E4, $81, rest
  .byte $83, G4, rest, G4, rest, G4, $81, rest, $83, A4, rest, A4, rest, A4, $81, rest
  .byte $83, F4, rest, F4, rest, F4, $81, rest, $83, G4, rest, G4, rest, G4, $81, rest
  .byte $83, A4, rest, A4, rest, A4, $81, rest, $83, B4, rest, B4, rest, B4, $81, rest
  .byte loop1                             ;finite loop (2 times)
  .word .part2
  .byte volume_envelope, $14
  .byte loop                              ;infinite loop
  .word tired_bgm_square

tired_bgm_tri:
  .byte $90, D3, D3, G3, G3, C3, C3, A3, A3
  .byte loop                              ;infinite loop
  .word tired_bgm_tri

tired_bgm_noise:
  .byte set_loop1_counter, $08
.part1
  .byte $84, $0E, $0E, $86, $0A, $0E, $84, $0E, $88, $0A
  .byte loop1                             ;finite loop (8 times)
  .word .part1
  .byte set_loop1_counter, $10
.part2
  .byte $84, $0F, $0A, $0E, $0A
  .byte loop1                             ;finite loop (16 times)
  .word .part2
  .byte loop                              ;infinite loop
  .word tired_bgm_noise
