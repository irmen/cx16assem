%import textio
%import string
%zeropage basicsafe
%option no_sysinit

main {

    uword hash_buckets_ptr = memory("buckets", 128*32*2)

    sub start() {
        uword num_symbols=0
        txt.print("hashing starts...")
        c64.SETTIM(0,0,0)
        uword labelptr = &labels
        while @(labelptr)!=255 {
            ubyte hash = hash_symbol(labelptr)
            while @(labelptr) {
                labelptr++
            }
            labelptr++
            num_symbols++
        }
        uword time = c64.RDTIM16()

        txt.print("done.\n")
        txt.print_uw(num_symbols)
        txt.print(" symbols, ")
        txt.print_uw(time)
        txt.print(" jiffies.\n")
    }

    asmsub hash_symbol(uword labelptr @AY) clobbers(X, Y) -> ubyte @A {
        ;  hash = range 0..127  calculated as:   ((c0 + clast + length) ^ (c1*4)) & 127
        %asm {{
            sta  P8ZP_SCRATCH_W1
            sty  P8ZP_SCRATCH_W1+1
            ldy  #0
            lda  (P8ZP_SCRATCH_W1),y
            sta  P8ZP_SCRATCH_W2        ; first char of symbol
            iny
            lda  (P8ZP_SCRATCH_W1),y
            sta  P8ZP_SCRATCH_W2+1      ; second char of symbol
            beq  _onechar

_loop       iny
            lda  (P8ZP_SCRATCH_W1),y
            bne  _loop
            dey
            lda  (P8ZP_SCRATCH_W1),y    ; last char of symbol
_onechar
            sec                         ; compensate for length being 1 off
            adc  P8ZP_SCRATCH_W2
            sty  P8ZP_SCRATCH_B1        ; length
            adc  P8ZP_SCRATCH_B1
            asl  P8ZP_SCRATCH_W2+1
            asl  P8ZP_SCRATCH_W2+1
            eor  P8ZP_SCRATCH_W2+1
            and  #127
            rts

        }}
    }
}

labels {
    %option force_output

    %asmbinary "labels.bin"
    %asm {{
        .byte 255,255,255,255
    }}

}
