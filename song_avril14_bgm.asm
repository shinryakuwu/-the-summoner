avril14_bgm_header:
  .byte $04           ;4 streams
  
  .byte MUSIC_SQ1     ;which stream
  .byte $01           ;status byte (stream enabled)
  .byte SQUARE_1      ;which channel
  .byte $B0           ;initial duty
  .byte $00           ;volume envelope
  .word avr14_square1 ;pointer to stream
  .byte $16           ;tempo
  
  .byte MUSIC_SQ2     ;which stream
  .byte $01           ;status byte (stream enabled)
  .byte SQUARE_2      ;which channel
  .byte $B0           ;initial duty
  .byte $00           ;volume envelope
  .word avr14_square2 ;pointer to stream
  .byte $16           ;tempo
  
  .byte MUSIC_TRI     ;which stream
  .byte $01           ;status byte (stream enabled)
  .byte TRIANGLE      ;which channel
  .byte $80           ;initial volume (on)
  .byte $00           ;volume envelope
  .word avr14_tri     ;pointer to stream
  .byte $16           ;tempo
  
  .byte MUSIC_NOI
  .byte $00

              
avr14_square1:
  .byte set_loop1_counter, $02
.part1:
  .byte $84, C5, F4, $85, Ab4, $81, rest
  .byte $81, Ab4, $86, F4, $81, rest, $82, F4
  .byte Eb5, Db5, C5, Ab4

  .byte loop1                             ;finite loop (2 times)
  .word .part1

  .byte set_loop1_counter, $02
.part2:
  .byte $84, C5, F4, $85, Ab4, $81, rest
  .byte $81, Ab4, $8F, F4, $82, rest

  .byte loop1                             ;finite loop (2 times)
  .word .part2

  .byte set_loop1_counter, $02
.part3:
  .byte $85, C4, $81, rest, C4
  .byte $86, Eb4, $81, rest
  .byte C4, rest, $85, C4, $81, rest
  .byte C4, Eb4, $85, F4, $81, rest, $82, Eb4

  .byte loop1                             ;finite loop (2 times)
  .word .part3

  .byte loop                              ;infinite loop
  .word avr14_square1

avr14_square2:
.part1:
  .byte $9F, rest, $9F, rest, $82, rest
  .byte set_loop1_counter, $02
.part2:
  .byte $84, C6, F5, $85, Ab5, $81, rest
  .byte $81, Ab5, $8F, F5, $82, rest

  .byte loop1                             ;finite loop (2 times)
  .word .part2
.part3:
  .byte $9F, rest, $9F, rest, $82, rest

  .byte loop                              ;infinite loop
  .word avr14_square2

avr14_tri:
  .byte $82, Ab3, F4, Ab4, C5
  .byte C4, Ab4, C5
  .byte Eb5, Db4, Ab4, Db5, Eb5
  .byte Bb3, Ab4, Db5, C5

  .byte loop                              ;infinite loop
  .word avr14_tri
