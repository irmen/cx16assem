%import test_stack
%import textio
%import floats
%zeropage basicsafe
%import instructions
%import perfecthash
%option no_sysinit


main {

    sub start() {
        test_stack.test()

        txt.print("\nassembler benchmark - tree match routine\n")
        benchmark.run()

        test_stack.test()
    }

}


benchmark {
    sub run() {
        str[107] mnemonics = [
            "adc", "adc", "and", "and", "and", "asl", "asl", "asl", "bcc", "bcs",
            "beq", "bit", "bit", "bit", "bmi", "bne", "bpl", "bra", "brk", "bvc",
            "bvs", "clc", "cld", "cli", "clv", "cmp", "cmp", "cmp", "cpx", "cpx",
            "cpy", "cpy", "cpy", "dec", "dec", "dec", "dex", "dey", "eor", "eor",
            "eor", "eor", "eor", "inc", "inc", "iny", "jmp", "jmp", "jsr", "lda",
            "lda", "lda", "ldx", "ldx", "ldy", "ldy", "lsr", "lsr", "lsr", "nop",
            "nop", "nop", "nop", "nop", "ora", "ora", "ora", "pha", "php", "phx",
            "phy", "pla", "plp", "plx", "ply", "rol", "rol", "ror", "ror", "rti",
            "rts", "sbc", "sbc", "sec", "sed", "sei", "sta", "sta", "sta", "stp",
            "stx", "stx", "sty", "sty", "stz", "stz", "tax", "tay", "trb", "trb",
            "tsb", "tsb", "tsx", "txa", "txs", "tya", "wai" ]
        ubyte[107] modes =   [
            12, 3, 13, 15, 8, 2, 5, 9, 7, 7,
            7, 3, 8, 9, 7, 7, 7, 7, 1, 7,
            7, 1, 1, 1, 1, 10, 13, 4, 3, 8,
            3, 4, 8, 2, 5, 9, 1, 1, 13, 15,
            3, 4, 9, 2, 5, 1, 11, 8, 8, 12,
            15, 9, 10, 6, 3, 9, 2, 4, 9, 1,
            3, 5, 8, 9, 12, 3, 9, 1, 1, 1,
            1, 1, 1, 1, 1, 2, 9, 2, 9, 1,
            1, 10, 9, 1, 1, 1, 10, 13, 8, 1,
            4, 8, 4, 8, 4, 9, 1, 1, 4, 8,
            4, 8, 1, 1, 1, 1, 1 ]


        const uword iterations = 60000 / len(mnemonics)
        amount = iterations * len(mnemonics)

        txt.print("\nmatching ")
        txt.print_uw(amount)
        txt.print(" mnemonics\n")
        ubyte idx
        ubyte opcode
        uword instr_info

        txt.print("\n**** module 'perfecthash' ****\n")
        repeat 1 {
            valid = 0
            total = 0
            cbm.SETTIM(0,0,0)
            repeat iterations {
                for idx in 0 to len(mnemonics)-1 {
                    instr_info = perfecthash.match(mnemonics[idx])
                    opcode = perfecthash.opcode(instr_info, modes[idx])
                    if_cs
                        valid++
                    total++
                }
            }
            report_time()
        }

        txt.print("\n**** module 'instructions' ****\n")
        repeat 1 {
            valid = 0
            total = 0
            cbm.SETTIM(0,0,0)
            repeat iterations {
                for idx in 0 to len(mnemonics)-1 {
                    instr_info = instructions.match(mnemonics[idx])
                    opcode = instructions.opcode(instr_info, modes[idx])
                    if_cs
                        valid++
                    total++
                }
            }
            report_time()
        }
    }

    uword valid
    uword total
    uword amount

    sub report_time() {
        uword current_time = cbm.RDTIM16()
        txt.print("invalid: ")
        txt.print_uw(amount-valid)
        txt.print("\ntotal: ")
        txt.print_uw(total)
        txt.print("\n>> seconds:")
        float secs = current_time / 60.0
        floats.print(secs)
        txt.print("   mnems/sec: ")
        floats.print(floats.round(total / secs))

        txt.nl()
    }
}
