knock_header:
  .byte $01            ;1 stream

  .byte SFX_1          ;which stream
  .byte $01            ;status byte (stream enabled)
  .byte NOISE          ;which channel
  .byte $70            ;duty (01)
  .byte $0A            ;volume envelope
  .word knock_noise    ;pointer to stream
  ; .byte $38            ;tempo ntsc
  .byte $44            ;tempo pal

knock_noise:
  .byte $81, $0C, $0D
  .byte volume_envelope, $05
  .byte $0E, rest
  .byte volume_envelope, $0A
  .byte $81, $0C, $0D
  .byte volume_envelope, $05
  .byte $0E, rest
  .byte endsound

drop_header:
  .byte $01            ;1 stream

  .byte SFX_1          ;which stream
  .byte $01            ;status byte (stream enabled)
  .byte NOISE          ;which channel
  .byte $70            ;duty (01)
  .byte $05            ;volume envelope
  .word drop_noise     ;pointer to stream
  ; .byte $20              ;tempo ntsc
  .byte $28              ;tempo pal

drop_noise:
  .byte $81, $0E
  .byte endsound

tear_header:
  .byte $01            ;1 stream

  .byte SFX_1          ;which stream
  .byte $01            ;status byte (stream enabled)
  .byte NOISE          ;which channel
  .byte $70            ;duty (01)
  .byte $06            ;volume envelope
  .word tear_noise     ;pointer to stream
  ; .byte $30            ;tempo ntsc
  .byte $38            ;tempo pal

tear_noise:
  .byte $81, $0A, $09, $08
  .byte volume_envelope, $05
  .byte $08
  .byte endsound

start_header:
  .byte $01           ;1 stream

  .byte SFX_1         ;which stream
  .byte $01           ;status byte (stream enabled)
  .byte TRIANGLE      ;which channel
  .byte $80           ;initial volume (on)
  .byte $07           ;volume envelope
  .word start_tri     ;pointer to stream
  ; .byte $50           ;tempo ntsc
  .byte $64           ;tempo pal

start_tri:
  .byte $81, C3, C4, C5, C6, C7, C8, C9
  .byte endsound

death_header:
  .byte $01              ;1 stream

  .byte SFX_1            ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte SQUARE_1         ;which channel
  .byte $B0              ;initial duty
  .byte $08              ;volume envelope
  .word death_square1    ;pointer to stream
  .byte $20              ;tempo

death_square1:
  .byte $81, C6
  .byte loop             ;infinite loop
  .word death_square1

satan_header:
  .byte $02            ;1 streams

  .byte SFX_1            ;which stream
  .byte $01              ;status byte (stream enabled)
  .byte SQUARE_1         ;which channel
  .byte $B0              ;initial duty
  .byte $08              ;volume envelope
  .word satan_square1    ;pointer to stream
  .byte $30              ;tempo

  .byte SFX_2          ;which stream
  .byte $01            ;status byte (stream enabled)
  .byte NOISE          ;which channel
  .byte $70            ;duty (01)
  .byte $09            ;volume envelope
  .word satan_noise    ;pointer to stream
  .byte $20            ;tempo

satan_noise:
  .byte $86, $03, $88, $09, $81, $0D, $83, $0C
  .byte $81, $0A, $09, $84, $0E
  .byte $95, $0D
  .byte endsound

satan_square1:
  .byte $8C, rest
  .byte $88, C6
  .byte $81, rest, C6, $83, rest, $81, C6, rest, C6
  .byte rest, C6, rest, C6, $82, rest, $81, C6, rest
  .byte rest, C6, $85, rest, $81, C6
  .byte rest, C6, rest, C6, $82, rest, $82, C6
  .byte $81, rest, C6, $83, rest, $81, C6, rest, C6
  .byte endsound
