Screen_DisplayLevelMain:
        lda #BLACK
        sta BGCOL0                                              // background colour set to black

        ldx #$18                                                // start on row 24
NextRow:
        lda tblScreenRowLo,x                                    // set up the screen row pointers
        sta zpScnPtrLo
        sta zpColPtrLo
        lda tblScreenRowHi,x
        sta zpScnPtrHi                                          // and the screen colour pointers
        clc
        adc #$D4
        sta zpColPtrHi
        ldy #$27                                                // right-most char on row
NextColumn:
        lda #CHAR_BORDER
        cpy #$04                                                // left-most 4 columns - draw border
        bcc DrawBorder                                         
        cpy #$24                                                // right-most 4 colums (24-27) - draw border
        bcs DrawBorder
        cpx #$10
        bcs DrawSpace                                           // row 16-24 draw space between borders
        cpy #$04                                                // otherwise draw wall at column 4
        beq DrawWall
        cpy #$23                                                // and at column 23
        bne DrawSpace
DrawWall:
        lda #CHAR_WALL
        bne DrawBorder
DrawSpace:
        lda #CHAR_SPACE
DrawBorder:
        sta (zpScnPtrLo),y                                      // write the relevant char to the screen
        lda #RED
        cpy #$04                                                // the default screen char colour is set to red
        beq ColourWall                                          // unless we're on the border wall which is yellow
        cpy #$23
        bne ColourBorder
ColourWall:
        lda #YELLOW
ColourBorder:
        sta (zpColPtrLo),y                                      // write the relevant colour to colour memory
        dey
        bpl NextColumn                                          // loop for each column
        dex
        bpl NextRow                                             // loop for each row

        ldx #$1F
!:
        lda txtStats,x                                          // dispaly the stats bar at the bottom section of the screen
        sta SCREENRAM+$2FC,x
        lda #CHAR_HALFBAR                                       // draw the air bar across the bottom section of the screen
        sta SCREENRAM+$2AC,x
        lda #CHAR_INV_SPACE                                     // adds a border under the game screen
        sta SCREENRAM+$284,x
        lda txtTitle,x                                          // draw the game title at the bottom of the screen
        sta SCREENRAM+$3C4,x
        lda #LIGHT_GRAY
        sta COLOURRAM+$3C4,x                                    // set colours for items above
        lda #YELLOW
        sta COLOURRAM+$2FC,x
        sta COLOURRAM+$284,x
        lda #GREEN
        sta COLOURRAM+$2AC,x
        dex
        bpl !-

        ldx #$04
!:
        lda score,x                                             // display the player's current score
        sta SCREENRAM+$316,x
        dex
        bpl !-

        ldx #$03
!:
        lda txtAir,x                                            // write 'air' next to air bar and colour white
        sta SCREENRAM+$2AC,x
        lda #WHITE
        sta COLOURRAM+$2AC,x
        dex
        bpl !-
        
        ldx #$05
        lda #RED
!:
        sta COLOURRAM+$2B0,x                                    // set lower 5 chars of air bar to red
        dex
        bpl !-
        sta BDCOL                                               // set the border colour to red
        rts


Screen_DisplayLevelData:
        ldx currentLevel
        lda tblLevelDataLo,x                                    // set pointer to level data
        sta zpDataPtrLo
        lda tblLevelDataHi,x
        sta zpDataPtrHi
        ldy #$FF                                                // initialise level data offset
        ldx #$00                                                // x=0: read character length data
        lda #RED
        sta charColour                                          // set the char colour to red
        lda #CHAR_PLATFORM
        jsr Screen_PrintChar                                    // draw all the platforms
        lda #CHAR_DECAY_PLATFORM
        jsr Screen_PrintChar                                    // draw all the decaying platforms
        lda #GREEN
        sta charColour                                          // set the char colour to green
        lda #CHAR_MOVING_PLATFORM
        jsr Screen_PrintChar                                    // draw all the moving platforms
        lda #YELLOW
        sta charColour                                          // set the char colour to yellow
        lda #CHAR_WALL
        jsr Screen_PrintChar                                    // draw all the horizontal walls
        lda #CHAR_EXIT
        jsr Screen_PrintChar                                    // draw the exit
        inx                                                     // x=1: don't read char length data
        lda #WHITE              
        sta charColour                                          // set the char colour to white
        lda #CHAR_KEY
        jsr Screen_PrintChar                                    // draw all the keys
        lda #GREEN
        sta charColour                                          // set the char colour to green
        lda #CHAR_STALAG
        jsr Screen_PrintChar                                    // draw all the stalagmites
        lda #BLUE
        sta charColour                                          // set the char colour to blue
        lda #CHAR_SPIKE
        jsr Screen_PrintChar                                    // draw all the spikes

        iny
        ldx #$00
!:
        lda (zpDataPtrLo),y                                     // initialise enemy starting position
        sta enemyStartX,x
        iny
        inx
        cpx #$04
        bne !-

        ldx currentLevel
        lda tblExitKeysDataLo,x                                 // set pointers to level data for exit and keys
        sta zpDataPtrLo
        lda tblExitKeysDataHi,x
        sta zpDataPtrHi
        ldy #$00
        ldx #$00
