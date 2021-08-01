Warp:
	; compare current x and y to needed numbers and compare position, if everything matches, perform a warp
	LDA location
	CMP #$00
	BEQ Village1CatHouseWarpCheck
	LDA location
	CMP #$01
	BEQ CatHouseVillage1WarpCheck
	RTS

	; if the code becomes too long for jumping, add list of subroutines here, 
	; f.e. BEQ Village1WarpCheck > Village1WarpCheck: JSR Village1CatHouseWarpCheck + RTS

Village1CatHouseWarpCheck:
	LDA currentXtile
	CMP #$08
	BNE Village1ForestWarpCheck
	LDA currentYtile
	CMP #$11
	BEQ Village1CatHouseWarp
Village1ForestWarpCheck:
	RTS

Village1CatHouseWarp:
  LDA #$01
  STA location
  LDA #LOW(catroom)
  STA currentbglow
  LDA #HIGH(catroom)
  STA currentbghigh
  JSR PrepareForBGRender
  RTS

CatHouseVillage1WarpCheck:
	LDA currentXtile
	CMP #$0F
	BNE Village1ForestWarpCheck
	LDA currentYtile
	CMP #$13
	BNE CatHouseVillage1WarpCheckDone
	LDA direction
	CMP #$00
	BEQ CatHouseVillage1Warp
CatHouseVillage1WarpCheckDone:
	RTS

CatHouseVillage1Warp:
	LDA #$00
  STA location
  LDA #LOW(village1)
  STA currentbglow
  LDA #HIGH(village1)
  STA currentbghigh
  JSR PrepareForBGRender
  RTS

PrepareForBGRender:
  LDA #$01
  STA bgrender
  STA mainloop
  LDA #%00000110   ; disable rendering
  STA $2001
  RTS