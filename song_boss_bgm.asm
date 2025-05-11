boss_bgm_header:
  .byte $04              ;4 streams

  .byte MUSIC_SQ1        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte SQUARE_1         ;which channel
  .byte $B0              ;initial duty
  .byte $00              ;volume envelope
  .word boss_bgm_square1 ;pointer to stream
  ; .byte $20              ;tempo ntsc
  .byte $28              ;tempo pal

  .byte MUSIC_SQ2        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte SQUARE_2         ;which channel
  .byte $B0              ;initial duty
  .byte $00              ;volume envelope
  .word boss_bgm_square2 ;pointer to stream
  ; .byte $20              ;tempo ntsc
  .byte $28              ;tempo pal

  .byte MUSIC_TRI        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte TRIANGLE         ;which channel
  .byte $80              ;initial volume (on)
  .byte $00              ;volume envelope
  .word boss_bgm_intro   ;pointer to stream
; .byte $20              ;tempo ntsc
  .byte $28              ;tempo pal

  .byte MUSIC_NOI        ;which stream
  .byte $01
  .byte NOISE            ;which channel
  .byte $30              ;initial duty
  .byte $00              ;volume envelope
  .word boss_bgm_noise   ;pointer to stream
; .byte $20              ;tempo ntsc
  .byte $28              ;tempo pal


boss_bgm2_header:
  .byte $04              ;4 streams

  .byte MUSIC_SQ1        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte SQUARE_1         ;which channel
  .byte $B0              ;initial duty
  .byte $00              ;volume envelope
  .word boss_bgm_square1 ;pointer to stream
  ; .byte $24              ;tempo ntsc
  .byte $2C              ;tempo pal

  .byte MUSIC_SQ2        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte SQUARE_2         ;which channel
  .byte $B0              ;initial duty
  .byte $00              ;volume envelope
  .word boss_bgm_square2 ;pointer to stream
  ; .byte $24              ;tempo ntsc
  .byte $2C              ;tempo pal

  .byte MUSIC_TRI        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte TRIANGLE         ;which channel
  .byte $80              ;initial volume (on)
  .byte $00              ;volume envelope
  .word boss_bgm_tri     ;pointer to stream
  ; .byte $24              ;tempo ntsc
  .byte $2C              ;tempo pal

  .byte MUSIC_NOI        ;which stream
  .byte $01
  .byte NOISE            ;which channel
  .byte $30              ;initial duty
  .byte $00              ;volume envelope
  .word boss_bgm_noise   ;pointer to stream
  ; .byte $24              ;tempo ntsc
  .byte $2C              ;tempo pal

boss_bgm_square1:
  .byte $83, C2, $8D, C3
  .byte $83, C2, $8D, C3
  .byte $90, Cs2
  .byte $90, Cs2
  .byte loop                              ;infinite loop
  .word boss_bgm_square1

boss_bgm_square2:
  .byte $86, rest, $8A, C4
  .byte $86, rest, $8A, C4
  .byte $86, rest, $8A, Cs3
  .byte $86, rest, $8A, Cs3
  .byte loop                              ;infinite loop
  .word boss_bgm_square2

boss_bgm_intro:
  .byte set_loop1_counter, $02
.intro_loop:
  .byte $9F, rest, $9F, rest, $82, rest
  .byte loop1                             ;finite loop (2 times)
  .word .intro_loop
boss_bgm_tri:
  .byte $82
  .byte C5, C6, C5, Cs6
  .byte rest, C5, Cs6, C5
  .byte rest, C6, C5, C6
  .byte rest, C5, C6, Cs6
  .byte B4, B5, B4, C6
  .byte rest, B4, C6, B4
  .byte rest, B5, B4, B5
  .byte rest, B4, B5, C6
  .byte loop                              ;infinite loop
  .word boss_bgm_tri

boss_bgm_noise:
  .byte $81, $0D, $83, rest
  .byte $81, $07, $83, rest
  .byte $81, $01, $83, rest
  .byte $81, $0A, $83, rest
  .byte loop                              ;infinite loop
  .word boss_bgm_noise
