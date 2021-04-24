// 254 zero page bytes free for variables
// 18 bytes at $1ed for variables
#import "Constants.asm"
#import "IO.asm"
#import "zpVariables.asm"

*=$0120
Start:
        sei
        lda #%01111111
        sta ICSR1
        sta ICSR2                       // disable all interrupts
        cli
        ldx #$1F 
        txs
        jsr Initialise_Game             // set up the game
        jsr IRQ_Initialise              // set up the interrupt
       
GameLoop:
        lda gameFlag
        beq GameLoop                   // loop until the IRQ triggers the gameflag
        dec gameFlag

        jsr GameFlowUpdate
        jmp GameLoop

txtStats:               .text "high score 000000   score 000000"
txtAir:                 .text "air"
txtTitle:               .text "    petscii pete by c64 mark   "
txtGameOver:            .text " game over.  press fire "

tblScreenRowLo:         .byte $00, $28, $50, $78, $A0, $C8, $F0, $18
                        .byte $40, $68, $90, $B8, $E0, $08, $30, $58
                        .byte $80, $A8, $D0, $F8, $20, $48, $70, $98, $C0

tblScreenRowHi:         .byte $04, $04, $04, $04, $04, $04, $04, $05
                        .byte $05, $05, $05, $05, $05, $06, $06, $06
                        .byte $06, $06, $06, $06, $07, $07, $07, $07, $07

gfStatusJumpTableLo:    .byte <GameFlowStatusMenu
                        .byte <GameFlowStatusInitLevel
                        .byte <GameFlowStatusPlay
                        .byte <GameFlowStatusLoseLife
                        .byte <GameFlowStatusLevelComplete
                        .byte <GameFlowStatusGameOver

gfStatusJumpTableHi:    .byte >GameFlowStatusMenu
                        .byte >GameFlowStatusInitLevel
                        .byte >GameFlowStatusPlay
                        .byte >GameFlowStatusLoseLife
                        .byte >GameFlowStatusLevelComplete
                        .byte >GameFlowStatusGameOver

Player_LoseLife:
        lda #$00
        sta V1CR
        sta V2CR                            // turn off sound
        jsr Sound_Death                     // play death sound
        lda #GF_STATUS_INITLEVEL  
        dec lives
        bpl ExitLoseLife
        lda #GF_STATUS_GAMEOVER             // if lives left then init level, or gameover
ExitLoseLife:
        sta gameStatus
        rts

*=$01ED
    //runtime vars - 11 bytes

*=$01F8  //Override return from load vector on stack         
                        .byte <[Start-1], >[Start-1]

*=$0200
#import "Gameflow.asm"
#import "IRQ.asm"

// 2 bytes

*=$028f
                        .byte $48, $EB //Prevent keyboard jam

//16 bytes
//02A1 overwritten with zero

*=$02A2
#import "Initialise.asm"


// Routine to test how far a player has fallen. Start counting once the player has fallen and continues
// to count until the player stops falling (fallEnable = 0)
// If fallcounter >= 40 when the player "lands" then they have fallen too far and lose a life
Player_FallCounter:
        lda fallEnable
        beq CheckFallCounter
        inc fallCounter
        rts
CheckFallCounter:
        lda fallCounter
        cmp #$28
        bcc !Exit+
        lda #GF_STATUS_LOSE_LIFE
        sta gameStatus
!Exit:
        lda #$00
        sta fallCounter
        rts

        
//7 bytes

*=$0314 //IRQ, BRK and NMI Vectors
                        .byte $31, $EA, $66, $FE, $47, $FE
                        .byte $4A, $F3, $91, $F2, $0E, $F2, $50, $F2
                        .byte $33, $F3, $57, $F1, $CA, $F1, $ED, $F6

*=$032A
tblLevelDataLo:         .byte <tblLevel1, <tblLevel2, <tblLevel3, <tblLevel4
tblLevelDataHi:         .byte >tblLevel1, >tblLevel2, >tblLevel3, >tblLevel4

tblExitKeysDataLo:      .byte <tblLevel1ExitKeys, <tblLevel2ExitKeys, <tblLevel3ExitKeys, <tblLevel4ExitKeys
tblExitKeysDataHi:      .byte >tblLevel1ExitKeys, >tblLevel2ExitKeys, >tblLevel3ExitKeys, >tblLevel4ExitKeys

//6 bytes

*=$03C0
sprMinerInit:           .byte $06, $3E, $7C, $34, $3E, $3C, $18, $3C            // head facing right
sprMinerFrames:         .byte $6E, $6E, $6E, $76, $3C, $18, $18, $1C            // legs frame 1
                        .byte $7E, $7E, $F7, $FB, $3C, $76, $6E, $77            // legs frame 2

sprEnemyInit:           .byte $79, $EF, $6F, $39, $7C, $FE, $FF, $FF            // head facing right
sprEnemyFrames:         .byte $FF, $FF, $7E, $38, $38, $38, $7C, $00            // body frame 1
                        .byte $F0, $FF, $7E, $38, $38, $38, $38, $7C            // body frame 2

tblLives:               .byte $00, $02, $06
tblSoftPlatChars:       .byte $77, $63, $45, $44, $43, $46, $52, $6F, $20

// 4 bytes

*=$0400
    .fill $3E8, $20 

*=$07E8
tblJumpY:               .byte $04, $04, $03, $03, $02, $02, $01, $01
                        .byte $FF, $FF, $FE, $FE, $FD, $FD, $FC, $FC

*=$07FC
#import "Screen.asm"
#import "Player.asm"
#import "Enemy.asm"
#import "Sound.asm"
#import "LevelData.asm"