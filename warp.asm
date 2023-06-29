Warp:
	; compare current x and y to needed numbers and compare position, if everything matches, perform a warp
	LDA location
	BEQ Village1WarpCheck ; when equals zero
	CMP #$01
	BEQ CatHouseWarpCheck
	CMP #$02
	BEQ Village2WarpCheck
  CMP #$03
  BEQ SkeletonHouseWarpCheck
	RTS

Village1WarpCheck:
	JSR Village1CatHouseWarpCheck
	RTS
CatHouseWarpCheck:
	JSR CatHouseVillage1WarpCheck
	RTS
Village2WarpCheck:
	JSR Village2Village1WarpCheck
	RTS
SkeletonHouseWarpCheck:
  JSR SkeletonHouseVillage1WarpCheck
  RTS

Village1CatHouseWarpCheck:
	LDA currentYtile
	CMP #$11
	BNE Village1Village2WarpCheck
	LDA currentXtile
	CMP #$07
	BEQ Village1CatHouseWarp
	CMP #$08
	BEQ Village1CatHouseWarp
Village1Village2WarpCheck:
	LDA currentXtile
	CMP #$1F
	BNE Village1SkeletonHouseWarpCheck
	LDA currentYtile
	CMP #$06
	BEQ Village1Village2Warp
	CMP #$07
	BEQ Village1Village2Warp
Village1SkeletonHouseWarpCheck:
  LDA currentXtile
  CMP #$17
  BNE Village1ForestWarpCheck
  LDA currentYtile
  CMP #$0F
  BEQ Village1SkeletonHouseWarpJump
Village1ForestWarpCheck:
	RTS

Village1CatHouseWarp:
  LDA #$01
  STA location
  STA singleattribute
  LDA #$00
  STA attributenumber
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
  LDA #$80             ; this number identifies how many sprites need to be loaded
  STA spritescompare
  JSR PrepareForBGRender
  JSR ChangeCatCoordinates
  RTS

Village1SkeletonHouseWarpJump:
  JMP Village1SkeletonHouseWarp ; was out of range

Village1Village2Warp:
  LDA #$02
  STA location
  LDA #$01
  STA singleattribute
  LDA #LOW(village2)
  STA currentbglow
  LDA #HIGH(village2)
  STA currentbghigh
  LDA #LOW(village1village2warp)
  STA warpXYlow
  LDA #HIGH(village1village2warp)
  STA warpXYhigh
  LDA #LOW(village2sprites)
  STA curntspriteslow
  LDA #HIGH(village2sprites)
  STA curntspriteshigh
  LDA #$C8
  STA spritescompare
  JSR PrepareForBGRender
  JSR ChangeCatCoordinates
  RTS

Village1SkeletonHouseWarp:
  LDA #$03
  STA location
  LDA #$01
  STA singleattribute
  LDA #LOW(skeletonhouse)
  STA currentbglow
  LDA #HIGH(skeletonhouse)
  STA currentbghigh
  LDA #LOW(village1skeletonhousewarp)
  STA warpXYlow
  LDA #HIGH(village1skeletonhousewarp)
  STA warpXYhigh
  LDA #LOW(skeletonhousesprites)
  STA curntspriteslow
  LDA #HIGH(skeletonhousesprites)
  STA curntspriteshigh
  LDA #$C0
  STA spritescompare
  JSR PrepareForBGRender
  JSR ChangeCatCoordinates
  RTS

CatHouseVillage1WarpCheck:
	LDA currentXtile
	CMP #$0F
	BNE CatHouseVillage1WarpCheckDone
	LDA currentYtile
	CMP #$13
	BNE CatHouseVillage1WarpCheckDone
	LDA direction
	BEQ CatHouseVillage1Warp ; when equals zero
CatHouseVillage1WarpCheckDone:
	RTS

CatHouseVillage1Warp:
	LDA #$00
  STA location
  STA singleattribute
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

Village2Village1WarpCheck:
	LDA currentYtile
	CMP #$06
	BNE Village2ExHouseCheck
	LDA currentXtile
	BEQ Village2Village1Warp ; when equals zero
Village2ExHouseCheck:
	RTS

Village2Village1Warp:
	LDA #$00
  STA location
  STA singleattribute
  LDA #LOW(village1)
  STA currentbglow
  LDA #HIGH(village1)
  STA currentbghigh
  LDA #LOW(village2village1warp)
  STA warpXYlow
  LDA #HIGH(village2village1warp)
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

SkeletonHouseVillage1WarpCheck:
  LDA currentXtile
  CMP #$0C
  BNE SkeletonHouseVillage1WarpCheckDone
  LDA currentYtile
  CMP #$13
  BNE SkeletonHouseVillage1WarpCheckDone
  LDA direction
  BEQ SkeletonHouseVillage1Warp ; when equals zero
SkeletonHouseVillage1WarpCheckDone:
  RTS

SkeletonHouseVillage1Warp:
  LDA #$00
  STA location
  STA singleattribute
  LDA #LOW(village1)
  STA currentbglow
  LDA #HIGH(village1)
  STA currentbghigh
  LDA #LOW(skeletonhousevillage1warp)
  STA warpXYlow
  LDA #HIGH(skeletonhousevillage1warp)
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