volume_envelopes:
  .word se_ve_default
  .word se_ve_1
  .word se_ve_2
  .word se_ve_loud


se_ve_default:
  .byte $0A, $FF

se_ve_1:
  .byte $04, $FF

se_ve_2:
  .byte $08, $FF

se_ve_loud:
  .byte $0F, $FF