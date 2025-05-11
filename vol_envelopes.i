volume_envelopes:
  .word se_ve_default
  .word se_ve_loud
  .word se_ve_beat_loud
  .word se_ve_beat_medium
  .word se_ve_beat_quiet
  .word se_ve_fast_fade_out
  .word se_ve_vibrate
  .word se_ve_triangle_vibrate
  .word se_ve_quiet
  .word se_ve_medium
  .word se_ve_pulse_vibe
  .word se_ve_drums
  .word se_ve_pulse_quiet
  .word se_ve_muted
  .word se_ve_pulse_medium
  .word se_ve_pulse_loud
  .word se_ve_drums_echo
  .word se_ve_pulse_vibe_loud
  .word se_ve_pulse_vibe_echo
  .word se_ve_pulse_vibe_fade_in
  .word se_ve_pulse_echo
  .word se_ve_pulse_vibe_medium
  .word se_ve_pulse_vibe_soft

se_ve_default:
  .byte $0A, $FF

se_ve_loud:
  .byte $0F, $FF

se_ve_beat_loud:
  .byte $0A, $0A, $09, $09, $08, $08, $07, $07, $06, $05, $04, $03, $02, $01, $00, $FF

se_ve_beat_medium:
  .byte $08, $08, $08, $07, $07, $07, $06, $06, $05, $05, $04, $03, $02, $01, $00, $FF

se_ve_beat_quiet:
  .byte $04, $04, $04, $04, $03, $03, $03, $03, $02, $02, $02, $01, $01, $01, $00, $FF

se_ve_fast_fade_out:
  .byte $0C, $0A, $08, $06, $04, $02, $00, $FF

se_ve_vibrate:
  .byte $0F,$06,$0F,$06,$0F,$06,$0F,$06,$0F,$06,$0F,$06,$0F,$06,$0F,$06,$0F,$06,$FF

se_ve_triangle_vibrate:
  .byte $0F,$00,$0F,$00,$0F,$00,$0F,$00,$0F,$00,$0F,$00,$0F,$00,$0F,$00,$FF

se_ve_quiet:
  .byte $01, $FF

se_ve_medium:
  .byte $04, $FF

se_ve_pulse_vibe:
  .byte $06, $08, $09, $08, $07, $08, $07, $06, $07, $06, $04, $FF

se_ve_drums:
  .byte $05, $05, $04, $04, $03, $03, $02, $02, $01, $00, $FF

se_ve_pulse_quiet:
  .byte $03, $05, $06, $05, $04, $03, $FF

se_ve_muted:
  .byte $00, $FF

se_ve_pulse_medium:
  .byte $05, $07, $08, $07, $06, $05, $FF

se_ve_pulse_loud:
  .byte $07, $09, $0A, $09, $08, $07, $FF

se_ve_drums_echo:
  .byte $0F, $0D, $0B, $09, $08, $07, $06, $05, $05, $04, $04, $04, $07, $06, $05, $05, $04, $04, $03, $03, $02, $02, $01, $FF

se_ve_pulse_vibe_loud:
  .byte $0C, $09, $06, $03, $06, $09, $0C, $09, $06, $03, $06, $09, $0C, $09, $06, $03, $06, $09, $0C, $09, $06, $03, $06, $09, $FF

se_ve_pulse_vibe_echo:
  .byte $0A, $08, $06, $04, $05, $07, $09, $07, $05, $03, $04, $05, $07, $05, $04, $02, $03, $04, $05, $04, $03, $01, $02, $03, $04, $03, $02, $01, $FF

se_ve_pulse_vibe_fade_in:
  .byte $04, $07, $0A, $07, $05, $09, $0B, $0E, $0B, $09, $07, $09, $0B, $09, $07, $05, $07, $09, $07, $05, $03, $04, $06, $04, $02, $FF

;ntsc
; se_ve_pulse_echo:
;   .byte $09, $07, $05, $03, $07, $05, $03, $05, $03, $01, $09, $07, $05, $03, $07, $05, $03, $05, $03, $01
;   .byte $09, $07, $05, $03, $07, $05, $03, $05, $03, $01, $09, $07, $05, $03, $07, $05, $03, $05, $03, $01
;   .byte $09, $07, $05, $03, $07, $05, $03, $05, $03, $01, $09, $07, $05, $03, $07, $05, $03, $05, $03, $01, $FF
;pal
se_ve_pulse_echo:
  .byte $09, $07, $05, $03, $07, $05, $03, $01, $09, $07, $05, $03, $07, $05, $03, $01
  .byte $09, $07, $05, $03, $07, $05, $03, $01, $09, $07, $05, $03, $07, $05, $03, $01
  .byte $09, $07, $05, $03, $07, $05, $03, $01, $09, $07, $05, $03, $07, $05, $03, $01, $FF

se_ve_pulse_vibe_medium:
  .byte $09, $07, $05, $02, $05, $07, $09, $07, $05, $02, $05, $07, $09, $07, $05, $02, $05, $07
  .byte $09, $07, $05, $02, $05, $07, $09, $07, $05, $02, $05, $07, $FF

se_ve_pulse_vibe_soft:
  .byte $08, $06, $04, $06, $08, $06, $04, $06, $08, $06, $04, $06, $08, $06, $04, $06, $08, $06, $04, $06, $08, $06, $04, $06, $08, $06, $04, $06, $FF
