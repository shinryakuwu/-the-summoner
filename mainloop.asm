MainLoopSubroutines:
	LDA bgrender
	CMP #$01
	BEQ PerformBgRender

ExitMainLoopSubroutines:
	LDA #$00
	STA mainloop
	STA bgrender
	JMP ReturnToNMI

PerformBgRender:
  LDA currentbghigh
  PHA
  JSR LoadBackground
  PLA
  STA currentbghigh
  JSR LoadAttribute
  JMP ExitMainLoopSubroutines