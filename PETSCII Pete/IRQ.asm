IRQ_Initialise:
        sei
        lda #<IRQ_Main
        sta IRQVECTORLO                 // set up main interrupt routine
        lda #>IRQ_Main
        sta IRQVECTORHI

        lda #<NMI_Disable
        sta NMIVECTORLO                 // set up NMI interrupt routine
        lda #>NMI_Disable
        sta NMIVECTORHI

        lda #$FA
        sta RASTER                      // set interrupt to trigger at line 250
        lda VCR1
        and #%01111111                  // clear raster MSB
        sta VCR1

        lda #$01
        sta IRQMR                       // enable raster interrupts
        asl VICINT                      // acknowledge interrupt
        cli
        rts


NMI_Disable:
        rti                             // forces runstop/restore to do nothing


IRQ_Main:
        pha
        lda #$01
        sta gameFlag                    // flag interrupt has occurred
        lda #$FA
        sta RASTER                      // set interrupt to trigger at line 250
        lda VCR1
        and #%01111111                  // clear raster MSB
        sta VCR1
        pla
        asl VICINT                      // acknowledge interrupt
        jmp krnInterruptNoKey           // jump to kernal routine excluding keyboard input
        
