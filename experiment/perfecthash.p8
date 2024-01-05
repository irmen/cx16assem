%import textio
%import string
%zeropage basicsafe

; based on output of gperf in perfecthashmnem.c

main {
    sub start() {

        txt.print("num words: ")
        txt.print_ub(len(perfecthash.wordlist))
        txt.nl()
        txt.print("num lookups: ")
        txt.print_ub(len(perfecthash.lookup))
        txt.nl()
        txt.print("num asso_values: ")
        txt.print_ub(len(perfecthash.asso_values))
        txt.nl()

        try("qqq")
        try("lda")
        try("bbs7")
        try("rts")
        try("rtq")

        sub try(str candidate) {
            ubyte hh = perfecthash.hash(candidate, string.length(candidate))
            ubyte index = perfecthash.match(candidate)
            txt.print_ub(hh)
            txt.spc()
            txt.print_ub(index)
            txt.spc()
            if index!=255 {
                txt.print(perfecthash.wordlist[index])
            } else {
                txt.print("invalid!")
            }
            txt.nl()
        }
    }
}

perfecthash {

    str[] wordlist = [
        "php",
        "ror",
        "stp",
        "rts",
        "rti",
        "txs",
        "phy",
        "trb",
        "eor",
        "sty",
        "phx",
        "tsb",
        "tay",
        "stx",
        "brk",
        "lsr",
        "tax",
        "tsx",
        "pha",
        "plp",
        "bra",
        "sta",
        "rol",
        "bcs",
        "sei",
        "txa",
        "ldy",
        "ply",
        "iny",
        "ldx",
        "plx",
        "nop",
        "inx",
        "cli",
        "asl",
        "sbc",
        "bmi",
        "lda",
        "pla",
        "ora",
        "bne",
        "adc",
        "bbs7",
        "bbr7",
        "cmp",
        "cpy",
        "inc",
        "sec",
        "bcc",
        "cpx",
        "bpl",
        "dey",
        "tya",
        "clv",
        "dex",
        "clc",
        "bbs6",
        "bbr6",
        "bbs5",
        "bbr5",
        "smb7",
        "rmb7",
        "stz",
        "sed",
        "bbs4",
        "bbr4",
        "dec",
        "bbs3",
        "bbr3",
        "bbs2",
        "bbr2",
        "and",
        "cld",
        "bbs1",
        "bbr1",
        "beq",
        "smb6",
        "rmb6",
        "smb5",
        "rmb5",
        "bbs0",
        "bbr0",
        "bvs",
        "wai",
        "smb4",
        "rmb4",
        "jsr",
        "smb3",
        "rmb3",
        "smb2",
        "rmb2",
        "bit",
        "smb1",
        "rmb1",
        "smb0",
        "rmb0",
        "bvc",
        "jmp"
    ]

    byte[] lookup = [
        -1, 0, -1, 1, 2, 3, -1, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
        25, 26, 27, -1, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37,
        38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, -1, 50,
        51, 52, -1, 53, 54, 55, -1, 56, 57, 58, 59, -1, 60, 61,
        62, 63, 64, 65, 66, 67, 68, 69, 70, 71, -1, 72, 73, 74,
        75, 76, 77, 78, 79, 80, 81, 82, -1, 83, 84, 85, 86, 87,
        88, 89, 90, 91, -1, -1, 92, 93, -1, -1, -1, -1, -1, 94,
        95, -1, -1, -1, -1, 96, -1, -1, -1, -1, -1, -1, -1, 97
    ]

    ubyte[] asso_values = [
        126, 126, 126, 126, 126, 126, 126, 126, 126, 126,
        126, 126, 126, 126, 126, 126, 126, 126, 126, 126,
        126, 126, 126, 126, 126, 126, 126, 126, 126, 126,
        126, 126, 126, 126, 126, 126, 126, 126, 126, 126,
        126, 126, 126, 126, 126, 126, 126, 126, 73, 66,
        61, 59, 56, 49, 47, 30, 126, 126, 126, 126,
        126, 126, 126, 126, 126, 10, 3, 13, 23, 9,
        25, 126, 126, 1, 90, 7, 12, 22, 35, 23,
        0, 28, 1, 0, 4, 4, 12, 88, 6, 4,
        33, 126, 126, 126, 126, 126, 126, 126, 126, 126,
        126, 126, 126, 126, 126, 126, 126, 126, 126, 126,
        126, 126, 126, 126, 126, 126, 126, 126, 126, 126,
        126, 126, 126, 126, 126, 126, 126, 126, 126
    ]

    const ubyte MAX_HASH_VALUE = 125

    asmsub hash(str candidate @AY, ubyte length @X) -> ubyte @A {
        %asm {{
            sta  P8ZP_SCRATCH_W1
            sty  P8ZP_SCRATCH_W1+1
            ldy  #2
            lda  (P8ZP_SCRATCH_W1),y
            tay
            lda  p8v_asso_values,y
            sta  _result
            dey
            lda  (P8ZP_SCRATCH_W1),y
            ina
            tay
            lda  p8v_asso_values,y
            clc
            adc  _result
            sta  _result
            lda  (P8ZP_SCRATCH_W1)
            tay
            lda  p8v_asso_values,y
            clc
            adc  _result
            sta  _result
            dex
            txa
            tay
            lda  (P8ZP_SCRATCH_W1),y
            tay
            lda  p8v_asso_values,y
            clc
            adc  _result
            rts
_result     .byte 0
        }}
    }

    sub hash_old(str candidate, ubyte length) -> ubyte {
        ubyte hv = asso_values[candidate[2]]
        hv += asso_values[candidate[1] + 1]
        hv += asso_values[candidate[0]]
        hv += asso_values[candidate[length - 1]]
        return hv
    }

    sub match(str candidate) -> ubyte {
        ubyte length = string.length(candidate)
        if length==3 or length==4 {
            ubyte key = hash(candidate, length)
            if key <= MAX_HASH_VALUE {
                byte index = lookup[lsb(key)]
                if index >= 0 {
                    uword matched = wordlist[index]
                    if matched[0]==candidate[0] and matched[1]==candidate[1] and matched[2]==candidate[2] and matched[3]==candidate[3]
                        return index as ubyte
                }
            }
        }
        return 255
    }


    asmsub  opcode(uword instr_info_ptr @AY, ubyte addr_mode @X) clobbers(X) -> ubyte @A, bool @Pc {
        ; -- input: instruction info struct ptr @AY,  desired addr_mode @X
        ;    output: opcode @A,   valid @carrybit
        %asm {{
            ; ..... stopped testing here as the code is already a lot slower than the prefix-tree matcher
            lda  #0
            sec
            rts
        }}
    }
}
