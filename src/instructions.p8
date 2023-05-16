instructions {
    const ubyte am_Invalid = 0
    const ubyte am_Imp = 1
    const ubyte am_Acc = 2
    const ubyte am_Imm = 3
    const ubyte am_Zp = 4
    const ubyte am_ZpX = 5
    const ubyte am_ZpY = 6
    const ubyte am_Rel = 7
    const ubyte am_Abs = 8
    const ubyte am_AbsX = 9
    const ubyte am_AbsY = 10
    const ubyte am_Ind = 11
    const ubyte am_IzX = 12
    const ubyte am_IzY = 13
    const ubyte am_Zpr = 14
    const ubyte am_Izp = 15
    const ubyte am_IaX = 16

    ; NOTE: this prefix-tree mnemonic matcher is already very fast, it is a fraction of the time that's needed
    ;       to process the full line. It's not really productive to try to optimize this routine any more for speed.

    asmsub  match(uword mnemonic_ptr @AY) -> uword @AY {
        ; -- input: mnemonic_ptr in AY,   output:  pointer to instruction info structure or $0000 in AY
        %asm {{
            phx
            sta  P8ZP_SCRATCH_W1
            sty  P8ZP_SCRATCH_W1+1
            ldy  #1
            lda  (P8ZP_SCRATCH_W1),y
            and  #$7f       ; lowercase
            tax             ; second letter in X
            iny
            lda  (P8ZP_SCRATCH_W1),y
            and  #$7f       ; lowercase
            pha             ; save 3rd letter
            iny
            lda  (P8ZP_SCRATCH_W1),y
            and  #$7f       ; lowercase
            sta  cx16.r4    ; fourth letter in R4 (only exists for the few 4-letter mnemonics)
            iny
            lda  (P8ZP_SCRATCH_W1),y
            and  #$7f       ; lowercase
            sta  cx16.r5    ; fifth letter in R5 (should always be zero or whitespace for a valid mnemonic)
            ply             ; third letter in Y
            lda  (P8ZP_SCRATCH_W1)
            and  #$7f       ; lowercase, first letter in A
            jsr  get_opcode_info
            plx
            rts
        }}
    }

    asmsub  opcode(uword instr_info_ptr @AY, ubyte addr_mode @X) clobbers(X) -> ubyte @A, bool @Pc {
        ; -- input: instruction info struct ptr @AY,  desired addr_mode @X
        ;    output: opcode @A,   valid @carrybit
        %asm {{
            cpy  #0
            beq  _not_found
            sta  P8ZP_SCRATCH_W2
            sty  P8ZP_SCRATCH_W2+1
            stx  cx16.r5

            ; debug result address
            ;sec
            ;jsr  txt.print_uwhex
            ;lda  #13
            ;jsr  cbm.CHROUT

            lda  (P8ZP_SCRATCH_W2)
            beq  _multi_addrmodes
            ldy  #1
            lda  (P8ZP_SCRATCH_W2),y
            cmp  cx16.r5               ; check single possible addr.mode
            bne  _not_found
            iny
            lda  (P8ZP_SCRATCH_W2),y    ; get opcode
            sec
            rts

_not_found  lda  #0
            clc
            rts

_multi_addrmodes
            ldy  cx16.r5
            lda  (P8ZP_SCRATCH_W2),y    ; check opcode for addr.mode
            bne  _valid
            ; opcode $00 usually means 'invalid' but for "brk" it is actually valid so check for "brk"
            lda  (P8ZP_SCRATCH_W1)
            and  #$7f       ; lowercase
            cmp  #'b'
            bne  _not_found
            ldy  #1
            lda  (P8ZP_SCRATCH_W1),y
            and  #$7f       ; lowercase
            cmp  #'r'
            bne  _not_found
            iny
            lda  (P8ZP_SCRATCH_W1),y
            and  #$7f       ; lowercase
            cmp  #'k'
            bne  _not_found
            lda  #0
_valid      sec
            rts
        }}
    }

    ; The actual mnemonic matching routine is automatically generated
    ; from a table of mnemonics.
    ; Currently this is a prefix-tree matching routine that expects
    ; the three letters of the mnemonic to be in registers A,X,Y
    ; which covers most of the instructions (only a few have 4 letters)
    %asminclude "opcodes.asm"
}
