no_milk_bgm_header:
  .byte $03              ;3 streams

  .byte MUSIC_SQ2        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte SQUARE_2         ;which channel
  .byte $B0              ;initial duty
  .byte $0C              ;volume envelope
  .word milk_bgm_square  ;pointer to stream
  .byte $40              ;tempo

  .byte MUSIC_TRI        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte TRIANGLE         ;which channel
  .byte $80              ;initial volume (on)
  .byte $00              ;volume envelope
  .word milk_bgm_tri     ;pointer to stream
  .byte $40              ;tempo

  .byte MUSIC_NOI        ;which stream
  .byte $01
  .byte NOISE            ;which channel
  .byte $30              ;initial duty
  .byte $0B              ;volume envelope
  .word milk_bgm_noise   ;pointer to stream
  .byte $40              ;tempo

no_milk2_bgm_header:
  .byte $03              ;3 streams

  .byte MUSIC_SQ2        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte SQUARE_2         ;which channel
  .byte $B0              ;initial duty
  .byte $0C              ;volume envelope
  .word milk2_bgm_square ;pointer to stream
  .byte $40              ;tempo

  .byte MUSIC_TRI        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte TRIANGLE         ;which channel
  .byte $80              ;initial volume (on)
  .byte $00              ;volume envelope
  .word milk2_bgm_tri    ;pointer to stream
  .byte $40              ;tempo

  .byte MUSIC_NOI        ;which stream
  .byte $01
  .byte NOISE            ;which channel
  .byte $30              ;initial duty
  .byte $0B              ;volume envelope
  .word milk2_bgm_noise  ;pointer to stream
  .byte $40              ;tempo

milk_bgm_square:
  .byte set_loop1_counter, $02
.part1
  .byte $82, E4, rest, $86, E4, $82, rest, $84, B4, $88, C5, $84, rest, B4
  .byte C4, $82, G4, rest, $84, G4, E4, $88, G4, $84, rest, A4
  .byte B3, $83, D4, $81, rest, $84, D4, E4, $88, A3, $84, rest
  .byte $84, E4, B3, $83, D4, $81, rest, $84, D4, E4, $88, A3, rest
  .byte loop1                             ;finite loop (2 times)
  .word .part1
.part2
  .byte $84, Cs4, $87, E4, $81, rest, $84, B4, $88, A4, $84, rest
  .byte D5, G4, $83, B4, $81, rest, $84, B4, A4, $88, G4, $84, rest, A4
  .byte Fs4, $86, E4, $82, rest, $84, E5, $88, D5, $84, rest
  .byte A4, D4, $86, A4, $82, rest, $84, B4, $8C, A4, $84, rest

  .byte Cs4, $87, E4, $81, rest, $84, B4, $88, Cs5, $84, rest
  .byte D5, G4, $83, B4, $81, rest, $84, B4, A4, $88, G4, rest
  .byte $84, Fs4, $86, A4, $82, rest, $84, E5, $88, D5, $84, rest
  .byte A4, E4, A4, B4, Gs4, $8C, A4, $84, rest
.part3
  .byte $82, A4, rest, $86, A4, $82, rest, $84, B4, $88, C5, $84, rest, B4
  .byte A4, $82, G4, rest, $84, G4, E4, $88, G4, $84, rest, A4
  .byte E4, $83, D4, $81, rest, $84, D4, E4, $88, A3, $84, rest
  .byte E4, $83, D4, $81, rest, $83, D4, $81, rest, $84, D4, E4, $88, A3, rest
.part4
  .byte $9F, rest, $9F, rest, $82, rest
milk2_bgm_square:
.part5
  .byte $84, rest, A4, A4, $83, B4, $81, rest, $85, B4, $83, rest
  .byte $84, B4, E5, $86, Cs5, $82, rest, $84, B4, E5, $86, Cs5, $82, rest, $88, B4
  .byte $84, rest, A4, A4, $83, B4, $81, rest, $86, B4, $82, rest
  .byte $84, B4, E5, Cs5, $86, B4, $82, rest, $86, A4, $82, rest, $84, B4, $88, Cs5
  .byte $84, rest, A4, A4, $83, B4, $81, rest, $85, B4, $83, rest
  .byte $84, B4, E5, $86, Cs5, $82, rest, $84, B4, E5, $86, Cs5, $82, rest, $88, B4
  .byte $84, rest, A4, A4, $83, B4, $81, rest, $86, B4, $82, rest
  .byte $84, B4, E5, Cs5, $86, B4, $82, rest, $86, Cs5, $82, rest, $84, B4, $88, A4
