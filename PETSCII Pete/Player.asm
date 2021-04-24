Player_InitLevelVariables:
        lda #$44
        sta minerX
        lda #$9A
        sta minerY                                      // set starting XY position for player

        lda #$00
        sta minerXMSB                                   // init game varaibles
        sta fallCounter
        sta fallEnable
        sta minerFrame
        sta enemyFrame
        sta minerDirection
        sta jumpEnable

        lda enemyStartX                                 // set starting position for enemy
        sta enemyX
        lda enemyStartY
        sta enemyY

        lda #ENEMY_RATE                                 // init movement and animation variables
        sta enemyCounter
        lda #ENEMY_ANIM_RATE
        sta enemyAnimCounter
        lda #JUMP_RATE
        sta jumpDelay
        lda #AIR_RATE
        sta airCounter
        lda #MINER_ANIM_RATE
        sta minerAnimCounter

        lda #%00001111
        sta SPREN                                       // switch on sprites 0-3
        lda #$1B
        sta air                                         // init air level to max
        lda #PLATFORM_DIR_LEFT
        sta platformDirection                           // set moving platform direction
        lda #$05
        sta keysLeft                                    // set keys remaining to max

        lda SPRCSP                                      // clear the sprite collision register
        lda #GF_STATUS_PLAY
        sta gameStatus                                  // start the game
        rts



Player_GetInput:
        lda jumpEnable
        ora fallEnable
        bne !Exit+                                      // if player is jumping or falling then skip routine
        lda #$00
        sta minerMove                                   // clear the movement flag
        lda onPlatform
        beq NotOnPlatform                               // check if player is on a moving platform
        inc minerMove                                   // flag that the player has moved
        cmp #PLATFORM_DIR_LEFT                          // check direction of moving platform
        bne PlatformRight
        lda CIAPRA
        and #JOY_FIRE                                   // checks for fire button
        bne LeftOK                                      // if fire is pressed then force jump left
        lda #JUMP_DIR_LEFT                              // otherwise move player left (forced by platform)
        jmp SetJumpCounter
PlatformRight:
        lda CIAPRA
        and #JOY_FIRE                                   // as above but forces the player right if the
        bne RightOK                                     // platform is moving right
        lda #JUMP_DIR_RIGHT
        jmp SetJumpCounter
NotOnPlatform:
        lda CIAPRA
        eor #$FF
        and #JOY_LEFTRIGHTFIRE                          // we're not on a platform so check for joystick
        bne ValidInput                                  // left, right or fire
!Exit:
        rts
ValidInput:
        inc minerMove                                   // flag that the player has moved
        cmp #JOY_LEFT
        bne CheckMoveRight
        lda minerX
        cmp #$41                                        // testing for left-most part of screen
        bcs LeftOK                                      // which stops the player moving past the left wall
        lda minerXMSB
        bne LeftOK
        lda #$40
        sta minerX
        rts
LeftOK:
        ldx #$51                                        // set x-offset for sprite to align with char
        jsr Screen_GetChar
        cmp #CHAR_WALL                                  // if the char to the left is a wall then exit routine
        beq !Exit-                                      // i.e. we can't move left
        dec minerX
        lda minerX                                      // decrease player X position and check if we've passed
        cmp #$FF                                        // the XMSB threshold
        bne SetDirectionLeft
        dec minerXMSB
SetDirectionLeft:
        lda minerDirection
        bne !Exit-
        inc minerDirection                              // if we're not already moving left then set direction to left
        inc minerChangeDirection                        // and set the flag that says we've changed direction
        rts
CheckMoveRight:
        cmp #JOY_RIGHT
        bne CheckMoveFire
        lda minerX
        cmp #$27                                        // check if player is at right-most point on the game screen
        bcc RightOK                                     // and if they are stops them moving past the outer wall
        lda minerXMSB
        beq RightOK
        lda #$27
        sta minerX
        rts
RightOK:
        ldx #$52                                        // set the xoffset for the player sprite
        jsr Screen_GetChar
        cmp #CHAR_WALL                                  // if there is wall to the right then stop the player moving
        beq !Exit-
        inc minerX
        bne SetDirectionRight                           // otherwise increase player X position and check if XMSB
        inc minerXMSB                                   // threshold has been passed
SetDirectionRight:
        lda minerDirection
        beq !Exit-                                      // check if we're already moving right
        dec minerDirection                              // if not, set direction right and set the change direction
        inc minerChangeDirection                        // flag
        rts
CheckMoveFire:
        cmp #JOY_FIRE                                   // if fire pressed without direction then jump up
        bne CheckMoveFireLeft
        lda #JUMP_DIR_UP
SetJumpCounter:
        sta jumpEnable                                  // holds direction of jump
        lda #$0F
        sta jumpCounter                                 // initialise the jump counter
        ldx #$01
        jsr Screen_GetChar                              // get char above player
        cmp #CHAR_WALL                                  // if it's a wall then stop the jump
        beq DisableJump
        ldx #$02
        jsr Screen_GetChar                              // get char above right of player
        cmp #CHAR_WALL                                  // if it's a wall then stop the jump
        beq DisableJump
