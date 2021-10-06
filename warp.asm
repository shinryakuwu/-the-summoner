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
	LDA currentYtile
	CMP #$11
	BNE Village1ForestWarpCheck
	LDA currentXtile
	CMP #$07
	BEQ Village1CatHouseWarp
	CMP #$08
	BEQ Village1CatHouseWarp
Village1ForestWarpCheck:
	RTS

Village1CatHouseWarp:
  LDA #$01
  STA location
  STA singleattribute
  LDA #LOW(catroom)
  STA currentbglow
  LDA #HIGH(catroom)
  STA currentbghigh
  LDA #LOW(village1cathousewarp)
  STA warpXYlow
  LDA #HIGH(village1cathousewarp)
  STA warpXYhigh
  LDA #LOW(cathousesprites)
  STA curntspriteslow
  LDA #HIGH(cathousesprites)
  STA curntspriteshigh
  LDA #$08
  STA spritescompare
  JSR PrepareForBGRender
  JSR ChangeCatCoordinates
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
  STA singleattribute
  STA attributenumber
  LDA #LOW(village1)
  STA currentbglow
  LDA #HIGH(village1)
  STA currentbghigh
  LDA #LOW(cathousevillage1warp)
  STA warpXYlow
  LDA #HIGH(cathousevillage1warp)
  STA warpXYhigh
  LDA #LOW(village1sprites)
  STA curntspriteslow
  LDA #HIGH(village1sprites)
  STA curntspriteshigh
  LDA #$30
  STA spritescompare
  JSR PrepareForBGRender
  JSR ChangeCatCoordinates
  RTS

PrepareForBGRender:
  LDA #$01         ; activate background rendering and perform it via main loop (outside of NMI)
  STA bgrender
  STA mainloop
  LDA #%00000110   ; disable rendering
  STA $2001
  RTS

ChangeCatCoordinates:
	LDA #$04          ; warp via transform loop
  STA trnsfrm
  LDA #$18          ; compare pointer to $18 via transform loop
  STA trnsfrmcompare
  LDX #$00
  LDY #$00
  JSR ObjectTransformLoop
  RTS