!:
        lda (zpDataPtrLo),y
        clc
        adc #$D4
        sta exitColPtr,x                                        // we save the colour addresses for the exit and keys
        inx                                                     // in a zero page array of lo/hi bytes so that the
        iny                                                     // routine to flash their colours during the game
        lda (zpDataPtrLo),y                                     // can use the array
        sta exitColPtr,x
        inx
        iny
        cpy #$02
        bne CheckEndOfKeys
        ldy #$07
CheckEndOfKeys:
        cpy #$11
        bne !-

        ldx #$00
        ldy #$00
!:
        lda sprMinerInit,x
        sta SPRITE_DATA1,y                                      // initialise the player and enemy sprites
        lda sprEnemyInit,x                                      // both stored as 16 bytes arrays
        sta SPRITE_DATA2,y
        iny                                                     // 2 columns of the sprite are empty so we skip
        iny                                                     // writing into them and move to the next sprite row
        iny
        inx
        cpx #$10
        bne !-
        rts

        

Screen_PrintChar:
        sta charCode                                            // save the current char
        iny
NextChar:
        lda (zpDataPtrLo),y                                     // read next item of level data
        beq !Exit+                                              // if it's zero, we've drawn all of the items
        sta zpScnPtrHi                                          // store the screen hi byte
        clc
        adc #$D4
        sta zpColPtrHi                                          // and add $D4 to convert to colour hi byte
        iny                                                     // next level data item
        lda (zpDataPtrLo),y                                     // read and store the screen/colour lo byte
        sta zpScnPtrLo
        sta zpColPtrLo
        iny                                                     // next level data item
        lda #$00                                                // lenth = 1
        cpx #$01                                                // marker to skip reading of char length
        beq SkipReadCharLength
        lda (zpDataPtrLo),y                                     // if marker=0 then read the char length from level data
        iny                                                     // next level data item
SkipReadCharLength:
        sty zpTemp                                              // store the level data pointer temporarily
        tay                                                     // place the char length into the y register
!:
        lda charCode
        sta (zpScnPtrLo),y                                      // draw the selected char and colour to screen and
        lda charColour                                          // colour memory
        sta (zpColPtrLo),y
        dey                                                     // repeat for length
        bpl !-
        ldy zpTemp                                              // retrieve the level data pointer
        jmp NextChar                                            // loop to the next char
!Exit:
        rts


Screen_UpdateSprites:
        lda minerX                                              // update the player and enemy sprite positions
        sta SPRX0
        lda minerY
        sta SPRY0
        lda enemyX
        sta SPRX3
        lda enemyY
        sta SPRY3
        lda SPRXMSB
        and #%11110110
        ora minerXMSB                                           // only the player ever crosses the XMSB threshold
        sta SPRXMSB

        ldx lives
        lda SPREN
        and #%11111001
        ora tblLives,x                                          // switch off "lives" sprites based on remaining lives
        sta SPREN

        lda minerChangeDirection                                // check the change direction flag
        beq AnimateMiner
        dec minerChangeDirection        

        ldy #$00
GetNextByte:
        jsr Screen_MirrorSprite                                 // the player has changed direction so we mirror
        cpy #$30                                                // the sprite image
        bne GetNextByte
        rts
AnimateMiner:
        lda minerMove                                           // if the player hasn't moved then don't animate
        beq !Exit+
        dec minerAnimCounter                                    // rate at which animation updates
        bne !Exit+
        lda #MINER_ANIM_RATE
        sta minerAnimCounter

        ldx #$00
        ldy #$00
        lda minerFrame
        eor #$01                                                // alternate between the two miner animation frames (0/1)
        sta minerFrame
        beq !+
        ldx #$08
!:
        lda sprMinerFrames,x                                    // read in the relevant miner frame sprite data
        sta SPRITE_DATA1+$018,y                                 // and write it directly into sprite memory
        inx
        iny                                                     // skip to next sprite row (as only 1 sprite column used)
        iny
        iny
        cpy #$18
        bne !-

        lda minerDirection                                      // if player is facing left then we have to mirror
        beq !Exit+                                              // the sprite
        ldy #$18
        jmp GetNextByte
!Exit:
        rts


Screen_MirrorSprite:
        lda SPRITE_DATA1,y                                      // this routine mirrors sprite data for either
        beq NextSpriteByte                                      // the player or the enemy
        sta zpTemp
        ldx #$07                                                // this is so we only need to store the frame for
MirrorSpriteLoop:                                               // the sprite facing in one direction
        asl zpTemp
        ror                                                     // so we store 24 bytes for the player sprite, which
        dex                                                     // gives us 4 frames of sprites (i.e. 64x4 = 256 bytes of
        bpl MirrorSpriteLoop                                    // sprite data): left walk 1, left walk 2, right walk 1, right walk 2
        sta SPRITE_DATA1,y
NextSpriteByte:
        iny
        rts


