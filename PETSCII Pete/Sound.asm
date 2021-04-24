Sound_Collect:
	lda #$08
	sta V1CR 						// disable voice 1
	lda #$F5
	sta V1FREH 						// set voice 1 freq hi
	lda #$09
	sta ATTDCY1 						// set attack/decay
	sta SUSREL1
	lda #$21 						// sawtooth wavefore & gate on
	sta V1CR
	rts


Sound_Jump:
	lda jumpCounter 					// jump sound is dependent on jump position
	cmp #$08
	bcs SoundDown
	clc
	adc #$31 						// set frequency offset from jump position
	bne SetFreqHi 						// always true, so jmp
SoundDown:
	lda #$40
	sec
	sbc jumpCounter 					// set frequency offset from jump position
SetFreqHi:
	sta V2FREH 						// set voice 2 frequency
	lda #$00
	sta ATTDCY2 						// no attack/decay
	lda #$60
	sta SUSREL2 						// set voice 2 sustain/release
	lda #$11
	sta V2CR 						// triangle waveform & gate on
	rts


Sound_Death:
	lda #$09
	sta ATTDCY3 						// set voice 3 attack/decay
	lda #$00
	sta SUSREL3 						// no sustain/release
	lda #$FF
	sta V3FREH 						// set voice 3 frequency at max
	lda #$21
	sta V3CR 						// sawtooth waveform & gate on
DeathSoundLoop:
	ldx #$04
	ldy #$00
!:
	dey
	bne !- 							// short delay
	dex
	bne !-
	dec V3FREH 						// decrease voice 3 frequency
	bne DeathSoundLoop 					// until zero
	lda #$08
	sta V3CR 						// disable voice 3
	rts

