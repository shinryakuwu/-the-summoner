DrawCatFromCache:
	LDX #$00
DrawCatFromCacheLoop:
	LDA $0000, x
	STA $0200, x
	INX
	CMP #$18
	BNE DrawCatFromCacheLoop
	RTS
