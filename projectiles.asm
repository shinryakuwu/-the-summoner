DrawProjectiles:
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
	; JSR CheckCollision
	JSR ProjectileLifecycle
	INX
	JMP ProcessProjectilesLoop
ProcessProjectilesLoopDone:
	RTS
ProjectileCycleEnded:
	LDA #$00
	STA projectilenumber
	STA projdestroyed
	RTS

ProjectileLifecycle:
	LDA projectilestate, x
	CMP #$0B
	BCC ProjectileFallsDown
	BEQ ProjectileFallsWithCondition
	CMP #$0C
	BEQ ProjectileMovesLeft
	CMP #$0D
	BEQ ProjectileTimeOut
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

CheckCollision:
	; take upper cat sprite coordinates, add offset
	; take projectile coordinates
	; compare y, then x
	LDA $0200 ; upper cat tile y
	SEC
	SBC #$05  ; offset
	CMP $0298 ; compare with projectile y
	BCS NoCollision
	CLC
	; TODO: might want to alter this number for hydrant projectiles
	; ||
	; \/
	ADC #$14
	CMP $0298 ; compare with projectile y
	BCC NoCollision
	LDA $0203 ; upper cat tile x
	SEC
	SBC #$03
	CMP $029B ; compare with projectile x
	BCS NoCollision
	CLC
	ADC #$0F
	CMP $029B ; compare with projectile x
	BCC NoCollision
	LDA #$01
	STA dotsframe
	JSR ProcessDeath
	RTS
NoCollision:
	; JSR ClearDots
	RTS

ProcessDeath:
	; TODO: clear boss variables here
	; JSR DrawOneDot
	LDA #$49
	STA eventnumber
	LDA #$06
	STA action
	RTS
