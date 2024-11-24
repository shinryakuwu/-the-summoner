BossWalks:
	LDA dinomvstate
	; consider calling RenderDefaultBossPosition when 0
	CMP #$01
	BEQ BossWalksDown
	CMP #$02
	BEQ BossWalksUp
	RTS

BossWalksUp:
	LDA #$00
BossWalksDown:
	; A = 1 at this point if jumped to BossWalksDown
	STA trnsfrm       ; increment or decrement via transform loop based on the condition
ChangeBossCoordinates:
	LDA #$9C          ; compare pointer to this number via transform loop
	STA trnsfrmcompare
	LDX #$38          ; tiles are stored at address 0200 + this number
	JSR ObjectTransformNoCache
	RTS
