.label IOPORT                           = $0001 // Processor port 

.label IRQVECTORLO                      = $0314 // IRQ interrupt address lo-byte
.label IRQVECTORHI                      = $0315 // IRQ interrupt address hi-bytes

.label NMIVECTORLO                      = $0318 // NMI interrupt address lo-byte
.label NMIVECTORHI                      = $0319 // NMI interrupt address hi-bytes

.label SPRITE_DATA1                     = $0340
.label SPRITE_DATA2                     = $0380

.label SCREENRAM                        = $0400 // Start of screen ram

.label SPRPTR0                          = $07F8 // Sprite 0 pointer
.label SPRPTR1                          = $07F9 // Sprite 1 pointer
.label SPRPTR2                          = $07FA // Sprite 2 pointer
.label SPRPTR3                          = $07FB // Sprite 3 pointer
.label SPRPTR4                          = $07FC // Sprite 4 pointer
.label SPRPTR5                          = $07FD // Sprite 5 pointer
.label SPRPTR6                          = $07FE // Sprite 6 pointer
.label SPRPTR7                          = $07FF // Sprite 7 pointer

.label basSTROUT                        = $AB1E

.label SPRX0                            = $D000 // Sprite 0 x-position
.label SPRY0                            = $D001 // Sprite 0 y-position
.label SPRX1                            = $D002 // Sprite 1 x-position
.label SPRY1                            = $D003 // Sprite 1 y-position
.label SPRX2                            = $D004 // Sprite 2 x-position
.label SPRY2                            = $D005 // Sprite 2 y-position
.label SPRX3                            = $D006 // Sprite 3 x-position
.label SPRY3                            = $D007 // Sprite 3 y-position
.label SPRX4                            = $D008 // Sprite 4 x-position
.label SPRY4                            = $D009 // Sprite 4 y-position
.label SPRX5                            = $D00A // Sprite 5 x-position
.label SPRY5                            = $D00B // Sprite 5 y-position
.label SPRX6                            = $D00C // Sprite 6 x-position
.label SPRY6                            = $D00D // Sprite 6 y-position
.label SPRX7                            = $D00E // Sprite 7 x-position
.label SPRY7                            = $D00F // Sprite 7 y-position
.label SPRXMSB                          = $D010 // Sprite x most significant bit
.label VCR1                             = $D011 // Screen control register #1
.label RASTER                           = $D012 // Raster read/write
.label SPREN                            = $D015 // Sprite display enable
.label VCR2                             = $D016 // Screen control register #2
.label SPRYEX                           = $D017 // Sprite Y vertical expand
.label VMCR                             = $D018 // VIC memory control register
.label VICINT                           = $D019 // Interrupt status register
.label IRQMR                            = $D01A // Interrupt control register
.label SPRPTY                           = $D01B // Sprite priority with background
.label SPRMCS                           = $D01C // Sprite multi-colour select
.label SPRXEX                           = $D01D // Sprite X horizontal expand
.label SPRCSP                           = $D01E // Sprite to sprite collision
.label SPRCBG                           = $D01F // Sprite to background collision
.label BDCOL                            = $D020 // Screen border colour
.label BGCOL0                           = $D021 // Screen background colour 0

.label SPRMC0                           = $D025 // Sprite multi-colour register 1
.label SPRMC1                           = $D026 // Sprite multi-colour register 2
.label SPRCOL0                          = $D027 // Sprite 0 colour
.label SPRCOL1                          = $D028 // Sprite 1 colour
.label SPRCOL2                          = $D029 // Sprite 2 colour 
.label SPRCOL3                          = $D02A // Sprite 3 colour
.label SPRCOL4                          = $D02B // Sprite 4 colour
.label SPRCOL5                          = $D02C // Sprite 5 colour
.label SPRCOL6                          = $D02D // Sprite 6 colour
.label SPRCOL7                          = $D02E // Sprite 7 colour

.label V1FREL                           = $D400
.label V1FREH                           = $D401
.label V1PWL                            = $D402
.label V1PWH                            = $D403
.label V1CR                             = $D404
.label ATTDCY1                          = $D405
.label SUSREL1                          = $D406
.label V2FREL				= $D407
.label V2FREH				= $D408
.label V2CR                             = $D40B
.label ATTDCY2				= $D40C
.label SUSREL2				= $D40D
.label V3FREL                           = $D40E
.label V3FREH                           = $D40F
.label V3PWL                            = $D410
.label V3PWH                            = $D411
.label V3CR                             = $D412
.label ATTDCY3                          = $D413
.label SUSREL3                          = $D414

.label SIDVOL                           = $D418 // Volume
.label SIDRAND                          = $D41B

.label COLOURRAM                        = $D800 // Start of colour ram

.label CIAPRA                           = $DC00 // CIA port A
.label CIAPRB                           = $DC01 // CIA port B
.label DDRA                             = $DC02 // Data direction register port A

.label ICSR1                            = $DC0D // Interrupt control and status register
.label ICSR2                            = $DD0D // Interrupt control and status register 2

.label krnInterrupt                     = $EA31
.label krnInterruptNoKey		= $EA81
.label krnSETMSG                        = $FE18
.label krnREADST                        = $FFB7
.label krnSETLFS                        = $FFBA
.label krnSETNAM                        = $FFBD
.label krnOPEN                          = $FFC0
.label krnCLOSE                         = $FFC3
.label krnCHKIN                         = $FFC6
.label krnCHKOUT                        = $FFC9
.label krnCLRCHN                        = $FFCC
.label krnCHRIN                         = $FFCF
.label krnCHROUT                        = $FFD2
.label krnLOAD                          = $FFD5
.label krnSAVE                          = $FFD8
.label krnPLOT                          = $FFF0