!Exit:
        rts
CheckMoveFireLeft:
        cmp #JOY_LEFTFIRE                               // check for fire + left
        bne CheckMoveFireRight                          // and set jump direction left if true
        lda #JUMP_DIR_LEFT                              // then go to jump routine
        bne SetJumpCounter
CheckMoveFireRight:
        cmp #JOY_RIGHTFIRE                              // as above but test for fire + right
        bne !Exit-
        lda #JUMP_DIR_RIGHT
        bne SetJumpCounter
DisableJump:
        lda #$00                                        // clear the jump enable flag
        sta jumpEnable
        rts




Player_Jump:
        lda jumpEnable                                  // if we're not jumping then skip routine
        beq !Exit+
        lda fallEnable                                  // if we're falling them skip routine
        bne !Exit+
        dec jumpDelay                                   // delay for jumping
        bne !Exit+
        lda #JUMP_RATE
        sta jumpDelay                                   // reset the jump delay counter
        jsr Sound_Jump                                  // make the jumping sound

        ldx #$29
        jsr Screen_GetChar                              // this routine checks if the player has jumped
        cmp #CHAR_WALL                                  // into a wall above them
        bne NormalJump                                  

        lda jumpCounter                                 // if the jump position is greater than 3
        cmp #$04                                        // then we set it to 3 i.e. the end of the 
        bcc NormalJump                                  // jump arc when the player is moving down
        lda #$03
        sta jumpCounter
NormalJump:
        lda jumpEnable
        cmp #JUMP_DIR_LEFT                              // check for directional jump
        beq JumpLeft
        cmp #JUMP_DIR_RIGHT
        beq JumpRight
SetJumpY:
        ldx jumpCounter
        cpx #$08                                        // check if we're on the downward cycle of the
        bcs ContinueJump                                // jump arc
        ldx #$7A
        jsr Screen_GetChar                              // check the char below the player
        cmp #CHAR_WALL
        bcs CheckLandedOnPlatform                       // is it a wall/platform/decaying platform?
NotLandedOnPlatform:
        ldx jumpCounter                                 // x holds the current jump position index
ContinueJump:
        lda minerY
        clc
        adc tblJumpY,x                                  // adds the y offset for the player jump
        sta minerY
        dec jumpCounter                                 // move down the jump exit
        bpl !Exit+
        bne JumpDisable                                 // jump arc completed? Then disable the jump
CheckLandedOnPlatform:
        cmp #CHAR_EXIT                                  // the char is the exit or border so not a platform
        bcs NotLandedOnPlatform
        lda minerY                                      // check player Y position of sprite and offset by 8 bytes
        and #%00000111                                  // to get alignment with char on screen
        cmp #%00000010
        bne NotLandedOnPlatform
JumpDisable:
        lda #$00                                        // we've landed on a platform so disable the jump
        sta jumpEnable                                  // and switch off voice 2 (which plays the jump sound)
        sta V2CR
!Exit:
        rts
JumpLeft:
        lda minerX
        cmp #$41
        bcs ContinueLeftJump                            // we're jumping left so check we're not at the left-most
        lda minerXMSB                                   // part of the game screen
        beq SetJumpY
ContinueLeftJump:
        ldx #$29
        jsr Screen_GetChar                              // check char positions around the player sprite
        cmp #CHAR_WALL                                  // if they are walls, then we can still jump up
        beq SetJumpY                                    // but not left
        ldx #$51 
        jsr Screen_GetChar                              
        cmp #CHAR_WALL
        beq SetJumpY
        ldx #$79
        jsr Screen_GetChar
        cmp #CHAR_WALL
        beq SetJumpY

        lda minerX
        sec
        sbc #$02                                        // move 2 pixels left during jump
        sta minerX 
        lda minerXMSB
        sbc #$00
        sta minerXMSB

        lda minerXMSB                                   // check we are not at left-most edge of screen
        bne NotAtEdge                                   // if we are then reset the player x position
        lda minerX                                      // to the minimum x position allowed
        cmp #$40
        bcs NotAtEdge
        lda #$40
        sta minerX
NotAtEdge:
        jsr SetDirectionLeft                            // check for direction switch
        jmp SetJumpY                                    // set the Y jump direction
        rts
JumpRight:
        lda minerX
        cmp #$27                                        // check if we're at the right-most edge of the screen
        bcc ContinueLeftRight                           // and if we are force the jump to up only
        lda minerXMSB
        bne NoJumpRight
ContinueLeftRight:
        ldx #$2A
        jsr Screen_GetChar                              // check chars around the player sprite and if they
        cmp #CHAR_WALL                                  // are walls then force the jump to be up only
        beq NoJumpRight
        ldx #$52
        jsr Screen_GetChar
        cmp #CHAR_WALL
        beq NoJumpRight
        ldx #$7A
        jsr Screen_GetChar
        cmp #CHAR_WALL
        bne AdjustX
NoJumpRight:
        jmp SetJumpY
