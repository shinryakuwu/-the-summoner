SQUARE_1 = $00 ;these are channel constants
SQUARE_2 = $01
TRIANGLE = $02
NOISE = $03

MUSIC_SQ1 = $00 ;these are stream # constants
MUSIC_SQ2 = $01 ;stream # is used to index into variables
MUSIC_TRI = $02
MUSIC_NOI = $03
SFX_1     = $04
SFX_2     = $05

	.rsset $0300 ;sound engine variables will be on the $0300 page of RAM

sound_disable_flag  .rs 1   ;a flag variable that keeps track of whether the sound engine is disabled or not. 
sound_temp1 .rs 1           ;temporary variables
sound_temp2 .rs 1
sound_sq1_old .rs 1  ;the last value written to $4003
sound_sq2_old .rs 1  ;the last value written to $4007
soft_apu_ports .rs 16

;reserve 6 bytes, one for each stream
stream_curr_sound .rs 6     ;current song/sfx loaded
stream_status .rs 6         ;status byte.   bit0: (1: stream enabled; 0: stream disabled)
stream_channel .rs 6        ;what channel is this stream playing on?
stream_ptr_LO .rs 6         ;low byte of pointer to data stream
stream_ptr_HI .rs 6         ;high byte of pointer to data stream
stream_vol_duty .rs 6       ;stream volume/duty settings
stream_note_LO .rs 6        ;low 8 bits of period for the current note on a stream
stream_note_HI .rs 6        ;high 3 bits of period for the current note on a stream 
stream_tempo .rs 6          ;the value to add to our ticker total each frame
stream_ticker_total .rs 6   ;our running ticker total.
stream_note_length_counter .rs 6
stream_note_length .rs 6

SoundInit:
  lda #$0F
  sta $4015   ;enable Square 1, Square 2, Triangle and Noise channels
  
  lda #$00
  sta sound_disable_flag  ;clear disable flag
  ;later, if we have other variables we want to initialize, we will do that here.
  lda #$FF
  sta sound_sq1_old   ;initializing these to $FF ensures that the first notes of the first song isn't skipped
  sta sound_sq2_old
SeSilence:
  lda #$30
  sta soft_apu_ports      ;set Square 1 volume to 0
  sta soft_apu_ports+4    ;set Square 2 volume to 0
  sta soft_apu_ports+12   ;set Noise volume to 0
  lda #$80
  sta soft_apu_ports+8     ;silence Triangle
  rts

SoundDisable:
  lda #$00
  sta $4015   ;disable all channels
  lda #$01
  sta sound_disable_flag  ;set disable flag
  rts

;-------------------------------------
; SoundLoad will prepare the sound engine to play a song or sfx.
;   input:
;       A: song/sfx number to play
SoundLoad:
  sta sound_temp1         ;save song number
  asl a                   ;multiply by 2.  We are indexing into a table of pointers (words)
  tay
  lda song_headers, y     ;setup the pointer to our song header
  sta sound_ptr
  lda song_headers+1, y
  sta sound_ptr+1
  
  ldy #$00
  lda [sound_ptr], y      ;read the first byte: # streams
  sta sound_temp2         ;store in a temp variable.  We will use this as a loop counter: how many streams to read stream headers for
  iny
.loop:
  lda [sound_ptr], y      ;stream number
  tax                     ;stream number acts as our variable index
  iny
  
  lda [sound_ptr], y      ;status byte.  1= enable, 0=disable
  sta stream_status, x
  beq .next_stream        ;if status byte is 0, stream disabled, so we are done
  iny
  
  lda [sound_ptr], y      ;channel number
  sta stream_channel, x
  iny
  
  lda [sound_ptr], y      ;initial duty and volume settings
  sta stream_vol_duty, x
  iny
  
  lda [sound_ptr], y      ;pointer to stream data.  Little endian, so low byte first
  sta stream_ptr_LO, x
  iny
  
  lda [sound_ptr], y
  sta stream_ptr_HI, x
  iny
  
  lda [sound_ptr], y
  sta stream_tempo, x
  
  lda #$A0
  sta stream_ticker_total, x
  
  lda #$01
  sta stream_note_length_counter,x
.next_stream:
  iny
  
  lda sound_temp1         ;song number
  sta stream_curr_sound, x
  
  dec sound_temp2         ;our loop counter
  bne .loop
  rts


;--------------------------
; SoundPlayFrame advances the sound engine by one frame
SoundPlayFrame:
  lda sound_disable_flag
  bne .done       ;if disable flag is set, don't advance a frame

  jsr SeSilence   ;silence all channels.  SeSetApu will set volume later for all channels that are enabled.
                  ;the purpose of this subroutine call is to silence channels that aren't used by any streams.
  
  ldx #$00
.loop:
  lda stream_status, x
  and #$01      ;check whether the stream is active
  beq .endloop  ;if the stream isn't active, skip it
  
  ;add the tempo to the ticker total.  If there is a FF-> 0 transition, there is a tick
  lda stream_ticker_total, x
  clc
  adc stream_tempo, x
  sta stream_ticker_total, x
  bcc .set_buffer    ;carry clear = no tick.  if no tick, we are done with this stream
  
  dec stream_note_length_counter, x   ;else there is a tick. decrement the note length counter
  bne .set_buffer    ;if counter is non-zero, our note isn't finished playing yet
  lda stream_note_length, x   ;else our note is finished. reload the note length counter
  sta stream_note_length_counter, x
  
  jsr SeFetchByte   ;read the next byte from the data stream
  
.set_buffer:
  jsr SeSetTempPorts   ;copy the current stream's sound data for the current frame into our temporary APU vars (soft_apu_ports)
