GameFlowUpdate:
        ldx gameStatus
        lda gfStatusJumpTableLo,x
        sta zpLow
        lda gfStatusJumpTableHi,x
        sta zpHigh
        jmp (zpLow)


GameFlowStatusMenu:
        jmp Initialise_StartGame


GameFlowStatusInitLevel:
        jsr Screen_DisplayLevelMain
        jsr Screen_DisplayLevelData
        jmp Player_InitLevelVariables


GameFlowStatusPlay:
        jsr Screen_FlashKeys
        jsr Player_GetInput
        jsr Player_Jump
        jsr Player_Fall
        jsr Player_FallCounter
        jsr Screen_UpdateSprites
        jsr Player_CheckCollision
        jsr Screen_UpdateAir
        jsr Enemy_Move
        jmp Enemy_CheckCollision


GameFlowStatusLoseLife:
        jmp Player_LoseLife
        

GameFlowStatusLevelComplete:
        lda #$08
        sta V2CR                                // disable voice 2
        jmp Player_Score


GameFlowStatusGameOver:
        jmp Screen_DisplayGameOver