Screen_GetChar:                                                 // routine to get char under/near player sprite
        lda #$D8
        sta zpScnPtrLo                                          // set the screen pointer to the row above screen memory
        lda #$03
        sta zpScnPtrHi

        stx offset                                              // x is set before routine is called, and gives the char offset
        lda minerX
        sec
        sbc #$18                                                // converts the miner X sprite position into a screen column position
        sta zpTemp
        lda minerXMSB
        sbc #$00
        lsr
        lda zpTemp
        ror
        lsr
        lsr
        tay
        dey

        lda minerY
        sec
        sbc #$32                                                // converts the miner y sprite position into a screen row number
        lsr
        lsr
        lsr
        tax
        dex
        bmi SkipFetchRow

        lda tblScreenRowLo,x                                    // fetch the relevant screen row lo/hi byte from lookup tables
        sta zpScnPtrLo
        lda tblScreenRowHi,x
        sta zpScnPtrHi
SkipFetchRow:
        tya
        clc
        adc offset                                              // add our offset to the column position
        tay                                                     // offset 0= char that is above and to the left of the player
                                                                // offset 1= char above the player, offset 27=char to left of player head etc.
        lda (zpScnPtrLo),y                                      // fetch the char we're interested in
        sta charSelected                                        // and store it
        rts


Screen_DisplayGameOver:
        lda #$00
        sta SPREN                                               // switch off all the sprites
        ldx #$17
!:
        lda txtGameOver,x                                       // display the game over message
        sta SCREENRAM+$3C8,x
        dex
        bpl !-
!:
        lda CIAPRA                                              // wait for fire to restart the game
        and #JOY_FIRE
        bne !-
!:
        lda CIAPRA                                              // debounce the fire button
        and #JOY_FIRE
        beq !-
        lda #GF_STATUS_MENU                                     // restart the game
        sta gameStatus
        rts
        

Screen_FlashKeys:
        inc keyColour                                           // key colour rotates through all colours
        ldx #$00
!:
        lda keyColPtr,x                                         // fetch the lo/hi byte of the key colour location
        sta zpColPtrHi
        inx
        lda keyColPtr,x
        sta zpColPtrLo
        ldy #$00
        lda keyColour
        sta (zpColPtrLo),y                                      // set the colour for the current key
        inx
        cpx #$0A                                                // check we've done all 5 keys
        bne !-

        lda keysLeft                                            // test if all keys are collected
        bne !Exit+                                              // if not, don't flash the exit
        lda exitColPtr
        sta zpColPtrHi
        lda exitColPtr+1                                        // fetch the lo/hi byte of the exit location
        sta zpColPtrLo
        ldy #$00
        lda keyColour
        sta (zpColPtrLo),y                                      // set colour for exit char top-left
        iny
        sta (zpColPtrLo),y                                      // set colour for exit char top-right
        ldy #$28
        sta (zpColPtrLo),y                                      // set colour for exit char bottom-left
        iny
        sta (zpColPtrLo),y                                      // set colour for exit char bottom-right
!Exit:
        rts
        

Screen_UpdateAir:
        dec airCounter                                          // rate at which air depletes
        bne !Exit+
        lda #AIR_RATE
        sta airCounter
        ldx air
        lda SCREENRAM+$2B0,x                                    // check if the current air char is the half bar
        cmp #CHAR_HALFBAR                                       // or the quarter bar
        bne HalfChar
        lda #CHAR_QUARTERBAR                                    // if it's the halfbar then change to quarter bar
        sta SCREENRAM+$2B0,x
        rts
HalfChar:
        lda #CHAR_SPACE                                         // if it's the quarter bar then change it to a space
        sta SCREENRAM+$2B0,x
        dec air                                                 // and then decement the air counter
        bne !Exit+                                              // check if any air left
        lda #GF_STATUS_LOSE_LIFE                                // no - lose a life
        sta gameStatus
!Exit:
        rts



Screen_UpdateScore:                                             // set x reg to score digit before routine is called
!:
        lda SCREENRAM+$316,x
        cmp #$39                                                // check for rollover on digit (from 9 to 0)
        beq NextScoreDigit
        inc SCREENRAM+$316,x                                    // no rollover, increase screen char for score
        inc score,x                                             // and increase the score variable
        jmp CheckHiScore
NextScoreDigit:
        lda #$30                                                // we've rolled over so set char to 0
        sta SCREENRAM+$316,x
        sta score,x
        dex                                                     // then move to the next (higher) score digit
        bpl !-
CheckHiScore:
        ldx #$00
!:
        lda SCREENRAM+$316,x
        cmp SCREENRAM+$307,x                                    // compare current score digit to hi-score digit
        bcc !Exit+                                              // it's lower - no high score
        bne NewHiScore                                          // it's not equal - new high score
        inx                                                     // it's equal, so move on to test next score digit
        cpx #$05                                                // until the final score digit
        bne !-
        rts
NewHiScore:
        ldx #$04
!:
        lda SCREENRAM+$316,x                            
        sta SCREENRAM+$307,x                                    // set high score to current score
        sta txtStats+$00B,x                                     // and save the high score
        dex
        bpl !-
!Exit:
        rts
