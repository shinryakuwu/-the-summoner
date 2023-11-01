MainLoopSubroutines:
	LDA bgrender
	CMP #$01
	BEQ PerformBgRender

ExitMainLoopSubroutines:
	LDA #$00
	STA mainloop
	STA bgrender
  JMP Forever

PerformBgRender:
  LDA #$00
  STA $2001    ; disable rendering
  LDA currentbghigh
  PHA
  JSR LoadBackground
  PLA
  STA currentbghigh
  JSR LoadAttribute
  JSR LoadSprites
  LDA #OBJECTSANIMATIONSPEED ; renew the animation counter
  STA animatecounter
  JMP ExitMainLoopSubroutines
