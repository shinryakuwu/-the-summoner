palette:
  .db $0F,$14,$25,$36,$0F,$36,$14,$25,$0F,$13,$2C,$36,$0F,$13,$36,$25
  .db $0F,$14,$25,$36,$0F,$36,$14,$25,$0F,$13,$25,$36,$0F,$25,$21,$36

palettestart:
  .db $0F,$14,$25,$36,$0F,$36,$14,$25,$0F,$13,$2C,$14,$0F,$13,$36,$24
  .db $0F,$14,$25,$36,$0F,$36,$14,$25,$0F,$13,$25,$36,$0F,$25,$21,$36

paletteend:
  .db $0F,$14,$25,$36,$0F,$03,$25,$36,$0F,$14,$03,$36,$0F,$03,$14,$25
  .db $0F,$14,$25,$36,$0F,$13,$13,$0F,$0F,$13,$25,$36,$0F,$25,$21,$36

catsprites:
     ;vert tile attr horiz
  .db $80, $10, $00, $3C
  .db $80, $10, $40, $44
  .db $88, $20, $00, $3C
  .db $88, $20, $40, $44
  .db $90, $30, $00, $3C
  .db $90, $04, $40, $44

village1sprites:
  ; pumpkins
  .db $86, $67, $00, $63
  .db $87, $2A, $00, $60
  .db $87, $2A, $40, $68

  .db $7A, $1B, $00, $DA
  .db $7A, $1B, $40, $E2
  .db $82, $2B, $00, $DA
  .db $82, $2B, $40, $E2

ghost:
  .db $18, $1C, $00, $E0
  .db $18, $1C, $40, $E8
  .db $20, $2C, $00, $E0
  .db $20, $2C, $40, $E8

doorknob:
  .db $39, $67, $00, $65

oldlady:
  .db $2C, $37, $00, $5C
  .db $2C, $37, $40, $63
  .db $34, $47, $00, $5C
  .db $34, $47, $40, $63
  .db $3C, $57, $00, $5C
  .db $3C, $57, $40, $63
  .db $40, $66, $00, $68
  .db $44, $67, $00, $5C
  .db $44, $67, $40, $63


village2sprites:
  .db $08, $67, $00, $C3
  .db $09, $2A, $00, $C0
  .db $09, $2A, $40, $C8

graves:
  .db $76, $0E, $00, $DD
  .db $76, $0F, $00, $E5
  .db $7E, $1E, $00, $DD
  .db $7E, $1F, $00, $E5

hydrant:
  .db $39, $2D, $00, $03

