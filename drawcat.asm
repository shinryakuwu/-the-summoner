DrawCatFromCache:
	LDX #$00
DrawCatFromCacheLoop:
	LDA catcache, x
	STA $0200, x
	INX
	CPX #$18
	BNE DrawCatFromCacheLoop
	RTS
