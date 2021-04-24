Initialise_Game:      
        lda #$D8
        sta SPRY1
        sta SPRY2
        lda #$3A
        sta SPRX1
        lda #$4A
        sta SPRX2                                       // fixed sprite positions of "lives" sprites

        ldx #$0D
        stx SPRPTR0                                     // player sprite and "lives" sprite at location $0340
        stx SPRPTR1
        stx SPRPTR2
        inx
        stx SPRPTR3                                     // enemy sprite at location $0380
        inx
        stx SIDVOL                                      // set volume

        ldx #$44
        lda #$00
!:
        sta zpLow,x
        dex
        bpl !-                                          // clear zeropage variable space

        lda #WHITE
        sta SPRCOL0
        sta SPRCOL1
        sta SPRCOL2                                     // player and lives sprite colour
        lda #YELLOW
        sta SPRCOL3                                     // enemy sprite colours
        rts


Initialise_StartGame:
        lda #$00
        sta currentLevel                                // initialise to first level
        ldx #$04
        lda #$30
!:
        sta score,x                                     // reset the score on screen
        dex
        bpl !-
        lda #$02                                        // reset lives to 3
        sta lives

        lda #GF_STATUS_INITLEVEL
        sta gameStatus
        rts