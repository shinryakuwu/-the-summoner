fren_bgm_header:
	.byte $04              ;4 streams

  .byte MUSIC_SQ1        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte SQUARE_1         ;which channel
  .byte $B0              ;initial duty
  .byte $0F              ;volume envelope
  .word fren_bgm_square1 ;pointer to stream
  ; .byte $2A              ;tempo ntsc
  .byte $34              ;tempo pal

  .byte MUSIC_SQ2        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte SQUARE_2         ;which channel
  .byte $B0              ;initial duty
  .byte $0E              ;volume envelope
  .word fren_bgm_square2 ;pointer to stream
  ; .byte $2A              ;tempo ntsc
  .byte $34              ;tempo pal

  .byte MUSIC_TRI        ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte TRIANGLE         ;which channel
  .byte $80              ;initial volume (on)
  .byte $00              ;volume envelope
  .word fren_bgm_tri     ;pointer to stream
  ; .byte $2A              ;tempo ntsc
  .byte $34              ;tempo pal

  .byte MUSIC_NOI        ;which stream
  .byte $01
  .byte NOISE            ;which channel
  .byte $30              ;initial duty
  .byte $0B              ;volume envelope
  .word fren_bgm_noise   ;pointer to stream
  ; .byte $2A              ;tempo ntsc
  .byte $34              ;tempo pal

fren_bgm_square1:
.intro
	.byte $9F, rest, $81, rest
.main
  .byte $9F, rest, $9F, rest, $8A, rest
  .byte $81, G4, rest, G4, rest, G4, rest, A4, rest, $83, E4, $81, rest
  .byte volume_envelope, $0E
  .byte $82, A3, C4, $83, G3, $81, rest, $82, B3, D3, $83, C3, $85, rest
  .byte volume_envelope, $0F
  .byte $81, G4, rest, G4, rest, G4, rest, A4, rest, $83, E4, $81, rest, $82, D4, $84, G4, $86, rest
  .byte volume_envelope, $0E
  .byte $83, C3, $81, rest, $82, E3, G3
  .byte volume_envelope, $0F
  .byte $81, G4, rest, G4, rest, G4, rest, A4, rest, $83, E4, $81, rest
  .byte volume_envelope, $0E
  .byte $82, A3, C4, $83, G3, $81, rest, $82, B3, D3, $83, C3, $81, rest, $82, E3, G3
  .byte volume_envelope, $0F
  .byte $81, G4, rest, G4, rest, G4, rest, A4, rest, $83, E4, $81, rest, $82, D4, $84, G4, $86, rest
  .byte loop                              ;infinite loop
  .word .main

fren_bgm_square2:
.intro
	.byte $9F, rest, $81, rest
.main
	.byte set_loop1_counter, $02
.main1
	.byte $83, C3, $81, rest, $82, E3, G3, $83, C3, $81, rest, $82, E3, G3, $83, F3, $81, rest
	.byte $82, A3, C4, $83, G3, $81, rest, $82, B3, D3
	.byte loop1                             ;finite loop (2 times)
  .word .main1
  .byte $83, C3, $81, rest, $82, E3, G3, $83, C3, $81, rest, $82, E3, G3, $83, F3, $85, rest
  .byte volume_envelope, $0F
  .byte $81, G5, rest, G5, rest, G5, rest, A5, rest, G5, rest, $82, E5, $82, rest
  .byte volume_envelope, $0E
  .byte G3, $83, C3, $81, rest, $82, E3, G3, $83, F3, $83, rest
  .byte volume_envelope, $0F
  .byte $81, A5, rest, G5, rest, G5, rest, G5, rest, A5, rest, G5, rest, $82, E5, $82, rest
  .byte volume_envelope, $0E
  .byte G3, $83, C3, $81, rest, $82, E3, G3, $83, F3, $83, rest
  .byte volume_envelope, $0F
  .byte $82, G5, rest, $81, G5, rest, G5, rest, A5, rest, $88, G5
  .byte volume_envelope, $0E
  .byte $83, C3, $81, rest, $82, E3, G3, $83, F3, $81, rest, $82, A3, C4, $83, G3, $81, rest, $82, B3, D3
  .byte loop                              ;infinite loop
  .word .main

fren_bgm_tri:
.intro
	.byte $81, E4, rest, $82, E4, $84, rest, $81, D4, rest, $82, D4, $84, rest
	.byte $81, G4, rest, $82, G4, $84, rest, $86, B4, $82, rest
.main
	.byte $83, E4, $81, rest, $83, E4, $81, rest, $83, G4, $81, rest, $83, G4, $81, rest
	.byte $83, A4, $81, rest, $83, A4, $81, rest, $83, B4, $81, rest, $83, B4, $81, rest
	.byte loop                              ;infinite loop
  .word .main

fren_bgm_noise:
.intro
	.byte $82, $0A, $86, $0A, $82, $0A, $86, $0A, $82, $0A, $86, $0A, $83, $0E, $81, $0A, $82, $0E, $0A
.main
	.byte $84, $0E, $0A
	.byte loop                              ;infinite loop
  .word .main
