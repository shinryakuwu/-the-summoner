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
  CMP #$04
  BEQ ServerRoomWarpCheck
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
ServerRoomWarpCheck:
  JSR ServerRoomVillage2WarpCheck
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
  CMP #$08
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
  ; TODO: refactor setting singleattribute across the file, it might be unnecessary in some places
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
  ; LDA #$D8
  STA spritescompare
  JSR SatanEventParams
  JSR PrepareForBGRender
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
  LDA #$DC
  STA spritescompare
  JSR PrepareForBGRender
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
  LDA #$B8
  STA spritescompare
  JSR PrepareForBGRender
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
  RTS

Village2Village1WarpCheck:
	LDA currentYtile
	CMP #$06
	BNE Village2ServerRoomWarpCheck
	LDA currentXtile
	BEQ Village2Village1Warp ; when equals zero
Village2ServerRoomWarpCheck:
  LDA currentYtile
  CMP #$0D
  BNE Village2ExHouseWarpCheck
  LDA currentXtile
  CMP #$05
  BEQ Village2ServerRoomWarp
  CMP #$06
  BEQ Village2ServerRoomWarp
Village2ExHouseWarpCheck:
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
  RTS

Village2ServerRoomWarp:
  LDA #$04
  STA location
  LDA #LOW(serverroom)
  STA currentbglow
  LDA #HIGH(serverroom)
  STA currentbghigh
  LDA #LOW(village2serverroomwarp)
  STA warpXYlow
  LDA #HIGH(village2serverroomwarp)
  STA warpXYhigh
  LDA #LOW(serverroomsprites)
  STA curntspriteslow
  LDA #HIGH(serverroomsprites)
  STA curntspriteshigh
  LDA #$70
  STA spritescompare
  JSR PrepareForBGRender
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
  RTS

ServerRoomVillage2WarpCheck:
  LDA currentXtile
  CMP #$0F
  BNE ServerRoomVillage2WarpCheckDone
  LDA currentYtile
  CMP #$12
  BNE ServerRoomVillage2WarpCheckDone
  LDA direction
  BEQ ServerRoomVillage2Warp ; when equals zero
ServerRoomVillage2WarpCheckDone:
  RTS

ServerRoomVillage2Warp:
  LDA #$02
  STA location
  LDA #$01
  STA singleattribute
  LDA #LOW(village2)
  STA currentbglow
  LDA #HIGH(village2)
  STA currentbghigh
  LDA #LOW(serverroomvillage2warp)
  STA warpXYlow
  LDA #HIGH(serverroomvillage2warp)
  STA warpXYhigh
  LDA #LOW(village2sprites)
  STA curntspriteslow
  LDA #HIGH(village2sprites)
  STA curntspriteshigh
  LDA #$DC
  STA spritescompare
  JSR PrepareForBGRender
  RTS

SatanEventParams:
  LDA candyswitches
  AND #CANDYGATHERED
  CMP #CANDYGATHERED
  BNE SatanEventParamsDone
  LDA #$43
  STA eventnumber
  LDA #$0F
  STA walkcounter
  LDA #$20
  STA eventwaitcounter
  LDA #$08
  STA action
SatanEventParamsDone:
  RTS

PrepareForBGRender:
  LDA #$01            ; activate background rendering and perform it via main loop (outside of NMI)
  STA bgrender
  STA mainloop
  LDA #$02
  STA nmiwaitcounter  ; skip nmi subroutines in the first frame after bg is changed
  RTS
