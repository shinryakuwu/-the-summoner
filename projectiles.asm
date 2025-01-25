DrawProjectiles:
	LDA fightstate ; this logic is only for drawing fireballs, hydrants hit PPU directly
	CMP #$05
	BCS DrawProjectilesDone
	LDA projectilenumber
	BEQ DrawProjectilesDone
	LDA projectileframe
	BEQ DrawProjectilesFrame0
DrawProjectilesFrame1:
	DEC projectileframe
	LDX #$04
	JMP DrawProjectilesFromCache
	RTS
DrawProjectilesFrame0:
	INC projectileframe
	LDX #$00
	JMP DrawProjectilesFromCache
DrawProjectilesDone:
	RTS

DrawProjectilesFromCache:
	LDY #$00
DrawProjectilesFromCacheLoop:
	LDA projectilecache, x
	STA PROJECTILESPPUADDRESS, y
	INX
	INY
	CPY #$04
	BNE DrawProjectilesFromCacheLoop
	RTS

ProcessProjectiles:
	LDX projdestroyed
	CPX projectilenumber
	BEQ ProjectileCycleEnded
ProcessProjectilesLoop:
	CPX projectilenumber
	BCS ProcessProjectilesLoopDone
	JSR ProjectileLifecycle
	INX
	JMP ProcessProjectilesLoop
ProjectileCycleEnded:
	LDA #$00
	STA projectilenumber
	STA projdestroyed
ProcessProjectilesLoopDone:
	RTS

ProjectileLifecycle:
	LDA fightstate ; different logic for hydrants
	CMP #$05
	BCS HydrantLifecycle
	LDA projectilestate, x
	CMP #$0B
	BCC ProjectileFallsDown
	BEQ ProjectileFallsWithCondition
	CMP #$0C
	BEQ ProjectileMovesLeft
	CMP #$0D
	BEQ ProjectileTimeOut
	RTS

HydrantLifecycle:
	JSR HydrantLifecycleSubroutine
	RTS

ProjectileFallsDown:
	TXA
	PHA
	ASL A
	ASL A                ; multiply by 4
	TAX
	LDY projectilestate, x  ; serves as acceleration pointer here
	LDA projectilecache, x
	CLC
	ADC projectileacceleration, y ; alter projectile's Y coordinate
	STA projectilecache, x
	INX
	INX
	INX
	DEC projectilecache, x ; alter projectile's X coordinate
	PLA
	TAX
	INC projectilestate, x
	RTS

ProjectileFallsWithCondition:
	TXA
	PHA
	ASL A
	ASL A                ; multiply by 4
	TAX
	LDA projectilecache, x
	CMP $0200
	BCS ProjectileAlignsWithCat
	CLC
	ADC #$04
	STA projectilecache, x
	PLA
	TAX
	RTS
ProjectileAlignsWithCat:
	PLA
	TAX
	INC projectilestate, x
	RTS

ProjectileMovesLeft:
	TXA
	PHA
	ASL A
	ASL A  ; multiply by 4
	TAX
	INX
	INX
	INX
	LDA projectilecache, x
	CMP #$40
	BCC ProjectileReachesWall
	DEC projectilecache, x
	DEC projectilecache, x
	PLA
	TAX
	RTS
ProjectileReachesWall:
	DEX
	DEX
	LDA #$7C
	STA projectilecache, x
	PLA
	TAX
	INC projectilestate, x
	LDA #PROJECTILEDELAY
	STA projectiledelay, x
	RTS

ProjectileTimeOut:
	LDA projectiledelay, x
	BEQ DestroyProjectile
	DEC projectiledelay, x
	RTS
DestroyProjectile:
	TXA
	PHA
	ASL A
	ASL A  ; multiply by 4
	TAX
	INX
	LDA #$00
	STA projectilecache, x
	INC projdestroyed
	PLA
	TAX
	LDA #$00
	STA projectilestate, x
	RTS

BossThrowsFireballs:
	LDA fireballsstate
	BEQ BossSpawnsFireball
	CMP #$01
	BEQ BossThrowsFireballsTimeout
	RTS

BossSpawnsFireball:
	JSR DefineProjectileNumberLimit ; current limit will be in A
	CMP projectilenumber
	BEQ BossThrowsFireballsDone
	; when limit not reached, proceed throwing fireballs
	JSR BossOpensMouth
	LDA #$07
  JSR sound_load
  ; load a fireball tile into projectile cache
	LDA projectilenumber
	ASL A
	ASL A    ; multiply by 4 to make it a pointer
	TAX
	LDA $0238
	CLC
	ADC #$03 ; offset
	STA projectilecache, x
	LDY #$00
LoadProjectileLoop:
	INX
	LDA fireball, y
	STA projectilecache, x
	INY
	CPY #$03
	BNE LoadProjectileLoop
	LDA #$08
	STA movecounter
	INC fireballsstate
	INC projectilenumber
	RTS