.endloop:
  inx
  cpx #$06
  bne .loop
  jsr SeSetApu      ;copy the temporary APU variables (soft_apu_ports) to the real APU ports ($4000, $4001, etc)
.done:
  rts

;--------------------------
; SeFetchByte reads one byte from a sound data stream and handles it
;   input: 
;       X: stream number    
SeFetchByte:
  lda stream_ptr_LO, x
  sta sound_ptr
  lda stream_ptr_HI, x
  sta sound_ptr+1
  
  ldy #$00
.fetch:
  lda [sound_ptr], y
  bpl .note                ;if < #$80, it's a Note
  cmp #$A0
  bcc .note_length         ;else if < #$A0, it's a Note Length
.opcode:                     ;else it's an opcode
  ;do Opcode stuff
  cmp #$FF
  bne .end
  lda stream_status, x    ;if $FF, end of stream, so disable it and silence
  and #%11111110
  sta stream_status, x    ;clear enable flag in status byte
  
  lda stream_channel, x
  cmp #TRIANGLE
  beq .silence_tri        ;triangle is silenced differently from squares and noise
  lda #$30                ;squares and noise silenced with #$30
  bne .silence
.silence_tri:
  lda #$80                ;triangle silenced with #$80
.silence:
  sta stream_vol_duty, x  ;store silence value in the stream's volume variable.
  jmp .update_pointer     ;done
.note_length:
  ;do note length stuff
  and #%01111111          ;chop off bit7
  sty sound_temp1         ;save Y because we are about to destroy it
  tay
  sta stream_note_length, x
  sta stream_note_length_counter, x   ;stick it in our note length counter
  ldy sound_temp1         ;restore Y

  iny                     ;set index to next byte in the stream
  jmp .fetch              ;fetch another byte
.note:
  ;do Note stuff
  sty sound_temp1     ;save our index into the data stream
  asl a
  tay
  lda note_table, y
  sta stream_note_LO, x
  lda note_table+1, y
  sta stream_note_HI, x
  ldy sound_temp1     ;restore data stream index

  ;check if it's a rest and modify the status flag appropriately
  jsr SeCheckRest    
.update_pointer:
  iny
  tya
  clc
  adc stream_ptr_LO, x
  sta stream_ptr_LO, x
  bcc .end
  inc stream_ptr_HI, x
.end:
  rts

;--------------------------------------------------
; SeCheckRest will read a byte from the data stream and
;       determine if it is a rest or not.  It will set or clear the current
;       stream's rest flag accordingly.
;       input:
;           X: stream number
;           Y: data stream index
SeCheckRest:
  lda [sound_ptr], y  ;read the note byte again
  cmp #rest
  bne .not_rest
  lda stream_status, x
  ora #%00000010  ;set the rest bit in the status byte
  bne .store  ;this will always branch.  bne is cheaper than a jmp.
.not_rest:
  lda stream_status, x
  and #%11111101  ;clear the rest bit in the status byte
.store:
  sta stream_status, x
  rts

;----------------------------------------------------
; SeSetTempPorts will copy a stream's sound data to the temporary apu variables
;      input:
;           X: stream number
SeSetTempPorts:
  lda stream_channel, x
  asl a
  asl a
  tay
  
  lda stream_vol_duty, x
  sta soft_apu_ports, y       ;vol
  
  lda #$08
  sta soft_apu_ports+1, y     ;sweep
  
  lda stream_note_LO, x
  sta soft_apu_ports+2, y     ;period LO
  
  lda stream_note_HI, x
  sta soft_apu_ports+3, y     ;period HI
  
  ;check the rest flag. if set, overwrite volume with silence value 
  lda stream_status, x
  and #%00000010
  beq .done       ;if clear, no rest, so quit
  lda stream_channel, x
  cmp #TRIANGLE   ;if triangle, silence with #$80
  beq .tri        ;else, silence with #$30
  lda #$30        
  bne .store
.tri:
  lda #$80
.store:    
  sta soft_apu_ports, y
.done:
  rts    
  
;--------------------------
; SeSetApu copies the temporary RAM ports to the APU ports
SeSetApu:
.square1:
  lda soft_apu_ports+0
  sta $4000
  lda soft_apu_ports+1
  sta $4001
  lda soft_apu_ports+2
  sta $4002
  lda soft_apu_ports+3
  cmp sound_sq1_old       ;compare to last write
  beq .square2            ;don't write this frame if they were equal
  sta $4003
  sta sound_sq1_old       ;save the value we just wrote to $4003
.square2:
  lda soft_apu_ports+4
  sta $4004
  lda soft_apu_ports+5
  sta $4005
  lda soft_apu_ports+6
  sta $4006
  lda soft_apu_ports+7
  cmp sound_sq2_old
  beq .triangle
  sta $4007
  sta sound_sq2_old       ;save the value we just wrote to $4007
.triangle:
  lda soft_apu_ports+8
  sta $4008
  lda soft_apu_ports+10   ;there is no $4009, so we skip it
  sta $400A
  lda soft_apu_ports+11
  sta $400B
.noise:
  lda soft_apu_ports+12
  sta $400C
  lda soft_apu_ports+14   ;there is no $400D, so we skip it
  sta $400E
  lda soft_apu_ports+15
  sta $400F
  rts

;this is our pointer table.  Each entry is a pointer to a song header                
song_headers:
	.word song0_header     ;this is a silence song.  See song0.i for more details
  .word boss_bgm_header  ; boss fight theme
  .word avril14_bgm_header
  ; TODO: add more headers here
  
  .include "note_table.i" ;period lookup table for notes
	.include "song0.i"      ;holds the data for song 0 (header and data streams)
	.include "song_boss_bgm.i"
	.include "song_avril14_bgm.asm"