festoon: ; makes it more than 8 tiles in a row so I had to limit it at this point :(
  .db $22, $4A, $00, $BA
  ; .db $22, $00, $00, $C2
  .db $22, $4A, $00, $CA
  ; .db $22, $00, $00, $D2
  .db $22, $4A, $00, $DA

river:
  .db $07, $0D, $00, $60
  .db $07, $0D, $00, $68
  .db $0F, $0D, $00, $60
  .db $0F, $0D, $00, $68
  .db $17, $0D, $00, $60
  .db $17, $0D, $00, $68
  .db $1F, $0D, $00, $60
  .db $1F, $0D, $00, $68
  .db $37, $0D, $00, $60
  .db $37, $0D, $00, $68
  .db $3F, $0D, $00, $60
  .db $3F, $0D, $00, $68
  .db $47, $0D, $00, $60
  .db $47, $0D, $00, $68
  .db $4F, $0D, $00, $60
  .db $4F, $0D, $00, $68
  .db $57, $0D, $00, $60
  .db $57, $0D, $00, $68
  .db $5F, $0D, $00, $60
  .db $5F, $0D, $00, $68
  .db $67, $0D, $00, $60
  .db $67, $0D, $00, $68
  .db $6F, $0D, $00, $60
  .db $6F, $0D, $00, $68
  .db $77, $0D, $00, $60
  .db $77, $0D, $00, $68
  .db $7F, $0D, $00, $60
  .db $7F, $0D, $00, $68
  .db $87, $0D, $00, $60
  .db $87, $0D, $00, $68
  .db $8F, $0D, $00, $60
  .db $8F, $0D, $00, $68
  .db $97, $0D, $00, $60
  .db $97, $0D, $00, $68
  .db $9F, $0D, $00, $60
  .db $9F, $0D, $00, $68
  .db $A7, $0D, $00, $60
  .db $A7, $0D, $00, $68

ground:
  .db $87, $2E, $00, $DE
  .db $87, $2E, $40, $E3

  .db $98, $2E, $00, $CC
  .db $98, $2E, $40, $D3

  .db $88, $2E, $00, $BC
  .db $88, $2E, $40, $C3

ghostguard:
  .db $6A, $6B, $00, $88

cathousesprites:
  ; candles
  .db $51, $0B, $00, $58
  .db $79, $0B, $00, $A0

pentagram:
  .db $50, $31, $00, $70
  .db $50, $32, $00, $78
  .db $50, $32, $40, $7F
  .db $50, $31, $40, $87
  .db $58, $40, $00, $68
  .db $58, $41, $00, $70
  .db $58, $42, $00, $78
  .db $58, $42, $40, $7F
  .db $58, $41, $40, $87
  .db $58, $40, $40, $8F
  .db $60, $50, $00, $68
  .db $60, $51, $00, $70
  .db $60, $52, $00, $78
  .db $60, $52, $40, $7F
  .db $60, $51, $40, $87
  .db $60, $50, $40, $8F
  .db $68, $60, $00, $68
  .db $68, $61, $00, $70
  .db $68, $62, $00, $78
  .db $68, $62, $40, $7F
  .db $68, $61, $40, $87
  .db $68, $60, $40, $8F
  .db $70, $71, $00, $68
  .db $70, $72, $00, $78
  .db $70, $72, $40, $7F
  .db $70, $71, $40, $8F
  .db $78, $81, $00, $70
  .db $78, $82, $00, $78
  .db $78, $82, $40, $7F
  .db $78, $81, $40, $87

satan:
  .db $18, $5E, $02, $70
  .db $18, $5F, $02, $78
  .db $18, $5F, $42, $7F
  .db $18, $5E, $42, $87

  .db $20, $6D, $02, $68
  .db $20, $6E, $02, $70
  .db $20, $6F, $02, $78
  .db $20, $6F, $42, $7F
  .db $20, $6E, $42, $87
  .db $20, $6D, $42, $8F

  .db $2E, $67, $02, $6B
  .db $28, $7E, $02, $70
  .db $28, $7F, $02, $78
  .db $28, $7F, $42, $7F
  .db $28, $7E, $42, $87
  .db $2E, $67, $42, $8C

  .db $30, $8D, $02, $68
  .db $30, $8E, $02, $70
  .db $30, $8F, $02, $78
  .db $30, $8F, $42, $7F
  .db $30, $8E, $42, $87
  .db $30, $8D, $42, $8F

  .db $38, $9C, $02, $60
  .db $38, $9D, $02, $68
  .db $38, $9E, $02, $70
  .db $38, $9F, $02, $78
  .db $38, $9F, $42, $7F
  .db $38, $9E, $42, $87
  .db $38, $9D, $42, $8F
  .db $38, $9C, $42, $97

  .db $40, $AD, $02, $68
  .db $40, $AE, $02, $70
  .db $40, $AF, $02, $78
  .db $40, $AF, $42, $7F
  .db $40, $AE, $42, $87
  .db $40, $AD, $42, $8F

  .db $48, $BD, $02, $68
  .db $48, $BE, $02, $70
  .db $48, $BF, $02, $78
  .db $48, $BF, $42, $7F
  .db $48, $BE, $42, $87
  .db $48, $BD, $42, $8F

  .db $50, $CD, $02, $68
  .db $50, $CE, $02, $70
  .db $50, $CF, $02, $78
  .db $50, $CF, $42, $7F
  .db $50, $CE, $42, $87
  .db $50, $CD, $42, $8F

  .db $58, $DF, $02, $78
  .db $58, $DF, $42, $7F

  .db $60, $7D, $02, $77
  .db $60, $7D, $42, $80

satantilesperline:
  .db $00, $10, $18, $18, $18, $20, $18, $18, $18, $08, $08

skeletonhousesprites:
  ; candy man
  .db $2D, $35, $00, $B2
  .db $35, $43, $00, $A2
  .db $35, $44, $00, $AA
  .db $35, $45, $00, $B2
  .db $3D, $53, $00, $A2
  .db $3D, $54, $00, $AA
  .db $3D, $55, $00, $B2

jukebox:
  .db $1D, $36, $00, $48
  .db $1D, $36, $40, $50
  .db $25, $46, $00, $48
  .db $25, $46, $40, $50
  .db $2D, $56, $00, $48
  .db $2D, $56, $40, $50

catsign:
  .db $53, $33, $00, $4C

tables:
  .db $76, $70, $00, $47
  .db $76, $70, $40, $4F
  .db $7E, $80, $00, $47
  .db $7E, $80, $40, $4F

  .db $7E, $70, $00, $77
  .db $7E, $70, $40, $7F
  .db $86, $80, $00, $77
  .db $86, $80, $40, $7F

  .db $66, $70, $00, $A8
  .db $66, $70, $40, $B0
  .db $6E, $80, $00, $A8
  .db $6E, $80, $40, $B0

skeletons:
  .db $67, $63, $00, $47
  .db $67, $63, $40, $4F
  .db $6F, $73, $00, $47
  .db $6F, $73, $40, $4F
  .db $73, $64, $00, $47
  .db $73, $64, $40, $4F

  .db $3A, $63, $00, $6C
  .db $3A, $63, $40, $74
  .db $42, $73, $00, $6C
  .db $42, $73, $40, $74
  .db $46, $64, $00, $6C
  .db $46, $64, $40, $74
  .db $4B, $74, $00, $70

  .db $45, $63, $00, $85
  .db $45, $63, $40, $8D
  .db $4D, $73, $00, $85
  .db $4D, $73, $40, $8D
  .db $50, $84, $00, $85
  .db $50, $85, $40, $8D
  .db $56, $74, $00, $89

serverroomsprites:
  ; tv
  .db $33, $38, $00, $9F
  .db $33, $39, $00, $A7
  .db $33, $38, $40, $AA
  .db $3B, $38, $80, $9F
  .db $3B, $39, $80, $A7
  .db $3B, $38, $C0, $AA
  .db $38, $1A, $00, $A5
  .db $33, $48, $00, $B1
  .db $3B, $58, $00, $B1
  .db $43, $67, $00, $9D
  .db $43, $67, $00, $AE

  ; nes
  .db $48, $3A, $00, $94
  .db $48, $3B, $00, $9C
  .db $48, $3C, $00, $A4
  .db $43, $49, $00, $A1

  ; buckethat guy
  .db $55, $1D, $02, $4D
  .db $50, $2F, $02, $4A
  .db $50, $2F, $42, $52
  .db $58, $3F, $02, $4A
  .db $58, $3F, $42, $52
  .db $60, $4F, $02, $4A
  .db $60, $4F, $42, $52

  ; laptop
  .db $5F, $3D, $02, $57
  .db $5F, $3E, $02, $5F

  ; diodes
  .db $28, $4A, $01, $41
  .db $3C, $4A, $01, $81
  .db $34, $4A, $01, $54
  .db $24, $4A, $01, $64

ghostroom1sprites:
  ; table
  .db $5C, $77, $00, $73
  .db $5C, $77, $40, $7B
  .db $5C, $87, $00, $82
  .db $67, $2E, $00, $7B
  .db $67, $2E, $40, $80
  .db $61, $78, $00, $74
  .db $61, $78, $00, $7C
  .db $61, $78, $00, $83
  .db $64, $79, $00, $75
  .db $64, $79, $00, $7D
  .db $64, $79, $00, $82
  .db $6B, $88, $00, $75
  .db $6B, $88, $00, $77
  .db $6B, $88, $00, $79
  .db $6B, $88, $00, $88

  ; ghost
  .db $50, $4B, $02, $78
  .db $50, $4B, $42, $80
  .db $54, $67, $00, $78
  .db $54, $67, $00, $7E
  .db $4D, $76, $00, $78
  .db $4D, $76, $40, $80
  .db $55, $86, $00, $78
  .db $55, $86, $40, $80

  ; picture
  .db $30, $89, $00, $60

ghostroom2sprites:
  ; big ghost
  ; .db $4D, $67, $00, $90
  ; .db $4D, $67, $00, $96
  .db $60, $4C, $00, $93
  .db $58, $76, $00, $90
  .db $58, $76, $40, $98
  .db $60, $86, $00, $90
  .db $60, $86, $40, $98

  ; ghosts
  .db $50, $1C, $00, $68
  .db $50, $1C, $40, $70
  .db $58, $2C, $00, $68
  .db $58, $2C, $40, $70

  .db $68, $1C, $00, $58
  .db $68, $1C, $40, $60
  .db $70, $2C, $00, $58
  .db $70, $2C, $40, $60

expression:
  .db $21, $98, $80, $60
  .db $1F, $A0, $00, $80
  .db $20, $A1, $00, $8B
  .db $1F, $B2, $00, $95
  .db $21, $B3, $00, $9A

  .db $29, $90, $00, $60
  .db $29, $91, $00, $68
  .db $26, $92, $00, $70
  .db $27, $93, $00, $78
  .db $27, $94, $00, $80
  .db $28, $95, $00, $89
  .db $26, $96, $00, $91
  .db $26, $97, $00, $99

  .db $31, $98, $00, $60
  .db $2E, $A7, $00, $71
  .db $30, $A6, $00, $79
  .db $30, $A6, $00, $81
  .db $30, $A6, $00, $89
  .db $30, $A6, $00, $91
  .db $2E, $B5, $00, $99
  .db $30, $B3, $00, $82

  .db $38, $B0, $00, $63
  .db $38, $B1, $00, $6B
  .db $39, $B4, $00, $6C
  .db $38, $A2, $00, $75
  .db $38, $A3, $00, $7D
  .db $38, $A4, $00, $85
  .db $38, $A5, $00, $8D
  .db $39, $B4, $40, $93

expressiontilesperline:
  .db $14, $00, $20, $20, $00, $20

parksprites:
  ; bench
  .db $7C, $4D, $00, $25
  .db $7C, $4D, $00, $2D
  .db $7C, $4D, $00, $33
  .db $85, $4E, $00, $24
  .db $85, $4E, $00, $2C
  .db $85, $4E, $00, $34
  .db $84, $88, $00, $27
  .db $84, $88, $00, $37
  .db $7C, $88, $00, $27
  .db $7C, $88, $00, $37

  ; clouds
  .db $14, $5A, $02, $88
  .db $14, $5B, $02, $90
  .db $14, $5B, $42, $98
  .db $14, $5A, $42, $A0

  .db $0B, $5A, $02, $C8
  .db $0B, $5B, $02, $D0
  .db $0B, $5B, $42, $D8
  .db $0B, $5A, $42, $E0

  .db $10, $5A, $02, $30
  .db $10, $5B, $02, $38
  .db $10, $5B, $42, $40
  .db $10, $5A, $42, $48

  ; mushrooms
  .db $3F, $6C, $00, $90
  .db $3F, $6C, $00, $D0
  .db $67, $6C, $00, $B0

exhousesprites:
  ; reserved for projectiles
  .db $00, $00, $00, $00
  .db $00, $00, $00, $00

  ; ex
  .db $43, $6A, $00, $64
  .db $43, $6A, $40, $6B
  .db $4B, $7A, $00, $64
  .db $4B, $7A, $40, $6B
  .db $53, $8A, $00, $64
  .db $53, $8A, $40, $6B

flyingobjects:
  ; picture
  .db $38, $99, $00, $90

  ; door
  .db $40, $4E, $00, $A0
  .db $40, $4E, $00, $A8
  .db $40, $5C, $00, $A0
  .db $40, $5C, $40, $A8
  .db $47, $5C, $80, $A0
  .db $47, $5C, $C0, $A8
  .db $4F, $5D, $00, $A0
  .db $4F, $5D, $40, $A8
  .db $4E, $67, $01, $A8

exhouselines:
  .db $34, $4E, $01, $98
  .db $3C, $4E, $01, $B0
  .db $44, $4E, $01, $88

fireball:
  .db $7B, $00, $96 ; y is dynamic

hydrantsX:
  .db $58, $78, $90, $48, $80, $88, $78, $60
  .db $80, $48, $50, $78, $58, $58, $88, $78
  .db $80, $48, $78, $60, $50, $90, $48, $88

hydrantshadowsY:
  .db $68, $78, $88, $80, $58, $70, $60, $88
  .db $60, $68, $70, $88, $58, $80, $78, $70
  .db $88, $88, $58, $70, $80, $78, $60, $68

finalhydrant:
  .db $00, $2D, $00, $98

candy:
  .db $60, $4C, $01, $98
  .db $68, $4C, $02, $A8

gojira:
  .db $30, $A8, $00, $90
  .db $30, $A9, $00, $98
  .db $30, $AA, $00, $A0
  .db $38, $B8, $00, $90
  .db $38, $B9, $00, $98
  .db $38, $BA, $00, $A0
  .db $38, $BB, $00, $A8
  .db $38, $BC, $00, $B0
  .db $40, $C8, $00, $90
  .db $40, $C9, $00, $98
  .db $40, $CA, $00, $A0
  .db $40, $CB, $00, $A8
  .db $40, $CC, $00, $B0
gojiraleftleg:
  .db $48, $D8, $00, $90
  .db $48, $D9, $00, $98
  .db $50, $E8, $00, $90
  .db $50, $E9, $00, $98
gojirarightleg:
  .db $48, $DA, $00, $A0
  .db $48, $DB, $00, $A8
  .db $50, $EA, $00, $A0
  .db $50, $EB, $00, $A8
  .db $58, $AB, $00, $A2

  .db $48, $DC, $00, $B0
  .db $50, $EC, $00, $B0

gojiraleftlegup:
  .db $B6, $B7, $C6, $C7
  
gojirarightlegup:
  .db $D6, $D7, $E6, $E7, $00

gojirajumpacceleration:
  .db $05, $04, $04, $03, $03, $02, $02, $01, $01, $00, $FF

projectileacceleration:
  .db $01, $01, $01, $01, $02, $02, $02, $02, $03, $03, $03

endsprites:
  ; cat
  .db $9F, $02, $00, $20
  .db $9F, $03, $00, $28
  .db $A7, $E4, $00, $20
  .db $A7, $E5, $00, $28
  .db $AF, $F4, $00, $25

  ; cat skateboard
  .db $B2, $F6, $02, $1E
  .db $B2, $F6, $42, $2A
  .db $B2, $F7, $42, $26

  ; satan
  .db $6B, $1D, $01, $57
  .db $6C, $1D, $01, $59
  .db $79, $1D, $01, $3A
  .db $64, $1D, $01, $45
  .db $59, $C1, $02, $52
  .db $59, $C0, $02, $4A
  .db $5F, $6D, $02, $3B
  .db $57, $5E, $02, $43
  .db $5F, $6E, $02, $43
  .db $61, $D0, $02, $4A
  .db $61, $D1, $02, $52
  .db $69, $E0, $01, $4A
  .db $69, $E1, $01, $52
  .db $6A, $C2, $02, $34
  .db $72, $D2, $02, $34
  .db $7A, $BD, $02, $31
  .db $82, $CD, $02, $31
  .db $6A, $C3, $01, $3C
  .db $6A, $C4, $01, $44
  .db $72, $D3, $02, $3C
  .db $72, $D4, $02, $44
  .db $70, $F1, $02, $5A
  .db $78, $BD, $42, $5B
  .db $80, $CD, $42, $5B
  .db $71, $F0, $02, $4D
  .db $7B, $C5, $02, $40
  .db $7C, $1D, $01, $44
  .db $7C, $D5, $02, $4D
  .db $7E, $E3, $02, $40
  .db $7D, $E3, $02, $4F
  .db $86, $F3, $02, $43
  .db $85, $F3, $02, $52
  .db $8E, $E2, $01, $41
  .db $8D, $E2, $01, $50
  .db $96, $F2, $02, $43
  .db $95, $F2, $02, $52

  ; satan skateboard
  .db $96, $F8, $00, $37
  .db $9C, $F9, $00, $3F
  .db $9B, $F7, $00, $46
  .db $9B, $F7, $00, $4E
  .db $9C, $F9, $00, $56
  .db $96, $F8, $40, $5E

  ; stars
  .db $0A, $AC, $00, $08
  .db $1A, $AC, $40, $36
  .db $0A, $AC, $C0, $64
  .db $1A, $AC, $00, $92
  .db $0A, $AC, $80, $C0
  .db $1A, $AC, $C0, $EE

  ; the end
  .db $BA, $FA, $00, $66
  .db $BA, $FB, $00, $6E
  .db $BA, $FC, $00, $76
  .db $BA, $FC, $00, $86
  .db $BA, $DD, $00, $8E
  .db $BA, $DE, $00, $96

deadsprites:
  .db $62, $ED, $00, $74
  .db $62, $EE, $00, $7C
  .db $66, $EF, $00, $84
  .db $6A, $FD, $00, $74
  .db $6A, $FE, $00, $7C
  .db $62, $1D, $00, $80
  .db $6B, $1D, $00, $80

  ; ghost
  .db $52, $6B, $00, $7C

skull0:
  .db $1E,$1F,$2F,$2E

skull1:
  .db $2E,$1E,$1F,$2F

skull2:
  .db $2F,$2E,$1E,$1F

skull3:
  .db $1F,$2F,$2E,$1E

titlecolor:
  .db $AA,$55,$FF;,$EE,$BB,$77,$DD,$66,$99

music:
  .db $83,$FF,$3C,$44,$42,$38,$32,$83,$FE

xalins:
  .db $47,$30,$3B,$38,$3D,$42,$FE

my_dad:
  .db $3C,$48,$FF,$33,$30,$33,$FE

all_else:
  .db $73,$30,$3B,$3B,$FF,$34,$3B,$42,$34,$73,$FE

shinryakuwu:
  .db $42,$37,$38,$3D,$41,$48,$30,$3A,$44,$46,$44,$FE

front:
      ;tiles                        ;attributes                   ;animation
  .db $10, $10, $20, $20, $30, $04, $00, $40, $00, $40, $00, $40, $30, $04, $30, $05, $30, $04, $06, $04

back:
  .db $01, $01, $14, $11, $16, $21, $00, $40, $00, $40, $00, $40, $14, $11, $16, $21, $15, $17, $25, $26, $14, $11, $16, $21, $17, $15, $16, $27

left:
  .db $03, $02, $13, $12, $22, $23, $40, $40, $40, $40, $00, $00, $22, $23, $18, $19, $22, $23, $28, $29

right:
  .db $02, $03, $12, $13, $22, $23, $00, $00, $00, $00, $00, $00, $22, $23, $07, $08, $22, $23, $09, $0A

village1cathousewarp:
      ;vert                         ;horiz
  .db $80, $80, $88, $88, $90, $90, $78, $80, $78, $80, $78, $80

cathousevillage1warp:
  .db $80, $80, $88, $88, $90, $90, $3C, $44, $3C, $44, $3C, $44

village1village2warp:
  .db $20, $20, $28, $28, $30, $30, $0C, $14, $0C, $14, $0C, $14

village1parkwarp:
  .db $90, $90, $98, $98, $A0, $A0, $14, $1C, $14, $1C, $14, $1C

ghostroom1parkwarp:
  .db $30, $30, $38, $38, $40, $40, $B4, $BC, $B4, $BC, $B4, $BC

village2village1warp:
  .db $20, $20, $28, $28, $30, $30, $E8, $F0, $E8, $F0, $E8, $F0

village1skeletonhousewarp:
  .db $80, $80, $88, $88, $90, $90, $60, $68, $60, $68, $60, $68

skeletonhousevillage1warp:
  .db $70, $70, $78, $78, $80, $80, $B8, $C0, $B8, $C0, $B8, $C0

village2serverroomwarp:
  .db $78, $78, $80, $80, $88, $88, $78, $80, $78, $80, $78, $80

serverroomvillage2warp:
  .db $68, $68, $70, $70, $78, $78, $2C, $34, $2C, $34, $2C, $34

ghostroom2village2warp:
  .db $80, $80, $88, $88, $90, $90, $9C, $A4, $9C, $A4, $9C, $A4

ghostroomwarp:
  .db $75, $75, $7D, $7D, $85, $85, $78, $80, $78, $80, $78, $80

parkvillage1warp:
  .db $08, $08, $10, $10, $18, $18, $14, $1C, $14, $1C, $14, $1C

village2exhousewarp:
  .db $80, $80, $88, $88, $90, $90, $58, $60, $58, $60, $58, $60

exhousevillage2warp:
  .db $30, $30, $38, $38, $40, $40, $C0, $C8, $C0, $C8, $C0, $C8

deadcathousewarp:
  .db $58, $58, $60, $60, $68, $68, $73, $7B, $73, $7B, $73, $7B
