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
  CMP #$08
  BEQ ParkWarpCheck
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
ParkWarpCheck:
  JSR ParkVillage1WarpCheck
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
  BNE Village1ParkWarpCheck
  LDA currentYtile
  CMP #$0F
  BEQ Village1SkeletonHouseWarp
Village1ParkWarpCheck:
  LDA currentYtile
  CMP #$01
  BEQ Village1ParkWarp
	RTS

Village1CatHouseWarp:
  LDA #LOW(cathouseparams)
  STA currentbgparams
  LDA #HIGH(cathouseparams)
  STA currentbgparams+1
  LDA #LOW(village1cathousewarp)
  STA warpXYlow
  LDA #HIGH(village1cathousewarp)
  STA warpXYhigh
  JSR SatanEventParams
  JSR PrepareForBGRender
  RTS

Village1Village2Warp:
  JSR SetVillage2Params
  LDA #LOW(village1village2warp)
  STA warpXYlow
  LDA #HIGH(village1village2warp)
  STA warpXYhigh
  JSR PrepareForBGRender
  RTS

Village1SkeletonHouseWarp:
  LDA #LOW(skeletonhouseparams)
  STA currentbgparams
  LDA #HIGH(skeletonhouseparams)
  STA currentbgparams+1
  LDA #LOW(village1skeletonhousewarp)
  STA warpXYlow
  LDA #HIGH(village1skeletonhousewarp)
  STA warpXYhigh
  JSR PrepareForBGRender
  RTS

Village1ParkWarp:
  JSR SetParkParams
  LDA #LOW(village1parkwarp)
  STA warpXYlow
  LDA #HIGH(village1parkwarp)
  STA warpXYhigh
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
  JSR SetVillage1Params
  LDA #LOW(cathousevillage1warp)
  STA warpXYlow
  LDA #HIGH(cathousevillage1warp)
  STA warpXYhigh
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
  BNE Village2GhostRoom1WarpCheck
  LDA currentXtile
  CMP #$05
  BEQ Village2ServerRoomWarp
  CMP #$06
  BEQ Village2ServerRoomWarp
Village2GhostRoom1WarpCheck:
  LDA currentYtile
  CMP #$11
  BNE Village2ExHouseWarpCheck
  LDA currentXtile
  CMP #$13
  BEQ Village2GhostRoom1Warp
  CMP #$14
  BEQ Village2GhostRoom1Warp
Village2ExHouseWarpCheck:
  RTS

Village2Village1Warp:
  JSR SetVillage1Params
  LDA #LOW(village2village1warp)
  STA warpXYlow
  LDA #HIGH(village2village1warp)
  STA warpXYhigh
  JSR PrepareForBGRender
  RTS

Village2ServerRoomWarp:
  LDA #LOW(serverroomparams)
  STA currentbgparams
  LDA #HIGH(serverroomparams)
  STA currentbgparams+1
  LDA #LOW(village2serverroomwarp)
  STA warpXYlow
  LDA #HIGH(village2serverroomwarp)
  STA warpXYhigh
  JSR PrepareForBGRender
  RTS

Village2GhostRoom1Warp:
  LDA #LOW(ghostroom1params)
  STA currentbgparams
  LDA #HIGH(ghostroom1params)
  STA currentbgparams+1
  LDA #LOW(village2ghostroom1warp)
  STA warpXYlow
  LDA #HIGH(village2ghostroom1warp)
  STA warpXYhigh
  LDA #LOW(office_ghost)
  STA currenttextlow
  LDA #HIGH(office_ghost)
  STA currenttexthigh
  LDA #$10
  STA textpartscounter
  LDA #$04
  STA action
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
  JSR SetVillage1Params
  LDA #LOW(skeletonhousevillage1warp)
  STA warpXYlow
  LDA #HIGH(skeletonhousevillage1warp)
  STA warpXYhigh
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
  JSR SetVillage2Params
  LDA #LOW(serverroomvillage2warp)
  STA warpXYlow
  LDA #HIGH(serverroomvillage2warp)
  STA warpXYhigh
  JSR PrepareForBGRender
  RTS

ParkVillage1WarpCheck:
  LDA currentYtile
  CMP #$16
  BNE ParkVillage1WarpCheckDone
  LDA currentXtile
  CMP #$08
  BCC ParkVillage1Warp
ParkVillage1WarpCheckDone:
  RTS

ParkVillage1Warp:
  JSR SetVillage1Params
  LDA #LOW(parkvillage1warp)
  STA warpXYlow
  LDA #HIGH(parkvillage1warp)
  STA warpXYhigh
  JSR PrepareForBGRender
  RTS

SetVillage1Params:
  LDA #LOW(village1params)
  STA currentbgparams
  LDA #HIGH(village1params)
  STA currentbgparams+1
  RTS

SetVillage2Params:
  LDA #LOW(village2params)
  STA currentbgparams
  LDA #HIGH(village2params)
  STA currentbgparams+1
  RTS

SetParkParams:
  LDA #LOW(parkparams)
  STA currentbgparams
  LDA #HIGH(parkparams)
  STA currentbgparams+1
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
  STA nmiwaitcounter  ; skip nmi subroutines in the first n frames after bg is changed
SetBgParams:
  LDY #$00
SetBgParamsLoop:
  LDA [currentbgparams], y
  STA BGPARAMSADDRESS, y
  INY
  CPY #BGPARAMSCOMPARE
  BNE SetBgParamsLoop
  RTS
