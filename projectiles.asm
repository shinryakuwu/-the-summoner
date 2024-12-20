DrawProjectiles:
	RTS

ProjectilesLifecycle:
	; JSR CheckCollision
	LDA projectilenumber
	BEQ ProjectilesLifecycleDone
	LDA projectilestate
	CMP #$0B
	BCC ProjectileFallsDown
	BEQ ProjectileFallsWithCondition
	CMP #$0C
	BEQ ProjectileMovesLeft
ProjectilesLifecycleDone:
	RTS

ProjectileFallsDown:
	DEC $029B
	LDY projectilestate ; serves as acceleration pointer here
	LDA $0298
	CLC
	ADC projectileacceleration, y
	STA $0298
	INC projectilestate
	RTS

ProjectileFallsWithCondition:
	LDA $0298
	CMP $0200
	BCS ProjectileAlignsWithCat
	CLC
	ADC #$04
	STA $0298
	RTS
ProjectileAlignsWithCat:
	INC projectilestate
	RTS

ProjectileMovesLeft:
	LDA $029B
	CMP #$40
	BCC ProjectileReachesWall
	DEC $029B
	DEC $029B
	RTS
ProjectileReachesWall:
	; TODO: add delay after reaching wall
	LDA #$7C
	STA $0299
	LDA #$00
	STA projectilenumber
	STA projectilestate
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
	; add processing death here
	JSR DrawOneDot
	; LDA #$49
	; STA eventnumber
	; LDA #$06
	; STA action
	RTS
NoCollision:
	JSR ClearDots
	RTS
