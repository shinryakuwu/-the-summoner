main_bgm_header:
  ; .byte $04              ;4 streams
  .byte $03

  ; .byte MUSIC_SQ1        ;which stream
  ; .byte $01              ;status byte (stream enabled)
  ; .byte SQUARE_1         ;which channel
  ; .byte $B0              ;initial duty
  ; .byte $00              ;volume envelope
  ; .word main_bgm_square1 ;pointer to stream
  ; .byte $20              ;tempo

  .byte MUSIC_SQ2        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte SQUARE_2         ;which channel
  .byte $B0              ;initial duty
  .byte $00              ;volume envelope
  .word main_bgm_square1 ;pointer to stream
  .byte $20              ;tempo

  .byte MUSIC_TRI        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte TRIANGLE         ;which channel
  .byte $80              ;initial volume (on)
  .byte $00              ;volume envelope
  .word main_bgm_tri     ;pointer to stream
  .byte $20              ;tempo

  .byte MUSIC_NOI        ;which stream
  .byte $01
  .byte NOISE            ;which channel
  .byte $30              ;initial duty
  .byte $02              ;volume envelope
  .word main_bgm_noise   ;pointer to stream
  .byte $20              ;tempo

; main_bgm_tri:
main_bgm_square1:
  ; .byte $84, C3, $82, D3, Ds3
  ; .byte $84, C3, $82, D3, Ds3
  ; .byte $84, G3, $82, A3, As3
  ; .byte $84, G2, $82, A2, $81, As2, $81, rest
  ; .byte loop                              ;infinite loop
  ; .word main_bgm_square1

  .byte $84, C4, $82, D4, Ds4
  .byte $84, C4, $82, D4, Ds4
  .byte $84, G4, $82, A4, As4
  .byte $84, G3, $82, A3, $81, As3, $81, rest
  .byte loop                              ;infinite loop
  .word main_bgm_square1

; main_bgm_square1:
main_bgm_tri:
  .byte $86, C5, G4, $94, A4
  .byte $86, C5, G4, A4, $8E, D4
  .byte $86, C5, G4, $94, A4
  .byte $86, C5, G4, A4, $8E, D4

  .byte $83, C5, G4, $82, C4
  .byte $83, C5, G4, $82, C4
  .byte $83, As4, A4, $82, G4
  .byte $83, As4, A4, $82, G4
  .byte $83, C5, G4, $82, C4
  .byte $83, C5, G4, $82, C4
  .byte $83, As4, A4, $82, G4, $88, D4
  .byte $83, C5, G4, $82, C4
  .byte $83, C5, G4, $82, C4
  .byte $83, As4, A4, $82, G4
  .byte $83, As4, A4, $82, G4
  .byte $86, C4, D4, F4, $8E, G4


  .byte loop                              ;infinite loop
  .word main_bgm_tri

main_bgm_noise:
  .byte $88,$07,$03,$86,$07,$82,$07,$88,$03
  .byte loop                              ;infinite loop
  .word main_bgm_noise
