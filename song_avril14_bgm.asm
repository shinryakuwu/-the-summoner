avril14_bgm_header:
  .byte $04              ;4 streams
  
  .byte MUSIC_SQ1        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte SQUARE_1         ;which channel
  .byte $B8              ;initial volume (C) and duty (10)
  .word avril14_bgm_square1 ;pointer to stream
  .byte $10              ;tempo
  
  .byte MUSIC_SQ2        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte SQUARE_2         ;which channel
  .byte $B8              ;initial volume (C) and duty (10)
  .word avril14_bgm_square2 ;pointer to stream
  .byte $10              ;tempo
  
  .byte MUSIC_TRI        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte TRIANGLE         ;which channel
  .byte $81              ;initial volume (on)
  .word avril14_bgm_tri     ;pointer to stream
  .byte $10              ;tempo
  
  .byte MUSIC_NOI        ;which stream
  .byte $01
  .byte NOISE            ;which channel
  .byte $3C              ;initial volume (on)
  .word avril14_bgm_noise   ;pointer to stream
  .byte $10              ;tempo

                        
avril14_bgm_square1:
  .byte $84, C5, F4, $85, Ab4, $81, rest
  .byte $81, Ab4, $86, F4, $81, rest, $82, F4
  .byte Eb5, Db5, C5, Ab4
  ; .byte $83, C2, $8D, C3
  ; .byte $83, C2, $8D, C3
  ; .byte $90, Cs2
  ; .byte $90, Cs2
  .byte $FF

avril14_bgm_square2:
  ; .byte $81, Ab5, F4, Ab4, C3
  ; .byte C4, Ab4, C3
  ; .byte Eb3, Db4, Ab4, Db3, Eb3
  ; .byte Bb5, Ab4, Db3, C3
  .byte $81, rest, $FF
    
avril14_bgm_tri:
  .byte $82, Ab2, F3, Ab3, C4
  .byte C3, Ab3, C4
  .byte Eb4, Db3, Ab3, Db4, Eb4
  .byte Bb2, Ab3, Db4, C4
  ; .byte $82
  ; .byte C5, C6, C5, Cs6
  ; .byte rest, C5, Cs6, C5
  ; .byte rest, C6, C5, C6
  ; .byte rest, C5, C6, Cs6
  ; .byte B4, B5, B4, C6
  ; .byte rest, B4, C6, B4
  ; .byte rest, B5, B4, B5
  ; .byte rest, B4, B5, C6
  .byte $81, rest, $FF

avril14_bgm_noise:
  .byte $81, rest, $FF