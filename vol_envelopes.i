volume_envelopes:
  .word se_ve_default
  .word se_ve_loud
  .word se_ve_beat_loud
  .word se_ve_beat_medium
  .word se_ve_beat_quiet


se_ve_default:
  .byte $0A, $FF

se_ve_loud:
  .byte $0F, $FF

se_ve_beat_loud:
  .byte $0A, $0A, $09, $09, $08, $08, $07, $07, $06, $05, $04, $03, $02, $01, $00
  .byte $FF

se_ve_beat_medium:
  .byte $08, $08, $08, $07, $07, $07, $06, $06, $05, $05, $04, $03, $02, $01, $00
  .byte $FF

se_ve_beat_quiet:
  .byte $04, $04, $04, $04, $03, $03, $03, $03, $02, $02, $02, $01, $01, $01, $00
  .byte $FF
