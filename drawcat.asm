DrawCatFromCache:
	LDA loadcache
	BEQ SkipDrawCatFromCache
	LDX #$00
DrawCatFromCacheLoop:
	LDA catcache, x
	STA $0200, x
	INX
	CPX #$18
	BNE DrawCatFromCacheLoop
SkipDrawCatFromCache:
	RTS
