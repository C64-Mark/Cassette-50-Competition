tblLevel1:              .byte $06, $5D, $1D                                             // platforms
                        .byte $04, $D3, $17                                             // hi-byte, lo-byte, length
                        .byte $05, $1D, $02
                        .byte $05, $6D, $03
                        .byte $06, $1A, $04
                        .byte $05, $B1, $01
                        .byte $05, $E5, $07
                        .byte $00     

                        .byte $04, $DA, $08                                             // decaying platforms
                        .byte $05, $FB, $04                                             // hi-byte, lo-byte, length
                        .byte $00

                        .byte $05, $74, $11                                             // moving platforms
                        .byte $00                                                       // hi-byte, lo-byte, length

                        .byte $05, $55, $02                                             // walls
                        .byte $05, $F7, $03                                             // hi-byte, lo-byte, length
                        .byte $00

tblLevel1ExitKeys:      .byte $06, $29, $01                                             // exit
                        .byte $06, $51, $01                                             // hi-byte, lo-byte, length
                        .byte $00

                        .byte $04, $0D, $04, $3E, $04, $BC, $04, $21, $04, $FC          // keys
                        .byte $00                                                       // hi-byte, lo-byte

                        .byte $04, $0F, $04, $16, $00                                   // stalagmites: hi-byte, lo-byte

                        .byte $05, $8A, $05, $59, $04, $BB, $04, $BF, $00               // spikes: hi-byte, lo-byte

                        .byte $78, $6A, $B8, $00                                        // enemy start X, Y, end, direction


tblLevel2:              .byte $05, $95, $01
                        .byte $05, $E5, $03
                        .byte $06, $23, $07
                        .byte $05, $D5, $05
                        .byte $05, $87, $03
                        .byte $06, $5D, $1D
                        .byte $00

                        .byte $04, $F8, $03
                        .byte $05, $26, $0B
                        .byte $04, $D9, $05
                        .byte $00

                        .byte $05, $75, $0D
                        .byte $00

                        .byte $04, $F5, $02
                        .byte $06, $37, $05
                        .byte $00

tblLevel2ExitKeys:      .byte $05, $39, $01
                        .byte $05, $61, $01
                        .byte $00

                        .byte $04, $CD, $05, $6D, $04, $B5, $05, $03, $06, $51, $00

                        .byte $05, $1D, $00

                        .byte $04, $CF, $06, $47, $05, $AF, $00

                        .byte $80, $9A, $C8, $00

tblLevel3:              .byte $06, $5D, $1D
                        .byte $05, $6D, $02
                        .byte $04, $81, $01
                        .byte $04, $B0, $05
                        .byte $04, $97, $03
                        .byte $05, $5B, $07
                        .byte $05, $B1, $01
                        .byte $06, $01, $01
                        .byte $00

                        .byte $04, $B9, $04
                        .byte $04, $83, $01
                        .byte $04, $FB, $01
                        .byte $05, $73, $01
                        .byte $05, $EB, $01
                        .byte $00

                        .byte $05, $01, $06
                        .byte $00

                        .byte $05, $33, $02
                        .byte $06, $4F, $03
                        .byte $00

tblLevel3ExitKeys:      .byte $05, $11, $01
                        .byte $05, $39, $01
                        .byte $00

                        .byte $05, $45, $04, $0C, $05, $4B, $06, $44, $04, $22, $00

                        .byte $04, $10, $04, $1C, $00

                        .byte $05, $C3, $06, $43, $04, $6F, $00

                        .byte $60, $50, $9A, $02

tblLevel4:              .byte $06, $5D, $1D
                        .byte $05, $E9, $00
                        .byte $06, $14, $06
                        .byte $05, $AD, $02
                        .byte $05, $89, $01
                        .byte $04, $D1, $08
                        .byte $04, $DE, $04
                        .byte $04, $E7, $03
                        .byte $00

                        .byte $05, $CE, $04
                        .byte $05, $1D, $0D
                        .byte $00

                        .byte $05, $2E, $09
                        .byte $00

                        .byte $05, $BD, $01
                        .byte $05, $EF, $03
                        .byte $00

tblLevel4ExitKeys:      .byte $04, $CD, $01
                        .byte $04, $F5, $01
                        .byte $00

                        .byte $05, $45, $04, $34, $04, $3D, $04, $46, $05, $D6, $00

                        .byte $04, $0C, $04, $15, $04, $1E, $00

                        .byte $05, $C8, $04, $B8, $05, $62, $00

                        .byte $B8, $42, $9A, $02








