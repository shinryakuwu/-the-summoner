;these are aliases to use in the sound data.
endsound = $A0
loop = $A1
volume_envelope = $A2
duty = $A3
set_loop1_counter = $A4
loop1 = $A5
sync = $A6

;-----------------------------------------------------------------------
;this is our JUMP TABLE!
sound_opcodes:
  .word se_op_endsound            ;$A0
  .word se_op_infinite_loop       ;$A1
  .word se_op_change_ve           ;$A2
  .word se_op_duty                ;$A3
  .word se_op_set_loop1_counter   ;$A4
  .word se_op_loop1               ;$A5
  .word se_op_sync                ;$A6
  ;etc, 1 entry per subroutine


;-----------------------------------------------------------------
; these are the actual opcode subroutines
se_op_endsound:
  lda stream_status, x    ;end of stream, so disable it and silence
  and #%11111110
  sta stream_status, x    ;clear enable flag in status byte
  
  lda stream_channel, x
  cmp #TRIANGLE
  beq .silence_tri        ;triangle is silenced differently from squares and noise
  lda #$30                ;squares and noise silenced with #$30
  bne .silence            ; (this will always branch.  bne is cheaper than a jmp)
.silence_tri:
  lda #$80                ;triangle silenced with #$80
.silence:
  sta stream_vol_duty, x  ;store silence value in the stream's volume variable.

  rts
  
se_op_infinite_loop:
  lda [sound_ptr], y      ;read ptr LO from the data stream
  sta stream_ptr_LO, x    ;update our data stream position
  iny
  lda [sound_ptr], y      ;read ptr HI from the data stream
  sta stream_ptr_HI, x    ;update our data stream position
  
  sta sound_ptr+1         ;update the pointer to reflect the new position.
  lda stream_ptr_LO, x
  sta sound_ptr
  ldy #$FF                ;after opcodes return, we do an iny.  Since we reset  
                          ;the stream buffer position, we will want y to start out at 0 again.
  rts
  
se_op_change_ve:
  lda [sound_ptr], y      ;read the argument
  sta stream_ve, x        ;store it in our volume envelope variable
  lda #$00
  sta stream_ve_index, x  ;reset volume envelope index to the beginning
  rts
  
se_op_duty:
  lda [sound_ptr], y
  sta stream_vol_duty, x
  rts
  
se_op_set_loop1_counter:
  lda [sound_ptr], y      ;read the argument (# times to loop)
  sta stream_loop1, x     ;store it in the loop counter variable
  rts
  
se_op_loop1:
  dec stream_loop1, x     ;decrement the counter
  lda stream_loop1, x
  beq .last_iteration     ;if zero, we are done looping
  jmp se_op_infinite_loop ;if not zero, jump back
.last_iteration:
  iny                     ;skip the first byte of the address argument
                          ; the second byte will be skipped automatically upon return
                          ; (see se_fetch_byte after "jsr se_opcode_launcher")
  rts

se_op_sync:
  lda [sound_ptr], y
  sta sync_graphics  ; trigger sound synchronization with the graphics
  rts