.part6
  .byte $9F, rest, $9F, rest, $82, rest

  .byte loop                              ;infinite loop
  .word milk_bgm_square

milk_bgm_tri:
  .byte set_loop1_counter, $02
.part1
  .byte $84, A3, E4, C4, F4
  .byte A3, E4, C4, F4
  .byte C4, G4, E4, C5
  .byte C4, G4, E4, C5
  .byte E3, B3, G3, E4
  .byte B2, E3, C3, B3
  .byte G3, D4, B3, G4
  .byte A2, E3, C3, C4
  .byte loop1                             ;finite loop (2 times)
  .word .part1
  .byte set_loop1_counter, $02
.part2
  .byte A3, E4, Cs4, A4
  .byte A3, E4, Cs4, A4
  .byte G3, D4, B3, G4
  .byte G3, D4, B3, G4
  .byte B3, Fs4, D4, B4
  .byte D4, A4, Fs4, D5
  .byte E3, B3, Gs3, E4
  .byte A3, E4, Cs4, A4
  .byte loop1                             ;finite loop (2 times)
  .word .part2
.part3
  .byte A3, E4, C4, F4
  .byte A3, E4, C4, F4
  .byte C4, G4, E4, C5
  .byte C4, G4, E4, C5
  .byte E3, B3, G3, E4
  .byte B2, E3, C3, B3
  .byte G3, D4, B3, G4
  .byte A2, E3, C3, C4
  .byte set_loop1_counter, $02
.part4
  .byte A3, E4, A4, E4
  .byte A3, E4, C5, E4
  .byte loop1                             ;finite loop (2 times)
  .word .part4
milk2_bgm_tri:
  .byte set_loop1_counter, $03
.part5
  .byte $84, A3, E4, A4, E4
  .byte Gs3, B3, E4, B3
  .byte Fs4, A3, D4, A3
  .byte E3, B3, E4, B3
  .byte loop1                             ;finite loop (3 times)
  .word .part5
  .byte A3, E4, A4, E4
  .byte A3, E4, C5, E4
  .byte Fs3, A3, D4, A3
  .byte E3, B3, E4, B3
  .byte set_loop1_counter, $02
.part6
  .byte A3, E4, A4, E4
  .byte A3, E4, C5, E4
  .byte loop1                             ;finite loop (2 times)
  .word .part6

  .byte loop                              ;infinite loop
  .word milk_bgm_tri

milk_bgm_noise:
  .byte set_loop1_counter, $03
.part1
  .byte $88, $0E, $84, $0A, $0E, $88, $0E, $0A
  .byte loop1                             ;finite loop (3 times)
  .word .part1
  .byte $88, $0E, $84, $0A, $0E, $88, $0E, $84, $0A, $82, $0A, $0A
  .byte set_loop1_counter, $07
.part2
  .byte $88, $0E, $84, $0A, $0E, $88, $0E, $0A
  .byte loop1                             ;finite loop (7 times)
  .word .part2
  .byte $88, $0E, $84, $0A, $0E, $88, $0E, $84, $0A, $82, $0A, $0A
  .byte set_loop1_counter, $07
.part3
  .byte $88, $0E, $84, $0A, $0E, $88, $0E, $0A
  .byte loop1                             ;finite loop (7 times)
  .word .part3
  .byte $88, $0E, $84, $0A, $0E, $88, $0E, $84, $0A, $82, $0A, $0A
.part4
  .byte $88, $0E, $0A, $0E, $0A, $0E, $0A, $0E, $0A
milk2_bgm_noise:
  .byte set_loop1_counter, $03
.part5
  .byte $88, $0E, $84, $0A, $0E, $88, $0E, $0A
  .byte loop1                             ;finite loop (3 times)
  .word .part5
  .byte $84, $0E, $88, $0E, $0E, $84, $0A, $88, $0A
  .byte set_loop1_counter, $04
.part5_1
  .byte $88, $0E, $84, $0A, $0E, $88, $0E, $0A
  .byte loop1                             ;finite loop (4 times)
  .word .part5_1
.part6
  .byte $88, $0E, $0A, $0E, $0A, $0E, $0A, $0E, $0A

  .byte loop                              ;infinite loop
  .word milk_bgm_noise