BossThrowsFireballsTimeout:
	JSR CheckBossJump
	LDA movecounter
	BEQ BossThrowsFireballsTimeoutDone
	DEC movecounter
	RTS
BossThrowsFireballsTimeoutDone:
	DEC fireballsstate
	RTS

BossThrowsFireballsDone:
	LDA #$00
	STA fireballsstate
	LDA fightcycle
	CMP #BOSSSECONDPHASELENGTH
	BEQ BossThrowsFireballsPhaseDone
	JSR BossClosesMouth
	INC fightstate
	INC fightcycle
	RTS
BossThrowsFireballsPhaseDone:
	LDA #$02
	STA fightstate
	LDA #$00
	STA fightcycle
	RTS

FallingHydrantsTimeout:
	LDA movecounter
	BEQ FallingHydrantsTimeoutDone
	DEC movecounter
	RTS
FallingHydrantsTimeoutDone:
	LDA #$04
	STA dinojumpcount
	LDA #$00
	STA projectilenumber
	STA hydrantsstate
	INC fightstate
	RTS

FallingHydrantsStopShakescreen:
	LDA movecounter
	BEQ FallingHydrantsStopShakescreenDone
	DEC movecounter
	RTS
FallingHydrantsStopShakescreenDone:
	LDA #$00
  STA shakescreen
  STA hydrantsstate
	RTS

FinalHydrantLoad:
	LDX #$00
FinalHydrantLoadLoop:
	LDA finalhydrant, x
	STA $0218, x
	INX
	CPX #$04
	BNE FinalHydrantLoadLoop
	INC hydrantsstate
	RTS

FinalHydrantFall:
	LDA $0218
	CLC
	ADC #$08 ; add offset
	CMP $023C
	BCS FinalHydrantFallDone
	INC $0218
	INC $0218
	RTS
FinalHydrantFallDone:
	LDA #$08
  JSR sound_load
	LDA #$8C
	STA $023D
	LDA #BOSSDEFEATEDDELAY
	STA movecounter
	INC fightstate
	INC fightstate
	INC hydrantsstate
	RTS

FallingHydrants:
	LDA hydrantsstate
	BEQ FallingHydrantsDrop
	CMP #$01
	BEQ FallingHydrantsDelay
	CMP #$02
	BEQ FallingHydrantsTimeout
	CMP #$03
	BEQ FallingHydrantsStopShakescreen
	CMP #$04
	BEQ FinalHydrantLoad
	CMP #$05
	BEQ FinalHydrantFall
	RTS

FallingHydrantsDelay:
	LDA movecounter
	BEQ FallingHydrantsDelayDone
	DEC movecounter
	RTS
FallingHydrantsDelayDone:
	DEC hydrantsstate
	RTS

FallingHydrantsDrop:
	LDA projectilenumber
	CMP #HYDRANTSMAX
	BEQ FallingHydrantsDropCycleDone
	ASL A ; transform to pointer, multiply by 8
	ASL A
	ASL A
	TAX
	LDY hydrantpointer
	; render hydrant
	LDA #$00
	STA HYDRANTSPPUADDRESS, x
	INX
	LDA #$2D
	STA HYDRANTSPPUADDRESS, x
	INX
	INX
	LDA hydrantsX, y
	STA HYDRANTSPPUADDRESS, x
	; render shadow
	INX
	LDA hydrantshadowsY, y
	STA HYDRANTSPPUADDRESS, x
	INX
	LDA #$68
	STA HYDRANTSPPUADDRESS, x
	INX
	LDA #$02
	STA HYDRANTSPPUADDRESS, x
	INX
	LDA hydrantsX, y
	STA HYDRANTSPPUADDRESS, x
	DEC HYDRANTSPPUADDRESS, x ; move shadow 1 px to the left
	LDX projectilenumber
	LDA #$00
	STA projectilestate, x ; renew projectile status
	INC projectilenumber
	INC hydrantpointer
	INC hydrantsstate
	LDA #HYDRANTSDELAY
	STA movecounter
	RTS
FallingHydrantsDropCycleDone:
	LDA fightcycle
	CMP #BOSSTHIRDPHASELENGTH
	BEQ FallingHydrantsDropDone
	INC fightcycle
	LDA #$02
	STA hydrantsstate ; timeout
	LDA #HYDRANTSTIMEOUT
	STA movecounter
	RTS
FallingHydrantsDropDone:
	LDA #$04
	STA hydrantsstate
	RTS

HydrantLifecycleSubroutine:
	LDA projectilestate, x
	BEQ HydrantFallsDown
	CMP #$01
	BEQ HydrantFallsDownWithDamage
	CMP #$11
	BCC HydrantBlinks
	BEQ HydrantDestroyed
	RTS