AdjustX:
        lda minerX
        clc
        adc #$02                                        // move two pixels to the right
        sta minerX 
        lda minerXMSB
        adc #$00
        sta minerXMSB
        jsr SetDirectionRight                           // check for direction change
        jmp SetJumpY                                    // and set the jump direction



Player_Fall:
        lda jumpEnable
        bne !Exit+                                      // if we're jumping then we can't fall

        ldx #$79
        jsr Screen_GetChar                              // check the chars below the player to see if it
        cmp #CHAR_SPACE                                 // is space. If it isn't then we've landed on something
        bne OnSolidGround

        ldx #$7A
        jsr Screen_GetChar
        cmp #CHAR_SPACE
        bne OnSolidGround

        lda #$01
        sta fallEnable                                  // we're not on solid ground to set the fall enable flag
        inc minerY
        rts
OnSolidGround:
        lda #$00                                        // we've landed. Switch the fall enable flag off
        sta fallEnable
!Exit:
        rts




Player_CheckCollision:
        lda #$00
        sta onPlatform                                  // clear the player on platform flag
        ldx #$29
        jsr Screen_GetChar                              // check the char around the player
        cmp #CHAR_SPIKE                                 // and call relevant routine dependent on
        beq HitDeath                                    // what sort of char it is
        cmp #CHAR_STALAG
        beq HitDeath
        cmp #CHAR_KEY
        beq HitKey

        ldx #$51
        jsr Screen_GetChar
        cmp #CHAR_SPIKE
        beq HitDeath
        cmp #CHAR_STALAG
        beq HitDeath
        cmp #CHAR_KEY
        beq HitKey
        cmp #CHAR_EXIT
        beq CheckLevelEnd

        ldx #$2A
        jsr Screen_GetChar
        cmp #CHAR_SPIKE
        beq HitDeath
        cmp #CHAR_STALAG
        beq HitDeath
        cmp #CHAR_KEY
        beq HitKey

        ldx #$52
        jsr Screen_GetChar
        cmp #CHAR_SPIKE
        beq HitDeath
        cmp #CHAR_STALAG
        beq HitDeath
        cmp #CHAR_KEY
        beq HitKey

        lda jumpEnable                                  // if we're jumping or falling then we
        bne !Exit+                                      // don't want to check collision with a decaying
        lda fallEnable                                  // or moving platform
        bne !Exit+

        ldx #$79
        jsr Screen_GetChar

        ldx #$07
!:
        cmp tblSoftPlatChars,x                          // this loops through all of the decaying platform chars
        beq SoftPlatform                                // to check for a collision
        dex
        bpl !-

        cmp #CHAR_MOVING_PLATFORM                       // check if we're on a moving platform
        beq MovingPlatform

        ldx #$7A
        jsr Screen_GetChar
        cmp #CHAR_MOVING_PLATFORM
        beq MovingPlatform
        rts
HitDeath:
        lda #GF_STATUS_LOSE_LIFE                        // we've hit a spike or stalagmite
        sta gameStatus
        rts
HitKey:
        lda #CHAR_SPACE                                 // we've hit a key so clear the key from the screen
        sta (zpScnPtrLo),y                              
        jsr Sound_Collect                               // make the key collect sound
        dec keysLeft                                    // reduce the number of keys to collect
        ldx #$03                                        // and increase the player's score
        jsr Screen_UpdateScore
        rts
MovingPlatform:
        lda platformDirection                           // we're on a moving platform so store the platform
        sta onPlatform                                  // direction in the player on platform variable
        rts
SoftPlatform:
        inx                                             // we're on a decaying platform, so move to the next
        lda tblSoftPlatChars,x                          // char in the decaying platform index and draw
        sta (zpScnPtrLo),y                              // that on the screen
        rts
CheckLevelEnd:
        lda keysLeft                                    // we've hit the exit, have we collected all the keys?
        bne !Exit+
        lda #GF_STATUS_LEVEL_COMPLETE                   // yes we have, so end the level
        sta gameStatus
!Exit:
        rts


Player_Score:                                           // routine to update player score based on remaining air
        dec airCounter                                  
        bne !Exit+                                      // delay for air reduction rate
        lda #AIR_SCORE_RATE
        sta airCounter
        ldx #$04
        jsr Screen_UpdateScore                          // update the on screen score
        ldx air
        lda SCREENRAM+$2B0,x
        cmp #CHAR_HALFBAR                               // check if the current air char is a half bar 
        bne ScoreHalfChar                               
        lda #CHAR_QUARTERBAR                            // if it is then change it to a quarter bar
        sta SCREENRAM+$2B0,x
        rts
ScoreHalfChar:
        lda #CHAR_SPACE                                 // if it's a quarter bar, then change it to a space
        sta SCREENRAM+$2B0,x
        dec air                                         // and decrease the air counter
        bne !Exit+
        inc currentLevel                                // once the air is depleted then increase the level
        lda currentLevel                                // number
        cmp #LAST_LEVEL+1
        bne NextLevel
        lda #$00                                        // if we're on the last level then reset it to the first level
        sta currentLevel
NextLevel:
        lda #GF_STATUS_INITLEVEL                        // intialise the next level
        sta gameStatus
!Exit:
        rts




