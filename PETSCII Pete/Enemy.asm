Enemy_Move:
	dec enemyCounter
	bne !Exit+
	lda #ENEMY_RATE
	sta enemyCounter  			// sets update rate of enemy movemebt
	lda enemyDirection
	beq EnemyMoveRight 			// check current direction of enemy
	cmp #ENEMY_DIR_LEFT
	beq EnemyMoveLeft
	cmp #ENEMY_DIR_DOWN
	beq EnemyMoveDown
EnemyMoveUp:
	dec enemyY
	lda enemyY 				// move up until topmost location of
	cmp enemyStartY  			// movement pattern
	bne !Exit+
	lda #ENEMY_DIR_DOWN			// change direction to down
ChangeDirection:
	sta enemyDirection
        ldy #$40 				// offset for start of enemy sprite data
GetNextEnemyByte:
	jsr Screen_MirrorSprite 		// switch sprite image direction
        cpy #$70
        bne GetNextEnemyByte
	rts
EnemyMoveDown:
	inc enemyY
	lda enemyY 
	cmp enemyEnd 				// move down until bottom location of
	bne !Exit+	     			// movement pattern
	lda #ENEMY_DIR_UP
	bne ChangeDirection 			// change direction to up
EnemyMoveLeft:
	dec enemyX
	lda enemyX
	cmp enemyStartX 			// move left until at leftmost location of
	bne !Exit+				// movement pattern
	lda #ENEMY_DIR_RIGHT
	beq ChangeDirection 			// change direction to right
EnemyMoveRight:
	inc enemyX
	lda enemyX
	cmp enemyEnd 				// move right until at rightmost location of
	bne !Exit+	   			// movement pattern
	lda #ENEMY_DIR_LEFT
	bne ChangeDirection 			// change direction to left
!Exit:
	jmp Enemy_Animate



Enemy_Animate:
	dec enemyAnimCounter
	bne !Exit+
	lda #ENEMY_ANIM_RATE 			// set rate at which enemy animates
	sta enemyAnimCounter
        ldx #$00
        ldy #$00
        lda enemyFrame 				// alternative frames for enemy animation
        eor #$01
        sta enemyFrame
        beq !+
        ldx #$08
!:
        lda sprEnemyFrames,x 			// copies in data for alternate enemy frame
        sta SPRITE_DATA2+$018,y 		// 24 bytes in memory covers two frames
        inx  					// of enemy sprite
        iny
        iny
        iny
        cpy #$18
        bne !-

        lda enemyDirection
        beq !Exit+
        cmp #ENEMY_DIR_DOWN
        beq !Exit+				// frames stored are facing right and down
        ldy #$58  				// if other directions then we mirror
        jmp GetNextEnemyByte 			// the sprite image
!Exit:
	rts



Enemy_CheckCollision:
	lda SPRCSP
	bne HitPlayer 				// simple sprite collision
	rts 					// if sprites have collided then player
HitPlayer: 					// has collided with enemy and loses life
        lda #GF_STATUS_LOSE_LIFE
        sta gameStatus
        rts