HydrantFallsDown:
	TXA
	PHA
	ASL A
	ASL A
	ASL A                     ; multiply by 8
	TAX
	CLC
	ADC #$04
	TAY
	LDA HYDRANTSPPUADDRESS, x ; get hydrant y coordinate
	CLC
	ADC #$18                  ; add offset
	CMP HYDRANTSPPUADDRESS, y ; compare hydrant y to shadow y
	BCS HydrantFallsDownDamageState
	JMP AlterHydrantCoordinates
HydrantFallsDownDamageState:
	INC HYDRANTSPPUADDRESS, x ; move hydrant's y coordinate by 2 pixels each frame
	INC HYDRANTSPPUADDRESS, x
	JMP AlterHydrantState

HydrantFallsDownWithDamage:
	TXA
	PHA
	ASL A
	ASL A
	ASL A                     ; multiply by 8
	TAX
	CLC
	ADC #$04
	TAY
	LDA HYDRANTSPPUADDRESS, y ; get shadow y coordinate
	SEC
	SBC #$03                  ; add offset
	CMP HYDRANTSPPUADDRESS, x ; compare hydrant y to shadow y
	BCC HydrantFallsDownDone
AlterHydrantCoordinates:
	INC HYDRANTSPPUADDRESS, x ; move hydrant's y coordinate by 2 pixels each frame
	INC HYDRANTSPPUADDRESS, x
	PLA
	TAX
	RTS
HydrantFallsDownDone:
	; erase shadow
	LDA #$FF
	STA HYDRANTSPPUADDRESS, y
	INY
	STA HYDRANTSPPUADDRESS, y
	LDA hydrantsstate
	CMP #$06
	BEQ AlterHydrantState ; skip making sounds when the final hydrant falls
	LDA #$03
  JSR sound_load
AlterHydrantState:
  PLA
	TAX
	INC projectilestate, x
	RTS

HydrantBlinks:
	TXA
	PHA
	TAY
	ASL A
	ASL A
	ASL A               ; multiply by 8
	TAX
	INX
	LDA projectilestate, y
	AND #%00000001      ; branch depends on whether projectilestate is even/odd
  BNE HydrantAppears  ; odd
HydrantDisappears:
	LDA #$00
	STA HYDRANTSPPUADDRESS, x
	JMP HydrantBlinksDone
HydrantAppears:
	LDA #$2D
	STA HYDRANTSPPUADDRESS, x
HydrantBlinksDone:
	PLA
	TAX
	INC projectilestate, x
	RTS

HydrantDestroyed:
	TXA
	PHA
	TAY
	ASL A
	ASL A
	ASL A               ; multiply by 8
	TAX
	LDA #$FF
	STA HYDRANTSPPUADDRESS, x
	PLA
	TAX
	INC projectilestate, x
	RTS

CheckCollision:
	LDA projectilenumber
	BEQ CheckCollisionDone
	LDA fightstate ; different logic for hydrants
	CMP #$05
	BCS HydrantCollision
	JMP FireballCollision
CheckCollisionDone:
	RTS
FireballCollision:
	; set variables for fireball collision
	LDA $0298
	STA projectileycmp
	LDA $029B
	STA projectilexcmp
	LDA #$14
	STA catlowcollision
	JMP CollisionCompareCoordinates
HydrantCollision:
	LDA #$07
	STA catlowcollision
	LDX #$00
HydrantCollisionLoop:
	LDA projectilestate, x
	CMP #$01 ; compare to damage state
	BNE SkipHydrantCollision
	TXA
	PHA
	ASL A ; transform to pointer, multiply by 8
	ASL A
	ASL A
	CLC
	ADC #$04 ; attach collision to shadow, not to hydrant (tiles are stored hydrants first, shadows after)
	TAX
	LDA HYDRANTSPPUADDRESS, x
	SEC
	SBC #$10
	STA projectileycmp
	INX
	INX
	INX
	LDA HYDRANTSPPUADDRESS, x
	STA projectilexcmp
	JSR CollisionCompareCoordinates
	PLA
	TAX
SkipHydrantCollision:
	INX
	CPX projectilenumber
	BNE HydrantCollisionLoop
	RTS
CollisionCompareCoordinates:
	; take upper cat sprite coordinates, add offset
	; take projectile coordinates
	; compare y, then x
	LDA $0200 ; upper cat tile y
	SEC
	SBC #$05  ; offset
	CMP projectileycmp ; compare with projectile y
	BCS NoCollision
	CLC
	ADC catlowcollision
	CMP projectileycmp ; compare with projectile y
	BCC NoCollision
	LDA $0203          ; upper cat tile x
	SEC
	SBC #$03
	CMP projectilexcmp ; compare with projectile x
	BCS NoCollision
	CLC
	ADC #$0F
	CMP projectilexcmp ; compare with projectile x
	BCC NoCollision
	LDA #$01
	STA dotsframe
	JSR ProcessDeath
	RTS
NoCollision:
	; JSR ClearDots
	RTS

ProcessDeath:
	; JSR DrawOneDot
	LDA #$49
	STA eventnumber
	LDA #$06
	STA action
	RTS
